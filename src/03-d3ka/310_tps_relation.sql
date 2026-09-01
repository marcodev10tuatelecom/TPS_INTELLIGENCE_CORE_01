/*=============================================================================
 @file              src/03-d3ka/310_tps_relation.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-04/05/06/07/09
 @workstream        WS-05 D3KA kernel / WS-06 Property Graph / WS-07 Context /
                    WS-08 Temporal / WS-10 Knowledge provenance
 @source_state      SOURCE_READY
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE before business data; R3_TRANSFORMATIVE after history exists
 @purpose           Persist the canonical sparse D3KA relationship cell connecting one
                    source entity, one governed relation type and one target entity,
                    enriched by context, provenance, confidence, properties and time.
 @business_impact   Provides the common semantic backbone for organization, station,
                    programming, music, rights, advertising, audience, editorial and AI
                    knowledge instead of creating isolated relationship tables per app.
 @objects           Creates TPS_RELATION plus PK/FKs/check constraints and unique index
                    UX_TPS_RELATION_ACTIVE_CELL.
 @dependencies      TPS_ENTITY, TPS_RELATION_TYPE, TPS_CONTEXT, TPS_SOURCE.
 @upstream          TPS_D3KA_PKG; governed imports/ingest; human verification; domain
                    services; approved AI inference pipeline via assertion/governance path.
 @downstream        Property Graph, D3KA slice/projection views, temporal views, policy,
                    Graph RAG, assertions, APIs, certification and analytics.
 @d3ka_role         RELATION/CONTEXT/TEMPORAL/PROVENANCE
 @d3ka_links        Physical sparse cell backbone:
                    S=SOURCE_ENTITY_ID, R=RELATION_TYPE_ID, T=TARGET_ENTITY_ID,
                    C=CONTEXT_ID, Tv=VALID_FROM/VALID_TO,
                    To=OBSERVED_AT/RECORDED_AT, P=ATTRIBUTES_JSON,
                    E=PROVENANCE_SOURCE_ID, Q=CONFIDENCE/ASSERTION_CLASS.
                    Vector and policy enrichments are linked through adjacent layers.
 @ai_role           AI-generated/inferred relationships may be stored only through an
                    explicit assertion class/provenance/confidence path. AI is not allowed
                    to silently write a relation as an unqualified fact or authorize action.
 @security          Relationships can reveal sensitive associations, rights and commercial
                    rules. Direct table DML should be restricted; governed package/API
                    writes and audit are required. Provenance must not contain secrets.
 @performance       Expected to become one of the highest-cardinality knowledge tables.
                    Core access patterns: S slice, R slice, T slice, S-R-T exact cell,
                    current/open relation, temporal as-of filtering and graph edge scan.
                    The active-cell unique index enforces business integrity but also adds
                    write/index cost; additional indexes require CORE-17 measurement.
 @transaction       Runtime INSERT/UPDATE performed by callers/packages participates in
                    caller transaction; this DDL does not define autonomous commit logic.
                    DDL deployment itself implicitly commits in Oracle.
 @idempotency       CREATE TABLE/INDEX are not directly idempotent. Business duplicate
                    prevention for current open cells is enforced by the unique index.
 @failure_modes     Missing dependencies; invalid S/R/T FK; invalid context/source;
                    confidence outside 0..1; invalid state/assertion class; invalid time
                    interval; duplicate active cell. All should fail rather than silently
                    create semantically ambiguous graph edges.
 @rollback_recovery Before data, controlled drop can reverse deployment. After use, relation
                    history is corporate knowledge/audit state: destructive rollback is
                    prohibited without export/restore/forward migration preserving IDs,
                    temporal history and evidence links.
 @tests             tests/unit/UT-002_relation_constraints.sql;
                    tests/D3KA/D3KA-001..011; tests/graph/G-002/G-003;
                    tests/performance/PERF-002_d3ka_slice.sql;
                    tests/temporal/test_temporal_pkg.sql (temporal semantics indirectly).
 @evidence          CORE-04 relation kernel; CORE-05 graph; CORE-07 temporal; CORE-09
                    provenance; CORE-15 D3KA/graph; CORE-17 performance; CORE-20 release.
 @references        Oracle AI Database 26ai SQL Language Reference: CREATE TABLE, JSON,
                    identity columns, function-based indexes, constraints, timestamps;
                    Oracle Property Graph documentation for graph edge mapping.
 @links             docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md;
                    docs/06-data-dictionary/RELATION-DICTIONARY.md;
                    src/02-kernel/210_tps_entity.sql;
                    src/03-d3ka/300_tps_relation_type.sql;
                    src/03-d3ka/320_tps_d3ka_pkg.pks;
                    src/06-graph/600_tps_media_knowledge_graph.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; DDL/index unchanged.
=============================================================================*/

