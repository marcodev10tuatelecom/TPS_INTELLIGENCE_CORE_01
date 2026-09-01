# TPS_INTELLIGENCE_CORE_01 — BUILT INVENTORY v0.02

## Status legend

- `BUILT` — artifact exists in repository.
- `SOURCE_ONLY` — executable source exists in Git; this does not mean it was deployed.
- `NOT_DEPLOYED` — no production deployment is asserted by this inventory.
- `DOC_FULL` — embedded source documentation conforms to the v0.02 contract.
- `DOC_PARTIAL` — useful comments/metadata exist but do not yet satisfy the v0.02 contract.
- `DOC_PENDING` — documentation retrofit is still required.

**Database:** `TPSDBCORE01` / `TPS_INTELLIGENCE_CORE_01`  
**Environment:** PRODUCTION  
**Oracle target:** Oracle AI Database 26ai  
**Branch inventoried:** `engineering-v0.02`

---

# 1. Canonical top-level engineering maps — BUILT

1. `README.md`
2. `PROJECT-MAP.md`
3. `DOCUMENTATION-MAP.md`
4. `SOURCE-MAP.md`
5. `TRACEABILITY-MAP.md`
6. `ENGINEERING-v0.02-INDEX.md`
7. `SOURCE-FILE-CATALOG-v0.02.md`
8. `BUILT-INVENTORY-v0.02.md`

---

# 2. Governance documentation — BUILT

`docs/00-governance/`

- `ADR-POLICY.md`
- `AUTHORITY-MODEL.md`
- `DEFINITION-OF-COMPLETE.md`
- `DOCUMENTATION-FIRST-POLICY-v0.02.md`
- `EVIDENCE-STANDARD.md`
- `PROJECT-CHARTER.md`
- `VERSIONING.md`

Purpose: define canonical authority, production classification, engineering gates, evidence, completeness, ADR usage, versioning and the rule that documentation is an engineering deliverable equal to or more important than executable database source.

---

# 3. Business analysis — BUILT

`docs/01-business/`

- `BUSINESS-ANALYSIS.md`
- `BUSINESS-RULES.md`
- `CAPABILITY-MAP.md`
- `PROCESS-MAP.md`
- `STAKEHOLDERS-ACTORS.md`

Purpose: model the media-enterprise problem, actors, business capabilities, processes and business rules for radio, television, networks, stations, affiliates/repeaters, programming, advertising, rights, audience, editorial, operations and intelligence.

---

# 4. Requirements engineering — BUILT

`docs/02-requirements/`

- `MASTER-REQUIREMENTS.md`
- `FUNCTIONAL-REQUIREMENTS.md`
- `NONFUNCTIONAL-REQUIREMENTS.md`
- `DATA-REQUIREMENTS.md`
- `AI-REQUIREMENTS.md`

Purpose: establish traceable functional, nonfunctional, data and AI requirements that later sources and tests must satisfy.

---

# 5. Architecture documentation — BUILT

`docs/03-architecture/`

- `SYSTEM-CONTEXT.md`
- `LOGICAL-ARCHITECTURE.md`
- `PHYSICAL-ARCHITECTURE.md`
- `DEPLOYMENT-ARCHITECTURE.md`
- `TECHNOLOGY-DECISION-MATRIX.md`
- `MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md`

Purpose: define Oracle 26ai converged architecture and the separation between logical D3KA knowledge semantics and physical relational/graph/vector/JSON implementations.

---

# 6. D3KA/tensor documentation — BUILT

`docs/04-d3ka/`

- `D3KA-FORMAL-MODEL.md`
- `D3KA-ENGINEERING-SPEC-v0.02.md`

The dominant logical cell is:

```text
D3KA[S,R,T]
S = source entity
R = relation
T = target entity
```

with orthogonal enrichment:

```text
C  = context
Tv = valid/event time
To = observed/recorded time
P  = properties
V  = vector representations
E  = evidence/provenance
Q  = confidence/verification
A  = authorization/policy
```

Semantic coverage target: `>= 90%` of approved business knowledge/relationships must be representable/queryable through the D3KA/graph model, with coverage also measured per business domain.

---

# 7. Domain documentation — BUILT

`docs/05-domain/`

- `DOMAIN-MASTER-MAP.md`
- `ORGANIZATION-NETWORK-STATION.md`
- `PROGRAMMING-SCHEDULING.md`
- `MEDIA-ASSET-MUSIC-VIDEO.md`
- `ADVERTISING-COMMERCIAL.md`
- `RIGHTS-LICENSING.md`
- `AUDIENCE.md`
- `EDITORIAL.md`
- `OPERATIONS.md`

