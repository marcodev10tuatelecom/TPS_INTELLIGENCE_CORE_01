/*=============================================================================
 @file              src/14-rights/1400_tps_right_grant.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        WS-12 Policy/rules / WS-15 Commercial-rights domains /
                    WS-21 Security/privacy
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE before rights data; R3_TRANSFORMATIVE after legal/business use
 @purpose           Persist explicit time-bounded ALLOW/DENY content-right grants with
                    beneficiary, territory, context, rights-holder and provenance so that
                    content use can be decided deterministically and audibly.
 @business_impact   Prevents broadcast/publication/placement decisions from relying on
                    undocumented assumptions. Rights are evaluated before authorized content
                    actions such as play, stream, publish, advertise or regional distribution.
 @objects           Creates TPS_RIGHT_GRANT and lookup index IX_TPS_RIGHT_LOOKUP.
 @dependencies      TPS_ENTITY, TPS_CONTEXT, TPS_SOURCE.
 @upstream          Rights contracts, legal/licensing operations, verified imports and
                    authorized rights-administration workflows.
 @downstream        TPS_RIGHTS_PKG.DECISION_FOR, TPS_POLICY_ENGINE_PKG, schedule/content
                    authorization, audit, certification and future D3KA rights relations.
 @d3ka_role         POLICY/TEMPORAL/PROVENANCE/CONTEXT
 @d3ka_links        Content/holder/beneficiary/territory are canonical TPS_ENTITY IDs;
                    CONTEXT_ID is C, VALID_FROM/VALID_TO are Tv, SOURCE_ID is E. The grant
                    represents deterministic authorization state adjacent to D3KA knowledge.
 @ai_role           AI may analyze or recommend rights interpretation but may not create
                    authoritative ALLOW/DENY grants without governed source and approval.
                    Deterministic rights data overrides AI recommendation.
 @security          Legal/commercially sensitive. Direct DML must be tightly restricted and
                    audited. SOURCE_ID is mandatory. RESTRICTIONS_JSON must not contain
                    secrets and must be covered by data classification/access policy.
 @performance       Critical lookup is content + beneficiary + action + current time + state;
                    IX_TPS_RIGHT_LOOKUP supports the implemented package query. Territory/
                    context filtering is not yet implemented in TPS_RIGHTS_PKG and therefore
                    must not be assumed operational merely because columns exist.
 @transaction       DDL implicit commit on deployment. Rights writes are governed caller
                    transactions; no autonomous commit behavior defined here.
 @idempotency       CREATE TABLE/INDEX non-idempotent; right-grant business idempotency is
                    not encoded by a natural-key constraint in this source and requires a
                    controlled ingest contract before production data population.
 @failure_modes     Invalid FK, invalid/empty time window, invalid decision/state, duplicate
                    business grant due to missing natural idempotency key, or conflicting
                    overlapping ALLOW/DENY grants. Current decision algorithm gives DENY
                    precedence when both match; overlap policy must be tested/audited.
 @rollback_recovery Before use, controlled drop possible. After legal rights history exists,
                    destructive deletion is inappropriate; supersede/revoke/expire or restore/
                    forward migrate while retaining provenance and decision history.
 @tests             tests/performance/PERF-003_schedule_rights.sql;
                    tests/AI/AI-003_policy_boundary.sql; future dedicated rights decision,
                    conflict, boundary-time, territory and context suites are required.
 @evidence          CORE-11 policy/rights evidence; CORE-18 security; CORE-20 certification.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE TABLE, JSON,
                    constraints, composite indexes and timestamp comparisons.
 @links             docs/05-domain/RIGHTS-LICENSING.md;
                    docs/14-compliance/RETENTION-RIGHTS-COMPLIANCE.md;
                    src/14-rights/1410_tps_rights_pkg.pks;
                    src/10-policy/1030_tps_policy_engine_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; DDL/index unchanged.
=============================================================================*/

-- One row = one explicit rights decision window for content + beneficiary + action.
CREATE TABLE tps_right_grant (
    right_grant_id        NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    -- Canonical content identity subject to the grant/restriction.
    content_entity_id     NUMBER NOT NULL,
    -- Optional canonical legal/business rights holder.
    rights_holder_entity_id NUMBER,
    -- Entity allowed/denied to perform ACTION_CODE on the content.
    beneficiary_entity_id NUMBER NOT NULL,
    action_code           VARCHAR2(100) NOT NULL,
    -- Optional territory and context dimensions reserved for scoped rights decisions.
    territory_entity_id   NUMBER,
    context_id            NUMBER,
    -- Rights windows are finite in this v0.02 source: VALID_TO is mandatory.
    valid_from            TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_to              TIMESTAMP WITH TIME ZONE NOT NULL,
    -- Explicit deterministic decision. DENY has precedence in current package logic.
    decision              VARCHAR2(10) NOT NULL,
    -- Mandatory provenance/evidence source for legal/business auditability.
    source_id             NUMBER NOT NULL,
    restrictions_json     JSON,
    state                 VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    CONSTRAINT fk_tps_right_content FOREIGN KEY(content_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_right_holder FOREIGN KEY(rights_holder_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_right_beneficiary FOREIGN KEY(beneficiary_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_right_territory FOREIGN KEY(territory_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_right_context FOREIGN KEY(context_id) REFERENCES tps_context(context_id),
    CONSTRAINT fk_tps_right_source FOREIGN KEY(source_id) REFERENCES tps_source(source_id),
    CONSTRAINT ck_tps_right_time CHECK(valid_to > valid_from),
    CONSTRAINT ck_tps_right_decision CHECK(decision IN ('ALLOW','DENY')),
    CONSTRAINT ck_tps_right_state CHECK(state IN ('ACTIVE','SUPERSEDED','REVOKED','EXPIRED'))
);

-- Supports current DECISION_FOR lookup path. Index design remains subject to CORE-17 tests.
CREATE INDEX ix_tps_right_lookup
    ON tps_right_grant(content_entity_id,beneficiary_entity_id,action_code,valid_from,valid_to,state);
