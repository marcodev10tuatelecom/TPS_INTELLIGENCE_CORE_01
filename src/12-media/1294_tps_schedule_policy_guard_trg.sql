/*=============================================================================
 @file              src/12-media/1294_tps_schedule_policy_guard_trg.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        Schedule policy state guard
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE
 @purpose           Enforce TPS_PROGRAMMING_RULES_PKG whenever a schedule statement transitions
                    one or more rows into APPROVED or ACTIVE, including direct SQL that bypasses APIs.
 @business_impact   Makes hard broadcaster policy a database state-transition invariant.
 @objects           Creates compound trigger TRG_TPS_SCHEDULE_POLICY_GUARD.
 @dependencies      TPS_SCHEDULE, TPS_PROGRAMMING_RULES_PKG.
 @upstream          UPDATE of TPS_SCHEDULE.STATE.
 @downstream        Schedule approval/activation success or statement rollback on policy failure.
 @d3ka_role         POLICY/TEMPORAL
 @d3ka_links        Guards lifecycle of D3KA-linked schedule owner/content relationships.
 @ai_role           AI cannot bypass trigger by invoking a different SQL path.
 @security          Defense-in-depth; privileges should still deny ordinary direct table DML.
 @performance       Runs exhaustive policy validation only for rows entering APPROVED/ACTIVE.
 @transaction       No autonomous transaction/commit. Raised error rolls back the triggering statement.
 @idempotency       Revalidation of same valid transition is deterministic.
 @failure_modes     -20601 from rules package rejects transition. Compound after-statement phase avoids mutating-table reads.
 @rollback_recovery Drop/recreate trigger; no business data created by trigger itself.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-11/14/18.
 @references        Oracle AI Database 26ai PL/SQL compound trigger documentation.
 @links             src/12-media/1293_tps_programming_rules_pkg.pkb; src/12-media/1230_tps_schedule.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE TRIGGER trg_tps_schedule_policy_guard
FOR UPDATE OF state ON tps_schedule
COMPOUND TRIGGER

    TYPE t_id_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_schedule_ids t_id_tab;
    g_count PLS_INTEGER := 0;

    AFTER EACH ROW IS
    BEGIN
        IF :NEW.state IN ('APPROVED','ACTIVE')
           AND NVL(:OLD.state,'~') <> :NEW.state THEN
            g_count := g_count + 1;
            g_schedule_ids(g_count) := :NEW.schedule_id;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. g_count LOOP
            tps_programming_rules_pkg.assert_schedule_rules(g_schedule_ids(i));
        END LOOP;
    END AFTER STATEMENT;

END trg_tps_schedule_policy_guard;
/