---

# 8. Data dictionary and source documentation — BUILT

`docs/06-data-dictionary/`

- `OBJECT-CATALOG.md`
- `ENTITY-DICTIONARY.md`
- `RELATION-DICTIONARY.md`
- `CONTEXT-DICTIONARY.md`
- `EVENT-DICTIONARY.md`
- `VECTOR-DICTIONARY.md`
- `AI-DICTIONARY.md`
- `SOURCE-FILE-DOCUMENTATION-STANDARD.md`
- `SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md`

The v0.02 embedded contract requires purpose, impact, dependencies, routines, D3KA linkage, AI linkage, security, performance, transaction behavior, failure modes, rollback/recovery, tests, evidence, references and change history inside each executable source file.

---

# 9. AI/ML/RAG/Agents documentation — BUILT

- `docs/07-ai/AI-ARCHITECTURE.md`
- `docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md`

Fundamental invariant:

```text
AI_RECOMMENDATION != AUTHORIZED_OPERATION
```

The AI layer is designed for semantic retrieval, Graph RAG, recommendation, classification, anomaly/knowledge assistance and agents, while deterministic policy/rights/schedule/operational validation retains execution authority.

---

# 10. Security and audit documentation — BUILT

`docs/09-security/`

- `SECURITY-ARCHITECTURE.md`
- `SECURITY-ARCHITECTURE-MASTER-v0.02.md`
- `PRIVILEGE-MODEL.md`
- `DATA-CLASSIFICATION.md`
- `AUDIT-ARCHITECTURE.md`

---

# 11. Performance/capacity documentation — BUILT

`docs/10-performance/`

- `PERFORMANCE-ARCHITECTURE.md`
- `PERFORMANCE-CAPACITY-MASTER-v0.02.md`
- `WORKLOAD-MODEL.md`
- `INDEXING-STRATEGY.md`
- `CAPACITY-COST-MODEL.md`

---

# 12. Test/certification documentation — BUILT

`docs/11-testing/`

- `MASTER-TEST-STRATEGY.md`
- `TEST-CATALOG.md`
- `TEST-VALIDATION-CERTIFICATION-MASTER-v0.02.md`
- `AI-SAFETY-TEST-PLAN.md`
- `PERFORMANCE-TEST-PLAN.md`
- `SECURITY-TEST-PLAN.md`
- `RECOVERY-TEST-PLAN.md`

---

# 13. Operations/recovery documentation — BUILT

`docs/12-operations/`

- `PRODUCTION-CHANGE-CONTROL.md`
- `BACKUP-RECOVERY-DR.md`
- `BACKUP-RECOVERY-MIGRATION-MASTER-v0.02.md`
- `OBSERVABILITY-RUNBOOK.md`
- `INCIDENT-MODEL.md`

`docs/13-migrations/`
- `MIGRATION-STRATEGY.md`

`docs/14-compliance/`
- `RETENTION-RIGHTS-COMPLIANCE.md`

`docs/15-evidence/`
- `CERTIFICATION-EVIDENCE-MODEL.md`

`docs/16-decisions/`
- `ADR-0001-D3KA-DOMINANT-LOGICAL-MODEL.md`
- `ADR-0002-PRODUCTION-CLASSIFICATION.md`
- `ADR-0003-ONE-RELATIONAL-AUTHORITY.md`

`docs/17-research/`
- `ORACLE-26AI-OFFICIAL-REFERENCES.md`

---

# 14. Migration package — BUILT / SOURCE_ONLY / NOT_DEPLOYED

`migrations/V0001/`

- `README.md`
- `precheck.sql`
- `apply.sql`
- `postcheck.sql`
- `rollback.md`

Presence in Git does not certify execution against production.

---

# 15. Database source inventory — 84 source artifacts

## 15.1 CORE-00 prechecks — 9

- `src/00-precheck/000_database_identity.sql`
- `src/00-precheck/010_feature_inventory.sql`
- `src/00-precheck/020_privilege_inventory.sql`
- `src/00-precheck/030_graph_capability.sql`
- `src/00-precheck/040_vector_capability.sql`
- `src/00-precheck/050_json_duality_capability.sql`
- `src/00-precheck/060_ai_capability.sql`
- `src/00-precheck/070_audit_capability.sql`
- `src/00-precheck/080_capacity_snapshot.sql`

