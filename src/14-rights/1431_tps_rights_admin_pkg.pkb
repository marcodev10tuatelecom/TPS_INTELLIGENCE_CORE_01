/*=============================================================================
 @file              src/14-rights/1431_tps_rights_admin_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-09/11/14/18
 @workstream        Rights/licensing administration
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package body; routines perform caller-owned R2 DML
 @purpose           Implement provenance-backed right grant/revoke operations.
 @business_impact   Makes rights setup operational while preserving fail-closed downstream decisions.
 @objects           Creates/replaces TPS_RIGHTS_ADMIN_PKG body.
 @dependencies      TPS_RIGHT_GRANT, TPS_ENTITY, TPS_SOURCE.
 @upstream          Calls through TPS_RIGHTS_ADMIN_PKG.
 @downstream        TPS_RIGHTS_PKG and programming/commercial authorization.
 @d3ka_role         POLICY/TEMPORAL/PROVENANCE
 @d3ka_links        Canonical content/beneficiary identities plus temporal/evidence dimensions.
 @ai_role           No AI calls; authority remains deterministic.
 @security          AUTHID DEFINER; validates references before DML.
 @performance       Point validation + exact-match lookup + one-row DML.
 @transaction       No COMMIT/ROLLBACK.
 @idempotency       Exact active grant is reused.
 @failure_modes     -20801..-20806 plus Oracle JSON/FK/constraint errors.
 @rollback_recovery Caller rollback; committed grants are revoked rather than deleted.
 @tests             INT-010 and COMP-003.
 @evidence          CORE-09/11/14.
 @references        Oracle AI Database 26ai PL/SQL/SQL Language Reference.
 @links             src/14-rights/1430_tps_rights_admin_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_rights_admin_pkg AS

  FUNCTION grant_right(
      p_content_entity_id       IN NUMBER,
      p_beneficiary_entity_id   IN NUMBER,
      p_action_code             IN VARCHAR2,
      p_valid_from              IN TIMESTAMP WITH TIME ZONE,
      p_valid_to                IN TIMESTAMP WITH TIME ZONE,
      p_decision                IN VARCHAR2,
      p_source_id               IN NUMBER,
      p_rights_holder_entity_id IN NUMBER DEFAULT NULL,
      p_territory_entity_id     IN NUMBER DEFAULT NULL,
      p_context_id              IN NUMBER DEFAULT NULL,
      p_restrictions_json       IN CLOB DEFAULT NULL
  ) RETURN NUMBER IS
    l_id NUMBER;
    l_count NUMBER;
    l_action VARCHAR2(100) := UPPER(TRIM(p_action_code));
    l_decision VARCHAR2(10) := UPPER(TRIM(p_decision));
  BEGIN
    IF l_action IS NULL THEN
      RAISE_APPLICATION_ERROR(-20801,'TPS_RIGHTS_ACTION_REQUIRED');
    END IF;
    IF p_valid_from IS NULL OR p_valid_to IS NULL OR p_valid_to <= p_valid_from THEN
      RAISE_APPLICATION_ERROR(-20802,'TPS_RIGHTS_VALIDITY_INVALID');
    END IF;
    IF l_decision NOT IN ('ALLOW','DENY') THEN
      RAISE_APPLICATION_ERROR(-20803,'TPS_RIGHTS_DECISION_INVALID');
    END IF;

    SELECT COUNT(*) INTO l_count FROM tps_entity
     WHERE entity_id=p_content_entity_id AND state='ACTIVE';
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20804,'TPS_RIGHTS_ACTIVE_CONTENT_REQUIRED');
    END IF;

    SELECT COUNT(*) INTO l_count FROM tps_entity
     WHERE entity_id=p_beneficiary_entity_id AND state='ACTIVE';
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20805,'TPS_RIGHTS_ACTIVE_BENEFICIARY_REQUIRED');
    END IF;

    SELECT COUNT(*) INTO l_count FROM tps_source WHERE source_id=p_source_id;
    IF l_count <> 1 THEN
      RAISE_APPLICATION_ERROR(-20806,'TPS_RIGHTS_PROVENANCE_SOURCE_REQUIRED');
    END IF;

    BEGIN
      SELECT right_grant_id INTO l_id
        FROM tps_right_grant
       WHERE content_entity_id=p_content_entity_id
         AND beneficiary_entity_id=p_beneficiary_entity_id
         AND action_code=l_action
         AND valid_from=p_valid_from
         AND valid_to=p_valid_to
         AND decision=l_decision
         AND source_id=p_source_id
         AND NVL(rights_holder_entity_id,-1)=NVL(p_rights_holder_entity_id,-1)
         AND NVL(territory_entity_id,-1)=NVL(p_territory_entity_id,-1)
         AND NVL(context_id,-1)=NVL(p_context_id,-1)
         AND state='ACTIVE'
       FETCH FIRST 1 ROW ONLY;
      RETURN l_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO tps_right_grant(
          content_entity_id,rights_holder_entity_id,beneficiary_entity_id,action_code,
          territory_entity_id,context_id,valid_from,valid_to,decision,source_id,
          restrictions_json,state
        ) VALUES(
          p_content_entity_id,p_rights_holder_entity_id,p_beneficiary_entity_id,l_action,
          p_territory_entity_id,p_context_id,p_valid_from,p_valid_to,l_decision,p_source_id,
          p_restrictions_json,'ACTIVE'
        ) RETURNING right_grant_id INTO l_id;
        RETURN l_id;
    END;
  END grant_right;

  PROCEDURE revoke_right(
      p_right_grant_id IN NUMBER
  ) IS
    l_state VARCHAR2(30);
  BEGIN
    SELECT state INTO l_state
      FROM tps_right_grant
     WHERE right_grant_id=p_right_grant_id
     FOR UPDATE;

    IF l_state <> 'ACTIVE' THEN
      RAISE_APPLICATION_ERROR(-20810,'TPS_RIGHTS_ONLY_ACTIVE_GRANT_CAN_BE_REVOKED');
    END IF;

    UPDATE tps_right_grant
       SET state='REVOKED'
     WHERE right_grant_id=p_right_grant_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20811,'TPS_RIGHTS_GRANT_NOT_FOUND');
  END revoke_right;

END tps_rights_admin_pkg;
/
