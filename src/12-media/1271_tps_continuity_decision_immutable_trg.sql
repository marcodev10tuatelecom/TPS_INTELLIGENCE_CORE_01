/*=============================================================================
 @file              src/12-media/1271_tps_continuity_decision_immutable_trg.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-12/18
 @workstream        Audit integrity / continuity
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE trigger; disabling/dropping changes audit protection
 @purpose           Enforce append-only semantics for committed continuity decisions by
                    rejecting UPDATE and DELETE at the database layer.
 @business_impact   Preserves evidence of why programming/fallback decisions occurred.
 @objects           Creates TRG_TPS_CONT_DECISION_IMMUTABLE.
 @dependencies      TPS_CONTINUITY_DECISION.
 @upstream          Any attempted direct or package UPDATE/DELETE.
 @downstream        Audit/certification trust in continuity history.
 @d3ka_role         EVENT/AUDIT
 @d3ka_links        Protects historical resolution derived from D3KA relationships and policy.
 @ai_role           Prevents AI/tooling from rewriting prior decision evidence even if DML is attempted.
 @security          Database-enforced integrity control; extraordinary DBA recovery requires explicit
                    controlled trigger disable/change and separate evidence.
 @performance       Constant-time BEFORE STATEMENT guard; no queries/DML.
 @transaction       Raises before UPDATE/DELETE; INSERT unaffected.
 @idempotency       CREATE OR REPLACE TRIGGER is repeatable.
 @failure_modes     Any UPDATE or DELETE raises -20301 by design.
 @rollback_recovery Drop/recreate prior trigger only through approved production change.
 @tests             tests/continuity/CONT-003_immutable_ledger.sql.
 @evidence          CORE-12/18 immutability evidence.
 @references        Oracle AI Database 26ai PL/SQL trigger documentation.
 @links             src/12-media/1270_tps_continuity_decision.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial immutable audit guard.
=============================================================================*/

CREATE OR REPLACE TRIGGER trg_tps_cont_decision_immutable
BEFORE UPDATE OR DELETE ON tps_continuity_decision
BEGIN
    RAISE_APPLICATION_ERROR(-20301, 'TPS_CONTINUITY_DECISION_IS_IMMUTABLE');
END;
/
