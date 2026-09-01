/*=============================================================================
 @file              src/07-vector/720_vector_similarity_queries.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-08/17
 @workstream        WS-09 Vector semantics / WS-20 Performance
 @source_state      SOURCE_READY_WITH_LIMITATION
 @production_state  QUERY_TEMPLATE_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Provide a bind-variable exact top-K cosine similarity query used as a
                    correctness/performance baseline before approximate vector indexes are accepted.
 @business_impact   Establishes a deterministic exact-reference retrieval path for semantic search,
                    recommendation and Graph RAG quality/recall comparisons.
 @objects           Reads TPS_VECTOR only; creates/modifies no database object.
 @dependencies      TPS_VECTOR and Oracle VECTOR_DISTANCE capability.
 @upstream          Caller-provided query VECTOR, vector type ID and top-K bound value.
 @downstream        Semantic retrieval clients, V-002 exact tests, ANN recall benchmarks.
 @d3ka_role         VECTOR
 @d3ka_links        Retrieves V-nearest entities; explicit D3KA S/R/T relationships are resolved separately.
 @ai_role           Retrieval primitive for RAG/recommendation. Returned nearest vectors are candidates,
                    not facts or authorized actions.
 @security          Binds must be supplied through controlled clients; source explicitly avoids string
                    concatenation/dynamic SQL. Result access inherits TPS_VECTOR/entity source classification.
 @performance       Exact scan/distance calculation can be O(N) over active vectors in the chosen type.
                    It intentionally establishes ground truth and may be unsuitable for large online workloads.
                    ANN HNSW/IVF results must be compared to this baseline for recall/latency trade-off.
 @transaction       SELECT only; no write/commit/locks intentionally introduced.
 @idempotency       Same stable vector set/query vector/metric returns deterministic ordering except ties.
 @failure_modes     Invalid/incompatible query vector dimension/format, unsupported metric, invalid bind values.
                    IMPORTANT: metric is hard-coded COSINE and does NOT dynamically use
                    TPS_VECTOR_TYPE.DISTANCE_METRIC. Therefore this template is valid only for cosine spaces
                    unless deliberately specialized.
 @rollback_recovery None; query template only.
 @tests             tests/vector/V-001_vector_distance.sql; V-002_exact_topk.sql;
                    V-003_ann_recall_method.md; PERF-005_vector_exact.sql.
 @evidence          CORE-08 exact-search correctness; CORE-17 baseline/ANN comparison.
 @references        Oracle AI Vector Search User's Guide: VECTOR_DISTANCE and exact similarity search.
 @links             src/07-vector/700_tps_vector_type.sql; src/07-vector/710_tps_vector.sql;
                    src/21-indexes/2100_vector_hnsw_template.sql; src/21-indexes/2110_vector_ivf_template.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full documentation/cosine limitation; query unchanged.
=============================================================================*/

-- Exact cosine similarity baseline. Replace bind values only through controlled clients.
SELECT vector_id,
       entity_id,
       vector_type_id,
       VECTOR_DISTANCE(embedding, :query_vector, COSINE) AS distance
FROM tps_vector
WHERE vector_type_id = :vector_type_id
  AND state='ACTIVE'
ORDER BY VECTOR_DISTANCE(embedding, :query_vector, COSINE)
FETCH FIRST :top_k ROWS ONLY;