## 15.2 Universal identity/kernel — 4

- `src/02-kernel/200_tps_entity_type.sql`
- `src/02-kernel/210_tps_entity.sql`
- `src/02-kernel/220_tps_property.sql`
- `src/02-kernel/230_tps_source.sql`

## 15.3 D3KA relation/tensor kernel — 9

- `src/03-d3ka/300_tps_relation_type.sql`
- `src/03-d3ka/310_tps_relation.sql`
- `src/03-d3ka/320_tps_d3ka_pkg.pks`
- `src/03-d3ka/321_tps_d3ka_pkg.pkb`
- `src/03-d3ka/330_d3ka_projection_views.sql`
- `src/03-d3ka/340_d3ka_invariants.sql`
- `src/03-d3ka/350_tps_fact_class.sql`
- `src/03-d3ka/351_tps_fact_class_mapping.sql`
- `src/03-d3ka/360_d3ka_coverage_v.sql`

## 15.4 Context engine — 2

- `src/04-context/400_tps_context_type.sql`
- `src/04-context/410_tps_context.sql`

## 15.5 Temporal engine — 3

- `src/05-temporal/500_tps_relation_current_v.sql`
- `src/05-temporal/510_tps_temporal_pkg.pks`
- `src/05-temporal/511_tps_temporal_pkg.pkb`

## 15.6 Property graph — 2

- `src/06-graph/600_tps_media_knowledge_graph.sql`
- `src/06-graph/610_tps_graph_neighbors_v.sql`

## 15.7 VECTOR semantics — 3

- `src/07-vector/700_tps_vector_type.sql`
- `src/07-vector/710_tps_vector.sql`
- `src/07-vector/720_vector_similarity_queries.sql`

## 15.8 Knowledge/provenance — 1

- `src/08-knowledge/810_tps_assertion.sql`

## 15.9 Event fabric — 2

- `src/09-event/900_tps_event_type.sql`
- `src/09-event/910_tps_event.sql`

## 15.10 Policy/rules — 4

- `src/10-policy/1000_tps_policy.sql`
- `src/10-policy/1010_tps_rule.sql`
- `src/10-policy/1020_tps_policy_engine_pkg.pks`
- `src/10-policy/1030_tps_policy_engine_pkg.pkb`

## 15.11 AI/ML/RAG/Agents — 9

- `src/11-ai/1100_tps_ai_model.sql`
- `src/11-ai/1110_tps_ai_agent.sql`
- `src/11-ai/1120_tps_ai_tool.sql`
- `src/11-ai/1130_tps_ai_decision.sql`
- `src/11-ai/1140_graph_rag_neighbors.sql`
- `src/11-ai/1150_select_ai_profile_template.sql`
- `src/11-ai/1160_agent_program_director_template.sql`
- `src/11-ai/1170_agent_sql_tool_template.sql`
- `src/11-ai/1180_agent_task_template.sql`

## 15.12 Media/broadcast — 6

- `src/12-media/1200_tps_station.sql`
- `src/12-media/1210_tps_channel.sql`
- `src/12-media/1220_tps_program.sql`
- `src/12-media/1230_tps_schedule.sql`
- `src/12-media/1240_tps_schedule_item.sql`
- `src/12-media/1250_tps_media_asset.sql`

## 15.13 Commercial — 2

- `src/13-commercial/1300_tps_campaign.sql`
- `src/13-commercial/1310_tps_placement.sql`

## 15.14 Rights — 3

- `src/14-rights/1400_tps_right_grant.sql`
- `src/14-rights/1410_tps_rights_pkg.pks`
- `src/14-rights/1420_tps_rights_pkg.pkb`

## 15.15 Audience — 2

- `src/15-audience/1500_tps_audience_segment.sql`
- `src/15-audience/1510_tps_audience_observation.sql`

## 15.16 Editorial — 1

- `src/16-editorial/1600_tps_editorial_item.sql`

## 15.17 API/JSON projections — 3

- `src/17-api/1700_entity_api_v.sql`
- `src/17-api/1710_station_now_programming_v.sql`
- `src/17-api/1720_entity_duality_view.sql`

## 15.18 Observability/audit — 1

- `src/18-observability/1800_tps_audit_event.sql`

## 15.19 Administration — 1

- `src/19-admin/1900_tps_schema_migration.sql`

## 15.20 Reference dictionaries — 7

