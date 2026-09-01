/*=============================================================================
 @file              src/12-media/1296_tps_broadcast_admin_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-03/04/14/18
 @workstream        Broadcast network/station/channel/program/media administration
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package body; routines perform caller-owned R2 DML
 @purpose           Implement canonical media onboarding and D3KA affiliation operations.
 @business_impact   Makes the media model operable through PL/SQL rather than direct ad-hoc DML.
 @objects           Creates/replaces TPS_BROADCAST_ADMIN_PKG body.
 @dependencies      Package specification and media/D3KA kernel tables/packages.
 @upstream          Calls through TPS_BROADCAST_ADMIN_PKG.
 @downstream        Canonical entities, station/channel/program/asset projections, D3KA affiliation.
 @d3ka_role         ENTITY/RELATION
 @d3ka_links        Creates entities and AFFILIATED_WITH relation cells.
 @ai_role           No model calls. Administrative execution remains separately authorized.
 @security          AUTHID DEFINER; validates type/state before writes.
 @performance       Point-key lookups and one-row writes only.
 @transaction       No COMMIT/ROLLBACK; caller owns transaction.
 @idempotency       Stable keys and existing-projection detection make calls repeatable.
 @failure_modes     Custom -207xx errors plus Oracle constraint/privilege errors.
 @rollback_recovery Caller rollback before commit; committed identities are lifecycle-managed.
 @tests             INT-010 and COMP-003.
 @evidence          CORE-03/04/14.
 @references        Oracle AI Database 26ai PL/SQL Language Reference.
 @links             src/12-media/1295_tps_broadcast_admin_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial implementation; validation hardened.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_broadcast_admin_pkg AS

  FUNCTION ensure_entity(
      p_type_code       IN VARCHAR2,
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2
  ) RETURN NUMBER IS
    l_type_id     NUMBER;
    l_entity_id   NUMBER;
    l_existing_type VARCHAR2(100);
    l_state       VARCHAR2(30);
  BEGIN
    IF TRIM(p_canonical_key) IS NULL OR TRIM(p_canonical_name) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20701,'TPS_BROADCAST_ENTITY_KEY_NAME_REQUIRED');
    END IF;

    SELECT entity_type_id
      INTO l_type_id
      FROM tps_entity_type
     WHERE type_code = UPPER(TRIM(p_type_code))
       AND lifecycle_state = 'ACTIVE';

    BEGIN
      SELECT e.entity_id, et.type_code, e.state
        INTO l_entity_id, l_existing_type, l_state
        FROM tps_entity e
        JOIN tps_entity_type et ON et.entity_type_id=e.entity_type_id
       WHERE e.canonical_key=TRIM(p_canonical_key)
       FOR UPDATE OF e.canonical_name;

      IF l_existing_type <> UPPER(TRIM(p_type_code)) THEN
        RAISE_APPLICATION_ERROR(-20702,'TPS_BROADCAST_ENTITY_TYPE_CONFLICT');
      END IF;
      IF l_state <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20703,'TPS_BROADCAST_ENTITY_NOT_ACTIVE');
      END IF;

      UPDATE tps_entity
         SET canonical_name = TRIM(p_canonical_name),
             updated_at = SYSTIMESTAMP,
             updated_by = SYS_CONTEXT('USERENV','SESSION_USER'),
             row_version = row_version + 1
       WHERE entity_id = l_entity_id
         AND canonical_name <> TRIM(p_canonical_name);

      RETURN l_entity_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_entity(entity_type_id,canonical_key,canonical_name)
        VALUES(l_type_id,TRIM(p_canonical_key),TRIM(p_canonical_name))
        RETURNING entity_id INTO l_entity_id;
        RETURN l_entity_id;
    END;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20704,'TPS_BROADCAST_ACTIVE_ENTITY_TYPE_NOT_FOUND:'||UPPER(TRIM(p_type_code)));
  END ensure_entity;

  FUNCTION register_network(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2
  ) RETURN NUMBER IS
  BEGIN
    RETURN ensure_entity('NETWORK',p_canonical_key,p_canonical_name);
  END register_network;

  FUNCTION register_station(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2,
      p_station_kind    IN VARCHAR2,
      p_timezone_name   IN VARCHAR2,
      p_country_code    IN VARCHAR2 DEFAULT 'BRA'
  ) RETURN NUMBER IS
    l_entity_id NUMBER;
    l_kind VARCHAR2(20) := UPPER(TRIM(p_station_kind));
    l_existing_kind VARCHAR2(20);
  BEGIN
    IF l_kind IS NULL OR l_kind NOT IN ('RADIO','TV') THEN
      RAISE_APPLICATION_ERROR(-20710,'TPS_BROADCAST_STATION_KIND_MUST_BE_RADIO_OR_TV');
    END IF;
    IF TRIM(p_timezone_name) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20711,'TPS_BROADCAST_STATION_TIMEZONE_REQUIRED');
    END IF;

    l_entity_id := ensure_entity(CASE l_kind WHEN 'RADIO' THEN 'RADIO_STATION' ELSE 'TV_STATION' END,
                                 p_canonical_key,p_canonical_name);

    BEGIN
      SELECT station_kind INTO l_existing_kind
        FROM tps_station
       WHERE station_entity_id=l_entity_id
       FOR UPDATE;
      IF l_existing_kind <> l_kind THEN
        RAISE_APPLICATION_ERROR(-20712,'TPS_BROADCAST_STATION_KIND_CONFLICT');
      END IF;
      UPDATE tps_station
         SET default_timezone=TRIM(p_timezone_name),
             country_code=UPPER(TRIM(p_country_code))
       WHERE station_entity_id=l_entity_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_station(station_entity_id,station_kind,default_timezone,country_code)
        VALUES(l_entity_id,l_kind,TRIM(p_timezone_name),UPPER(TRIM(p_country_code)));
    END;
    RETURN l_entity_id;
  END register_station;

  FUNCTION register_channel(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2,
      p_channel_kind    IN VARCHAR2,
      p_service_key     IN VARCHAR2,
      p_timezone_name   IN VARCHAR2
  ) RETURN NUMBER IS
    l_entity_id NUMBER;
    l_existing_kind VARCHAR2(30);
  BEGIN
    IF TRIM(p_channel_kind) IS NULL OR TRIM(p_timezone_name) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20720,'TPS_BROADCAST_CHANNEL_KIND_TIMEZONE_REQUIRED');
    END IF;
    l_entity_id := ensure_entity('CHANNEL',p_canonical_key,p_canonical_name);
    BEGIN
      SELECT channel_kind INTO l_existing_kind
        FROM tps_channel
       WHERE channel_entity_id=l_entity_id
       FOR UPDATE;
      IF l_existing_kind <> UPPER(TRIM(p_channel_kind)) THEN
        RAISE_APPLICATION_ERROR(-20721,'TPS_BROADCAST_CHANNEL_KIND_CONFLICT');
      END IF;
      UPDATE tps_channel
         SET service_key=TRIM(p_service_key),
             default_timezone=TRIM(p_timezone_name)
       WHERE channel_entity_id=l_entity_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_channel(channel_entity_id,channel_kind,service_key,default_timezone)
        VALUES(l_entity_id,UPPER(TRIM(p_channel_kind)),TRIM(p_service_key),TRIM(p_timezone_name));
    END;
    RETURN l_entity_id;
  END register_channel;

  FUNCTION register_program(
      p_canonical_key        IN VARCHAR2,
      p_canonical_name       IN VARCHAR2,
      p_program_format       IN VARCHAR2,
      p_default_duration_sec IN NUMBER DEFAULT NULL,
      p_editorial_rating     IN VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER IS
    l_entity_id NUMBER;
  BEGIN
    IF p_default_duration_sec IS NOT NULL AND p_default_duration_sec <= 0 THEN
      RAISE_APPLICATION_ERROR(-20730,'TPS_BROADCAST_PROGRAM_DURATION_INVALID');
    END IF;
    l_entity_id := ensure_entity('PROGRAM',p_canonical_key,p_canonical_name);
    MERGE INTO tps_program p
    USING (SELECT l_entity_id program_entity_id FROM dual) s
       ON (p.program_entity_id=s.program_entity_id)
    WHEN MATCHED THEN UPDATE SET
         p.program_format=TRIM(p_program_format),
         p.default_duration_sec=p_default_duration_sec,
         p.editorial_rating=UPPER(TRIM(p_editorial_rating))
    WHEN NOT MATCHED THEN INSERT(program_entity_id,program_format,default_duration_sec,editorial_rating)
         VALUES(l_entity_id,TRIM(p_program_format),p_default_duration_sec,UPPER(TRIM(p_editorial_rating)));
    RETURN l_entity_id;
  END register_program;

  FUNCTION affiliate_station(
      p_station_entity_id IN NUMBER,
      p_network_entity_id IN NUMBER,
      p_valid_from        IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
    l_relation_id NUMBER;
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_count FROM tps_station
     WHERE station_entity_id=p_station_entity_id AND operational_state='ACTIVE';
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20740,'TPS_BROADCAST_ACTIVE_STATION_REQUIRED');
    END IF;

    SELECT COUNT(*) INTO l_count
      FROM tps_entity e JOIN tps_entity_type et ON et.entity_type_id=e.entity_type_id
     WHERE e.entity_id=p_network_entity_id AND e.state='ACTIVE' AND et.type_code='NETWORK';
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20741,'TPS_BROADCAST_ACTIVE_NETWORK_REQUIRED');
    END IF;

    BEGIN
      SELECT r.relation_id INTO l_relation_id
        FROM tps_relation r
        JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
       WHERE r.source_entity_id=p_station_entity_id
         AND r.target_entity_id=p_network_entity_id
         AND rt.relation_code='AFFILIATED_WITH'
         AND r.state='ACTIVE'
         AND r.valid_to IS NULL
       FETCH FIRST 1 ROW ONLY;
      RETURN l_relation_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_relation_id := tps_d3ka_pkg.assert_relation(
          p_source_entity_id => p_station_entity_id,
          p_relation_code => 'AFFILIATED_WITH',
          p_target_entity_id => p_network_entity_id,
          p_valid_from => p_valid_from,
          p_assertion_class => 'FACT'
        );
        RETURN l_relation_id;
    END;
  END affiliate_station;

  FUNCTION register_media_asset(
      p_asset_key          IN VARCHAR2,
      p_asset_name         IN VARCHAR2,
      p_content_entity_id  IN NUMBER,
      p_sha256_hex         IN VARCHAR2,
      p_storage_location   IN VARCHAR2,
      p_duration_ms        IN NUMBER DEFAULT NULL,
      p_mime_type          IN VARCHAR2 DEFAULT NULL,
      p_codec_video        IN VARCHAR2 DEFAULT NULL,
      p_codec_audio        IN VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER IS
    l_asset_entity_id NUMBER;
    l_media_asset_id NUMBER;
    l_count NUMBER;
    l_hash VARCHAR2(64) := LOWER(TRIM(p_sha256_hex));
  BEGIN
    IF l_hash IS NULL OR REGEXP_INSTR(l_hash,'^[0-9a-f]{64}$') <> 1 THEN
      RAISE_APPLICATION_ERROR(-20750,'TPS_BROADCAST_SHA256_INVALID');
    END IF;
    IF TRIM(p_storage_location) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20751,'TPS_BROADCAST_STORAGE_LOCATION_REQUIRED');
    END IF;
    IF p_duration_ms IS NOT NULL AND p_duration_ms <= 0 THEN
      RAISE_APPLICATION_ERROR(-20752,'TPS_BROADCAST_ASSET_DURATION_INVALID');
    END IF;

    SELECT COUNT(*) INTO l_count FROM tps_entity
     WHERE entity_id=p_content_entity_id AND state='ACTIVE';
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20753,'TPS_BROADCAST_ACTIVE_CONTENT_REQUIRED');
    END IF;

    l_asset_entity_id := ensure_entity('MEDIA_ASSET',p_asset_key,p_asset_name);

    BEGIN
      SELECT media_asset_id INTO l_media_asset_id
        FROM tps_media_asset
       WHERE sha256_hex=l_hash AND storage_location=TRIM(p_storage_location)
       FETCH FIRST 1 ROW ONLY;
      RETURN l_media_asset_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_media_asset(
          asset_entity_id,content_entity_id,sha256_hex,mime_type,codec_video,codec_audio,
          duration_ms,storage_location,lifecycle_state
        ) VALUES(
          l_asset_entity_id,p_content_entity_id,l_hash,TRIM(p_mime_type),TRIM(p_codec_video),TRIM(p_codec_audio),
          p_duration_ms,TRIM(p_storage_location),'ACTIVE'
        ) RETURNING media_asset_id INTO l_media_asset_id;
        RETURN l_media_asset_id;
    END;
  END register_media_asset;

END tps_broadcast_admin_pkg;
/
