/*=============================================================================
 @file              src/03-d3ka/320_tps_d3ka_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-04/06/07/09
 @workstream        WS-05 D3KA relation kernel
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package definition; behavior/state impact occurs through callers
 @purpose           Expose the governed PL/SQL write/read contract for creating, ending
                    and counting D3KA relationship cells while centralizing semantic
                    validation instead of allowing arbitrary direct TPS_RELATION DML.
 @business_impact   Provides a deterministic relational authority for corporate knowledge
                    links used by stations, programs, media, rights, advertisers,
                    audiences, editorial facts and AI-assisted knowledge ingestion.
 @objects           Creates/replaces package specification TPS_D3KA_PKG.
 @dependencies      TPS_RELATION_TYPE, TPS_ENTITY, TPS_RELATION, TPS_CONTEXT, TPS_SOURCE
                    at implementation/runtime level.
 @upstream          Approved service/API/ingest/migration code requiring governed relation operations.
 @downstream        Domain packages, ETL/ingest, APIs, tests, Graph/AI knowledge workflows.
 @d3ka_role         RELATION/CONTEXT/TEMPORAL/PROVENANCE
 @d3ka_links        Controls construction and lifecycle of S/R/T cells and validates
                    relation ontology constraints before persistence.
 @ai_role           AI callers may propose/assert only through governed paths. Package
                    validation does not itself grant operational authority and does not
                    convert AI inference into verified fact.
 @security          AUTHID DEFINER requires strict EXECUTE grants. Direct TPS_RELATION DML
                    should be denied to ordinary runtime identities so package validation
                    cannot be bypassed. Definer owner must hold only required object rights.
 @performance       ASSERT_RELATION performs relation-type lookup, entity lookups,
                    validation and one INSERT. ACTIVE_RELATION_COUNT performs indexed/joined
                    count. Production indexes require CORE-17 evidence.
 @transaction       Package routines do not issue COMMIT/ROLLBACK; caller owns transaction.
                    ASSERT_RELATION and END_RELATION write in caller transaction.
 @idempotency       ASSERT_RELATION is not inherently idempotent; duplicate active-cell
                    uniqueness in TPS_RELATION provides fail-closed protection.
                    END_RELATION is intentionally single-transition and errors if already ended.
 @failure_modes     Invalid relation type/entity state/type/self/context/provenance/confidence,
                    duplicate active cell, missing object privilege, or ended/nonexistent relation.
 @rollback_recovery Caller can rollback uncommitted operations. Committed relation history
                    must be ended/superseded/retracted according to business semantics rather
                    than physically deleted except under approved recovery/migration.
 @tests             tests/D3KA/D3KA-001_assert_relation.sql through D3KA-005_duplicate_active.sql;
                    slice/temporal/invariant/coverage suites consume resulting state.
 @evidence          CORE-04 package compile/behavior evidence; CORE-15 D3KA validation;
                    CORE-18 privilege tests; CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; SQL Language Reference
                    for transaction/constraint behavior; project D3KA specification.
 @links             docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md;
                    docs/09-security/PRIVILEGE-MODEL.md;
                    src/03-d3ka/300_tps_relation_type.sql;
                    src/03-d3ka/310_tps_relation.sql;
                    src/03-d3ka/321_tps_d3ka_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded/routine documentation; API unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_d3ka_pkg AUTHID DEFINER AS

    /* @routine assert_relation
       @purpose       Validate and persist one new active D3KA S/R/T cell.
       @inputs        p_source_entity_id: ACTIVE TPS_ENTITY used as S.
                      p_relation_code: ACTIVE governed TPS_RELATION_TYPE code.
                      p_target_entity_id: ACTIVE TPS_ENTITY used as T.
                      p_context_id: optional/required according to relation ontology.
                      p_provenance_source_id: optional/required provenance source.
                      p_confidence: NULL or normalized [0,1].
                      p_assertion_class: explicit fact/observation/inference class.
                      p_valid_from: business-valid start; defaults SYSTIMESTAMP.
                      p_observed_at: optional observation time.
       @outputs       Returns newly created TPS_RELATION.RELATION_ID.
       @reads         TPS_RELATION_TYPE, TPS_ENTITY.
       @writes        TPS_RELATION.
       @calls         Internal relation-type resolver in package body.
       @called_by     Governed ingest/domain/API code and D3KA tests.
       @d3ka_impact   Creates one S/R/T cell plus C/Tv/To/E/Q enrichments.
       @ai_impact     AI inference must be explicitly classed/provenanced; no authority grant.
       @security      Requires package EXECUTE; should replace direct relation-table INSERT rights.
       @transaction   No COMMIT; INSERT remains in caller transaction.
       @performance   O(1) reference lookups plus one constrained insert under expected indexes.
       @errors        Body defines -20001..-20006 validation errors; DB constraints may also fail.
       @tests         D3KA-001..005 and downstream graph/coverage tests.
    */
    FUNCTION assert_relation(
        p_source_entity_id     IN NUMBER,
        p_relation_code        IN VARCHAR2,
        p_target_entity_id     IN NUMBER,
        p_context_id           IN NUMBER DEFAULT NULL,
        p_provenance_source_id IN NUMBER DEFAULT NULL,
        p_confidence           IN NUMBER DEFAULT NULL,
        p_assertion_class      IN VARCHAR2 DEFAULT 'FACT',
        p_valid_from           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
        p_observed_at          IN TIMESTAMP WITH TIME ZONE DEFAULT NULL
    ) RETURN NUMBER;

    /* @routine end_relation
       @purpose       Close exactly one currently ACTIVE/open D3KA relation at p_valid_to.
       @inputs        p_relation_id: target relation identity.
                      p_valid_to: exclusive validity end, default SYSTIMESTAMP.
       @outputs       None; successful call changes exactly one row.
       @reads         TPS_RELATION current state through UPDATE predicate.
       @writes        TPS_RELATION.VALID_TO and STATE.
       @calls         None.
       @called_by     Governed correction/lifecycle/domain operations.
       @d3ka_impact   Ends Tv validity of an existing cell without deleting history.
       @ai_impact     AI must not call as unreviewed autonomous operational authority.
       @security      Package EXECUTE only for identities permitted to end knowledge relations.
       @transaction   No COMMIT; update belongs to caller transaction.
       @performance   PK/equality update expected O(log n)/indexed; exactly one row required.
       @errors        -20007 when no exactly-one active open relation is updated; constraint errors possible.
       @tests         Temporal and D3KA lifecycle tests.
    */
    PROCEDURE end_relation(
        p_relation_id IN NUMBER,
        p_valid_to    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    );

    /* @routine active_relation_count
       @purpose       Count current/open active relations from a source for one relation code,
                      optionally narrowed to a target entity.
       @inputs        p_source_entity_id, p_relation_code, optional p_target_entity_id.
       @outputs       NUMBER >= 0 count of active/open matching cells.
       @reads         TPS_RELATION and TPS_RELATION_TYPE.
       @writes        NONE.
       @calls         NONE.
       @called_by     Validation, diagnostics, APIs/domain logic and tests.
       @d3ka_impact   Reads S/R slice, optionally exact T subset.
       @ai_impact     Safe retrieval primitive; result alone is not authorization.
       @security      Requires only package EXECUTE to caller; definer reads underlying tables.
       @transaction   Read-only; no locks intentionally acquired and no commit.
       @performance   Count over indexed relation/type predicates; benchmark at graph scale.
       @errors        Standard Oracle errors for unavailable objects/privileges; invalid code returns zero unless lookup/data rules differ.
       @tests         D3KA slice/count tests.
    */
    FUNCTION active_relation_count(
        p_source_entity_id IN NUMBER,
        p_relation_code    IN VARCHAR2,
        p_target_entity_id IN NUMBER DEFAULT NULL
    ) RETURN NUMBER;
END tps_d3ka_pkg;
/
