/*=============================================================================
 @file              src/03-d3ka/321_tps_d3ka_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-04/06/07/09
 @workstream        WS-05 D3KA relation kernel
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package body; runtime writes are stateful caller transactions
 @purpose           Implement deterministic D3KA relation validation, insertion,
                    lifecycle closing and active-relation counting behind a governed
                    package boundary.
 @business_impact   Ensures corporate relationship knowledge obeys one set of ontology
                    rules regardless of whether it originates from radio, TV, rights,
                    commercial, editorial, application or AI-assisted ingestion.
 @objects           Creates/replaces body of TPS_D3KA_PKG.
 @dependencies      TPS_RELATION_TYPE, TPS_ENTITY, TPS_RELATION and package specification.
                    TPS_RELATION itself references TPS_CONTEXT/TPS_SOURCE.
 @upstream          Calls through TPS_D3KA_PKG public specification.
 @downstream        D3KA relation rows, graph edges, domain logic, RAG and certification.
 @d3ka_role         RELATION/CONTEXT/TEMPORAL/PROVENANCE
 @d3ka_links        Validates S/R/T ontology, C/E requirements and Q confidence before
                    persisting a cell; END_RELATION changes Tv state without deletion.
 @ai_role           AI-originated relations remain explicit inference/assertion classes.
                    Package does not perform model calls and does not authorize broadcast.
 @security          AUTHID DEFINER. Execute grants must be narrower than table DML grants.
                    Source/target entities must be ACTIVE; relation type must be ACTIVE.
 @performance       ASSERT_RELATION currently executes relation-type lookup, one relation
                    metadata lookup, two entity lookups and one INSERT. This is simple and
                    deterministic but must be benchmarked under bulk-ingest workloads.
                    ACTIVE_RELATION_COUNT performs relation/type join and COUNT.
 @transaction       No COMMIT/ROLLBACK/autonomous transaction. Callers own transaction.
                    Failed validation raises before INSERT. END_RELATION performs one UPDATE.
 @idempotency       ASSERT_RELATION relies on active-cell uniqueness to reject duplicate
                    current state rather than silently merging. END_RELATION is single-use.
 @failure_modes     -20001 self relation forbidden; -20002 invalid source type;
                    -20003 invalid target type; -20004 context required; -20005 provenance
                    required; -20006 confidence range; -20007 active relation not found.
                    NO_DATA_FOUND/TOO_MANY_ROWS/constraint errors may surface for broken
                    ontology or identity assumptions and must be treated as failures.
 @rollback_recovery Uncommitted writes rollback with caller. Committed knowledge changes
                    should be ended/retracted/superseded by governed semantics, not erased.
 @tests             tests/D3KA/D3KA-001..011; tests/unit/UT-002_relation_constraints.sql;
                    graph and performance suites.
 @evidence          CORE-04 compiled package + validation/error evidence; CORE-15 D3KA;
                    CORE-17 performance; CORE-18 privilege boundary; CORE-20 certification.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; SQL transaction,
                    SELECT INTO, DML RETURNING and constraint documentation.
 @links             src/03-d3ka/320_tps_d3ka_pkg.pks;
                    src/03-d3ka/300_tps_relation_type.sql;
                    src/03-d3ka/310_tps_relation.sql;
                    docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded/routine documentation; behavior unchanged.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_d3ka_pkg AS

    /* @routine relation_type_id
       @purpose       Resolve one active relation ontology code to its numeric identity.
       @inputs        p_code: relation code; whitespace trimmed and case normalized to UPPER.
       @outputs       Active TPS_RELATION_TYPE.RELATION_TYPE_ID.
       @reads         TPS_RELATION_TYPE.
       @writes        NONE.
       @calls         NONE.
       @called_by     ASSERT_RELATION.
       @d3ka_impact   Resolves the R axis from stable semantic code to internal ID.
       @ai_impact     NONE; AI callers are subject to the same ontology lookup.
       @security      Definer-rights read of relation ontology only.
       @transaction   Read-only SELECT INTO.
       @performance   Unique RELATION_CODE lookup expected single-row/indexed.
       @errors        NO_DATA_FOUND if code is absent/inactive; TOO_MANY_ROWS indicates
                      violated ontology uniqueness/data corruption.
       @tests         Indirectly covered by D3KA-001..004.
    */
    FUNCTION relation_type_id(p_code IN VARCHAR2) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        SELECT relation_type_id INTO l_id
        FROM tps_relation_type
        WHERE relation_code = UPPER(TRIM(p_code))
          AND lifecycle_state = 'ACTIVE';
        RETURN l_id;
    END;

    /* @routine assert_relation
       @purpose       Enforce D3KA ontology invariants and insert one governed active cell.
       @inputs        S entity ID, R relation code, T entity ID, optional context/provenance,
                      confidence, assertion class, valid-from and observed-at.
       @outputs       New TPS_RELATION.RELATION_ID.
       @reads         TPS_RELATION_TYPE, TPS_ENTITY.
       @writes        TPS_RELATION.
       @calls         RELATION_TYPE_ID.
       @called_by     Governed ingest/domain/API callers.
       @d3ka_impact   Creates S/R/T cell and C/E/Q/Tv/To enrichments.
       @ai_impact     AI output must provide explicit class/provenance where ontology requires;
                      this routine provides no authorization to execute media actions.
       @security      Validates active entities and ontology; execute grant is privileged write path.
       @transaction   One INSERT in caller transaction; no COMMIT.
       @performance   Several point lookups plus one indexed constrained INSERT.
       @errors        -20001 through -20006 plus standard SELECT/DML/constraint errors.
       @tests         D3KA-001..005 and relation constraint tests.
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
    ) RETURN NUMBER IS
        l_type_id NUMBER;
        l_source_type NUMBER;
        l_target_type NUMBER;
        l_expected_source NUMBER;
        l_expected_target NUMBER;
        l_allow_self NUMBER;
        l_requires_context NUMBER;
        l_requires_provenance NUMBER;
        l_relation_id NUMBER;
    BEGIN
        l_type_id := relation_type_id(p_relation_code);

        -- Read ontology invariants for this R-axis relation before touching state.
        SELECT source_entity_type_id, target_entity_type_id, allow_self, requires_context, requires_provenance
          INTO l_expected_source, l_expected_target, l_allow_self, l_requires_context, l_requires_provenance
          FROM tps_relation_type WHERE relation_type_id = l_type_id;

        -- Only ACTIVE canonical identities may become new current D3KA endpoints.
        SELECT entity_type_id INTO l_source_type FROM tps_entity WHERE entity_id = p_source_entity_id AND state = 'ACTIVE';
        SELECT entity_type_id INTO l_target_type FROM tps_entity WHERE entity_id = p_target_entity_id AND state = 'ACTIVE';

        IF l_allow_self = 0 AND p_source_entity_id = p_target_entity_id THEN
            RAISE_APPLICATION_ERROR(-20001, 'D3KA_SELF_RELATION_NOT_ALLOWED');
        END IF;
        IF l_expected_source IS NOT NULL AND l_expected_source <> l_source_type THEN
            RAISE_APPLICATION_ERROR(-20002, 'D3KA_INVALID_SOURCE_TYPE');
        END IF;
        IF l_expected_target IS NOT NULL AND l_expected_target <> l_target_type THEN
            RAISE_APPLICATION_ERROR(-20003, 'D3KA_INVALID_TARGET_TYPE');
        END IF;
        IF l_requires_context = 1 AND p_context_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'D3KA_CONTEXT_REQUIRED');
        END IF;
        IF l_requires_provenance = 1 AND p_provenance_source_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'D3KA_PROVENANCE_REQUIRED');
        END IF;
        IF p_confidence IS NOT NULL AND (p_confidence < 0 OR p_confidence > 1) THEN
            RAISE_APPLICATION_ERROR(-20006, 'D3KA_CONFIDENCE_OUT_OF_RANGE');
        END IF;

        -- No commit here: caller retains atomic control with surrounding domain operation.
        INSERT INTO tps_relation(
            source_entity_id, relation_type_id, target_entity_id, context_id,
            provenance_source_id, confidence, assertion_class, valid_from, observed_at
        ) VALUES (
            p_source_entity_id, l_type_id, p_target_entity_id, p_context_id,
            p_provenance_source_id, p_confidence, UPPER(p_assertion_class), p_valid_from, p_observed_at
        ) RETURNING relation_id INTO l_relation_id;
        RETURN l_relation_id;
    END;

    /* @routine end_relation
       @purpose       Close one current/open relation while retaining historical row identity.
       @inputs        Relation ID and exclusive validity end timestamp.
       @outputs       NONE; exactly one row must transition ACTIVE/open -> INACTIVE/closed.
       @reads         TPS_RELATION through UPDATE predicate.
       @writes        TPS_RELATION.STATE and VALID_TO.
       @calls         NONE.
       @called_by     Knowledge lifecycle/correction/domain operations.
       @d3ka_impact   Ends Tv interval; cell remains historical and queryable.
       @ai_impact     NONE directly; AI must not autonomously end authoritative relations.
       @security      Governed package execution required.
       @transaction   One UPDATE in caller transaction; no COMMIT.
       @performance   Equality update by RELATION_ID plus state/open predicates; one row expected.
       @errors        -20007 if zero/multiple rows not updated; constraints may reject invalid time.
       @tests         D3KA temporal/lifecycle tests.
    */
    PROCEDURE end_relation(
        p_relation_id IN NUMBER,
        p_valid_to    IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
    ) IS
    BEGIN
        UPDATE tps_relation
           SET valid_to = p_valid_to,
               state = 'INACTIVE'
         WHERE relation_id = p_relation_id
           AND state = 'ACTIVE'
           AND valid_to IS NULL;
        IF SQL%ROWCOUNT <> 1 THEN
            RAISE_APPLICATION_ERROR(-20007, 'D3KA_ACTIVE_RELATION_NOT_FOUND');
        END IF;
    END;

    /* @routine active_relation_count
       @purpose       Count active/open S/R relations, optionally filtered to T.
       @inputs        Source entity, relation code and optional target entity.
       @outputs       Non-negative relation count.
       @reads         TPS_RELATION, TPS_RELATION_TYPE.
       @writes        NONE.
       @calls         NONE.
       @called_by     Diagnostics, validation, business/graph helper logic.
       @d3ka_impact   Reads an S/R slice, optionally S/R/T exact subset.
       @ai_impact     Retrieval only; count is evidence/context, not operational authorization.
       @security      Definer read of relation data; caller sees only aggregate count.
       @transaction   Read-only; no commit.
       @performance   COUNT over relation/type join. Requires benchmark/index validation at scale.
       @errors        Standard Oracle object/privilege/data errors.
       @tests         D3KA slice/coverage tests.
    */
    FUNCTION active_relation_count(
        p_source_entity_id IN NUMBER,
        p_relation_code    IN VARCHAR2,
        p_target_entity_id IN NUMBER DEFAULT NULL
    ) RETURN NUMBER IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO l_count
        FROM tps_relation r
        JOIN tps_relation_type rt ON rt.relation_type_id = r.relation_type_id
        WHERE r.source_entity_id = p_source_entity_id
          AND rt.relation_code = UPPER(TRIM(p_relation_code))
          AND (p_target_entity_id IS NULL OR r.target_entity_id = p_target_entity_id)
          AND r.state = 'ACTIVE'
          AND r.valid_to IS NULL;
        RETURN l_count;
    END;
END tps_d3ka_pkg;
/
