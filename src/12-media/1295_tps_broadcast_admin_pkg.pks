/*=============================================================================
 @file              src/12-media/1295_tps_broadcast_admin_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-03/04/14/18
 @workstream        Broadcast network/station/channel/program/media administration
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package; routines perform caller-owned R2 DML
 @purpose           Provide one governed PL/SQL administration boundary for creating
                    canonical media entities and their station/channel/program/asset projections,
                    and for linking stations to networks through D3KA.
 @business_impact   Removes direct multi-table DML from applications and gives the media group
                    a usable transaction API for onboarding networks, stations, channels,
                    programs and playable assets.
 @objects           Creates/replaces TPS_BROADCAST_ADMIN_PKG specification.
 @dependencies      TPS_ENTITY_TYPE, TPS_ENTITY, TPS_STATION, TPS_CHANNEL, TPS_PROGRAM,
                    TPS_MEDIA_ASSET, TPS_D3KA_PKG, TPS_RELATION/TPS_RELATION_TYPE.
 @upstream          Admin/control-plane/API/migrations.
 @downstream        Programming, rights, continuity, playout APIs, D3KA/Graph.
 @d3ka_role         ENTITY/RELATION
 @d3ka_links        Creates canonical S/T entities and AFFILIATED_WITH S/R/T cells.
 @ai_role           AI may propose onboarding data but direct EXECUTE should remain human/admin
                    unless a separately bounded policy authorizes it.
 @security          AUTHID DEFINER; runtime applications should receive EXECUTE rather than
                    INSERT/UPDATE on canonical media tables.
 @performance       Point lookups/merges and single D3KA relation write; no bulk behavior.
 @transaction       No COMMIT/ROLLBACK. Caller owns transaction.
 @idempotency       Stable canonical keys and projection PKs make registration repeatable.
 @failure_modes     Missing/inactive entity type, key/type conflict, unsupported station kind,
                    invalid duration/hash, missing referenced content, D3KA validation errors.
 @rollback_recovery Caller rollback before commit; committed canonical entities use lifecycle
                    transitions rather than destructive deletion.
 @tests             tests/integration/INT-010_broadcast_end_to_end.sql;
                    tests/compile/COMP-003_broadcast_admin_playout.sql.
 @evidence          CORE-03/04/14 functional onboarding evidence.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; MERGE/DML RETURNING.
 @links             src/02-kernel/210_tps_entity.sql; src/03-d3ka/320_tps_d3ka_pkg.pks;
                    src/12-media/1200_tps_station.sql; src/12-media/1210_tps_channel.sql;
                    src/12-media/1220_tps_program.sql; src/12-media/1250_tps_media_asset.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial concrete broadcast administration API.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_broadcast_admin_pkg AUTHID DEFINER AS

  FUNCTION ensure_entity(
      p_type_code       IN VARCHAR2,
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2
  ) RETURN NUMBER;

  FUNCTION register_network(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2
  ) RETURN NUMBER;

  FUNCTION register_station(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2,
      p_station_kind    IN VARCHAR2,
      p_timezone_name   IN VARCHAR2,
      p_country_code    IN VARCHAR2 DEFAULT 'BRA'
  ) RETURN NUMBER;

  FUNCTION register_channel(
      p_canonical_key   IN VARCHAR2,
      p_canonical_name  IN VARCHAR2,
      p_channel_kind    IN VARCHAR2,
      p_service_key     IN VARCHAR2,
      p_timezone_name   IN VARCHAR2
  ) RETURN NUMBER;

  FUNCTION register_program(
      p_canonical_key        IN VARCHAR2,
      p_canonical_name       IN VARCHAR2,
      p_program_format       IN VARCHAR2,
      p_default_duration_sec IN NUMBER DEFAULT NULL,
      p_editorial_rating     IN VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER;

  FUNCTION affiliate_station(
      p_station_entity_id IN NUMBER,
      p_network_entity_id IN NUMBER,
      p_valid_from        IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

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
  ) RETURN NUMBER;

END tps_broadcast_admin_pkg;
/
