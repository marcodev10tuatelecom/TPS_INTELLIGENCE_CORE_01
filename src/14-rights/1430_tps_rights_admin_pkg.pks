/*=============================================================================
 @file              src/14-rights/1430_tps_rights_admin_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-09/11/14/18
 @workstream        Rights/licensing administration
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package; routines perform caller-owned R2 DML
 @purpose           Provide controlled creation and revocation of provenance-backed rights grants.
 @business_impact   Makes broadcast-right setup operational without direct table DML and preserves
                    the deterministic rights boundary used by programming/commercial packages.
 @objects           Creates/replaces TPS_RIGHTS_ADMIN_PKG specification.
 @dependencies      TPS_RIGHT_GRANT, TPS_ENTITY, TPS_SOURCE.
 @upstream          Rights/legal administration and controlled migrations.
 @downstream        TPS_RIGHTS_PKG, TPS_PROGRAMMING_PKG, TPS_COMMERCIAL_PKG.
 @d3ka_role         POLICY/TEMPORAL/PROVENANCE
 @d3ka_links        Rights bind canonical content and beneficiary identities with Tv and E.
 @ai_role           AI may recommend; authoritative grant/revoke execution remains governed.
 @security          High-impact AUTHID DEFINER package; EXECUTE only for rights authority.
 @performance       Point validation and single-row insert/update.
 @transaction       No COMMIT/ROLLBACK; caller owns transaction.
 @idempotency       Exact matching active grant returns existing RIGHT_GRANT_ID.
 @failure_modes     Missing entity/source, invalid interval/decision/action, invalid revoke state.
 @rollback_recovery Caller rollback before commit; committed rights use lifecycle state.
 @tests             tests/integration/INT-010_broadcast_end_to_end.sql; COMP-003.
 @evidence          CORE-09/11/14 rights evidence.
 @references        Oracle AI Database 26ai PL/SQL Language Reference.
 @links             src/14-rights/1400_tps_right_grant.sql; src/14-rights/1410_tps_rights_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial governed rights administration API.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_rights_admin_pkg AUTHID DEFINER AS

  FUNCTION grant_right(
      p_content_entity_id      IN NUMBER,
      p_beneficiary_entity_id  IN NUMBER,
      p_action_code            IN VARCHAR2,
      p_valid_from             IN TIMESTAMP WITH TIME ZONE,
      p_valid_to               IN TIMESTAMP WITH TIME ZONE,
      p_decision               IN VARCHAR2,
      p_source_id              IN NUMBER,
      p_rights_holder_entity_id IN NUMBER DEFAULT NULL,
      p_territory_entity_id    IN NUMBER DEFAULT NULL,
      p_context_id             IN NUMBER DEFAULT NULL,
      p_restrictions_json      IN JSON DEFAULT NULL
  ) RETURN NUMBER;

  PROCEDURE revoke_right(
      p_right_grant_id IN NUMBER
  );

END tps_rights_admin_pkg;
/