-- One row = one persisted sparse D3KA relationship cell plus orthogonal dimensions.
CREATE TABLE tps_relation (
    relation_id              NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    -- D3KA S axis.
    source_entity_id         NUMBER NOT NULL,
    -- D3KA R axis.
    relation_type_id         NUMBER NOT NULL,
    -- D3KA T axis.
    target_entity_id         NUMBER NOT NULL,
    -- D3KA C/context enrichment; optional unless relation type requires it.
    context_id               NUMBER,
    -- D3KA E/evidence provenance reference; optional unless relation type requires it.
    provenance_source_id     NUMBER,
    -- Domain/algorithm weight; semantics are relation/domain specific and must be documented.
    weight                   NUMBER,
    -- Confidence is normalized to [0,1] when supplied; null means not scored, not zero.
    confidence               NUMBER(5,4),
    state                    VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    -- Distinguishes fact/observation/inference classes; AI inference is explicit.
    assertion_class          VARCHAR2(30) DEFAULT 'FACT' NOT NULL,
    -- Extensible cell properties that do not justify first-class relational columns.
    attributes_json          JSON,
    -- Business/event validity interval Tv uses half-open semantics [valid_from, valid_to).
    valid_from               TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    valid_to                 TIMESTAMP WITH TIME ZONE,
    -- When the underlying fact/event was observed, if distinct from system recording.
    observed_at              TIMESTAMP WITH TIME ZONE,
    -- When TPSDBCORE01 recorded the relation; separates knowledge time from valid time.
    recorded_at              TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    created_at               TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    created_by               VARCHAR2(128) DEFAULT SYS_CONTEXT('USERENV','SESSION_USER') NOT NULL,
    CONSTRAINT fk_tps_relation_source FOREIGN KEY (source_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_relation_type FOREIGN KEY (relation_type_id) REFERENCES tps_relation_type(relation_type_id),
    CONSTRAINT fk_tps_relation_target FOREIGN KEY (target_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_relation_context FOREIGN KEY (context_id) REFERENCES tps_context(context_id),
    CONSTRAINT fk_tps_relation_prov FOREIGN KEY (provenance_source_id) REFERENCES tps_source(source_id),
    CONSTRAINT ck_tps_relation_state CHECK (state IN ('ACTIVE','INACTIVE','SUPERSEDED','RETRACTED')),
    CONSTRAINT ck_tps_relation_assertion CHECK (assertion_class IN ('FACT','OBSERVATION','INFERENCE','AI_INFERENCE','HUMAN_ASSERTION','EXTERNAL_IMPORT')),
    CONSTRAINT ck_tps_relation_confidence CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
    CONSTRAINT ck_tps_relation_validity CHECK (valid_to IS NULL OR valid_to > valid_from)
);

-- Integrity invariant: at most one open ACTIVE cell for the same S/R/T/context tuple.
-- Historical closed/superseded/retracted cells remain possible and are not collapsed.
CREATE UNIQUE INDEX ux_tps_relation_active_cell
ON tps_relation (
    source_entity_id,
    relation_type_id,
    target_entity_id,
    NVL(context_id,0),
    CASE WHEN state = 'ACTIVE' AND valid_to IS NULL THEN 1 ELSE NULL END
);
