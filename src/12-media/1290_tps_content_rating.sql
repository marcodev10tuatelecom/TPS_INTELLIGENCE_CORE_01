/*=============================================================================
 @file              src/12-media/1290_tps_content_rating.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        Programming policy / editorial classification
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE before use; R3 after programming evidence references codes
 @purpose           Define governed content-rating codes and an ordinal/minimum-age value that
                    PL/SQL can compare deterministically instead of comparing free-form labels.
 @business_impact   Makes age/classification limits enforceable by the database for children,
                    teen, general and other channel profiles.
 @objects           Creates TPS_CONTENT_RATING.
 @dependencies      None.
 @upstream          Regulatory/editorial classification policy and reference seed data.
 @downstream        TPS_PROGRAM.EDITORIAL_RATING and TPS_PROGRAMMING_RULES_PKG.
 @d3ka_role         POLICY/CONTEXT
 @d3ka_links        Classification may also be represented in D3KA; this table is the deterministic
                    execution reference used by programming policy.
 @ai_role           AI may propose classification but cannot invent an authoritative code.
 @security          Reference data; writes restricted to governed migration/editorial authority.
 @performance       Small reference table; PK lookup by RATING_CODE.
 @transaction       DDL implicit commit when deployed.
 @idempotency       CREATE TABLE non-idempotent; seed uses MERGE in a separate reference source.
 @failure_modes     Unknown codes in TPS_PROGRAM are treated as policy violations by the rules package.
 @rollback_recovery Drop before use; migrate/preserve codes after use.
 @tests             tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-14 programming-policy evidence.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE TABLE, constraints.
 @links             src/12-media/1220_tps_program.sql;
                    src/12-media/1291_tps_programming_rule_profile.sql;
                    src/12-media/1293_tps_programming_rules_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE TABLE tps_content_rating (
    rating_code        VARCHAR2(30) PRIMARY KEY,
    country_code       VARCHAR2(3) NOT NULL,
    display_name       VARCHAR2(200) NOT NULL,
    minimum_age        NUMBER DEFAULT 0 NOT NULL,
    ordinal_rank       NUMBER NOT NULL,
    state              VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    description        VARCHAR2(1000),
    CONSTRAINT ck_tps_content_rating_age CHECK(minimum_age >= 0),
    CONSTRAINT ck_tps_content_rating_rank CHECK(ordinal_rank >= 0),
    CONSTRAINT ck_tps_content_rating_state CHECK(state IN ('ACTIVE','INACTIVE','RETIRED'))
);
