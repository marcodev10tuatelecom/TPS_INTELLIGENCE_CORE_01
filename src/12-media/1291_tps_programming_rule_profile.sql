/*=============================================================================
 @file              src/12-media/1291_tps_programming_rule_profile.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        Programming policy / station capability rules
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE before use; R3 after policy history depends on rows
 @purpose           Store one deterministic programming-rule profile per owner entity so each
                    station/channel/network can enforce repeat windows, commercial load,
                    classification, asset-duration tolerance and placement authorization.
 @business_impact   Encodes operational functionality of a broadcaster group as database policy
                    instead of leaving these limits in prompts or application code.
 @objects           Creates TPS_PROGRAMMING_RULE_PROFILE.
 @dependencies      TPS_ENTITY.
 @upstream          Business/editorial/commercial policy approved for each network/station/channel.
 @downstream        TPS_PROGRAMMING_RULES_PKG and schedule state guard trigger.
 @d3ka_role         POLICY/CONTEXT
 @d3ka_links        OWNER_ENTITY_ID anchors the profile to the canonical entity participating in D3KA.
 @ai_role           AI may read the profile and optimize within it; it cannot override the limits.
 @security          Policy-changing DML is administrative and auditable; runtime roles should read only.
 @performance       One active-row lookup by OWNER_ENTITY_ID.
 @transaction       DDL implicit commit; policy writes caller-owned.
 @idempotency       OWNER_ENTITY_ID is the primary key, preventing parallel active profiles per owner.
 @failure_modes     Missing profile is fail-closed for schedule approval in the rules package.
 @rollback_recovery Preserve prior policy rows/evidence after operational use; migrate forward.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-11/14/18 rule evidence.
 @references        Oracle AI Database 26ai SQL Language Reference.
 @links             src/12-media/1290_tps_content_rating.sql;
                    src/12-media/1293_tps_programming_rules_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE TABLE tps_programming_rule_profile (
    owner_entity_id                    NUMBER PRIMARY KEY,
    repeat_window_minutes              NUMBER DEFAULT 0 NOT NULL,
    max_commercial_seconds_rolling_hour NUMBER DEFAULT 720 NOT NULL,
    max_content_minimum_age            NUMBER DEFAULT 18 NOT NULL,
    require_program_rating             NUMBER(1) DEFAULT 1 NOT NULL,
    asset_duration_tolerance_sec       NUMBER DEFAULT 5 NOT NULL,
    enforce_commercial_placement       NUMBER(1) DEFAULT 1 NOT NULL,
    state                              VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    rules_json                         JSON,
    valid_from                         TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    valid_to                           TIMESTAMP WITH TIME ZONE,
    updated_at                         TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    updated_by                         VARCHAR2(128) DEFAULT SYS_CONTEXT('USERENV','SESSION_USER') NOT NULL,
    CONSTRAINT fk_tps_prog_rule_owner FOREIGN KEY(owner_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_prog_rule_repeat CHECK(repeat_window_minutes >= 0),
    CONSTRAINT ck_tps_prog_rule_ads CHECK(max_commercial_seconds_rolling_hour BETWEEN 0 AND 3600),
    CONSTRAINT ck_tps_prog_rule_age CHECK(max_content_minimum_age >= 0),
    CONSTRAINT ck_tps_prog_rule_bool1 CHECK(require_program_rating IN (0,1)),
    CONSTRAINT ck_tps_prog_rule_tol CHECK(asset_duration_tolerance_sec >= 0),
    CONSTRAINT ck_tps_prog_rule_bool2 CHECK(enforce_commercial_placement IN (0,1)),
    CONSTRAINT ck_tps_prog_rule_state CHECK(state IN ('ACTIVE','INACTIVE','SUPERSEDED','RETIRED')),
    CONSTRAINT ck_tps_prog_rule_validity CHECK(valid_to IS NULL OR valid_to > valid_from)
);