- `src/20-reference/2000_entity_types.sql`
- `src/20-reference/2010_relation_types.sql`
- `src/20-reference/2020_context_types.sql`
- `src/20-reference/2030_event_types.sql`
- `src/20-reference/2040_vector_types.sql`
- `src/20-reference/2050_fact_classes.sql`
- `src/20-reference/2060_fact_class_mappings.sql`

## 15.21 Vector indexes/templates — 2

- `src/21-indexes/2100_vector_hnsw_template.sql`
- `src/21-indexes/2110_vector_ivf_template.sql`

## 15.22 Certification queries — 8

- `src/26-certification/2600_object_status.sql`
- `src/26-certification/2610_d3ka_cert.sql`
- `src/26-certification/2620_graph_cert.sql`
- `src/26-certification/2630_vector_cert.sql`
- `src/26-certification/2640_knowledge_cert.sql`
- `src/26-certification/2650_ai_cert.sql`
- `src/26-certification/2660_schedule_rights_cert.sql`
- `src/26-certification/2690_core_summary.sql`

---

# 16. Test inventory — 39 artifacts

## AI — 5

- `tests/AI/AI-001_authority_classes.sql`
- `tests/AI/AI-002_inference_verification.sql`
- `tests/AI/AI-003_policy_boundary.sql`
- `tests/AI/AI-004_graph_rag_evidence.sql`
- `tests/AI/AI-005_prompt_tool_attack-cases.md`

## D3KA — 11

- `D3KA-001_assert_relation.sql`
- `D3KA-002_reject_self.sql`
- `D3KA-003_require_context.sql`
- `D3KA-004_require_provenance.sql`
- `D3KA-005_duplicate_active.sql`
- `D3KA-006_source_slice.sql`
- `D3KA-007_relation_slice.sql`
- `D3KA-008_target_slice.sql`
- `D3KA-009_temporal.sql`
- `D3KA-010_invariants.sql`
- `D3KA-011_coverage.sql`

## Fixtures — 2

- `tests/fixtures/000_fixture_begin.sql`
- `tests/fixtures/999_fixture_rollback.sql`

## Graph — 3

- `tests/graph/G-001_graph_smoke.sql`
- `tests/graph/G-002_graph_relational_equivalence.sql`
- `tests/graph/G-003_graph_relation_integrity.sql`

## Performance — 5

- `PERF-001_entity_lookup.sql`
- `PERF-002_d3ka_slice.sql`
- `PERF-003_schedule_rights.sql`
- `PERF-004_graph_neighborhood.sql`
- `PERF-005_vector_exact.sql`

## Recovery — 2

- `REC-001_object_inventory.sql`
- `REC-002_migration_ledger.sql`

## Regression — 1

- `REG-001_master.sql`

## Security — 4

- `SEC-001_role_grants.sql`
- `SEC-002_no_dba_role.sql`
- `SEC-003_protected_table_direct_dml.md`
- `SEC-004_audit_protection.md`

## Temporal — 1

- `tests/temporal/test_temporal_pkg.sql`

## Unit — 2

- `UT-001_entity_constraints.sql`
- `UT-002_relation_constraints.sql`

## Vector — 3

- `V-001_vector_distance.sql`
- `V-002_exact_topk.sql`
- `V-003_ann_recall_method.md`

---

# 17. Current documentation retrofit status

The repository contains a substantial executable design baseline, but the new v0.02 embedded documentation contract is stricter than the legacy comments in most source files.

At the time this inventory was written:

- `src/00-precheck/000_database_identity.sql` — `DOC_FULL`.
- `src/05-temporal/510_tps_temporal_pkg.pks` — `DOC_PARTIAL`.
- `src/05-temporal/511_tps_temporal_pkg.pkb` — `DOC_PARTIAL`.
- remaining executable source files — `DOC_PARTIAL` or `DOC_PENDING` until individually retrofitted and reviewed.

No file shall be promoted to `CERTIFIED_SOURCE` solely because it exists in Git.

---

# 18. Deployment statement

This inventory records repository construction only.

```text
GITHUB_SOURCE_BUILT = YES
PRODUCTION_DEPLOYMENT_BY_THIS_WORK = NO
ORACLE_DDL_EXECUTED_BY_THIS_WORK = NO
ORACLE_DML_EXECUTED_BY_THIS_WORK = NO
CONTROL_PLANE_MUTATION_BY_THIS_WORK = NO
```
