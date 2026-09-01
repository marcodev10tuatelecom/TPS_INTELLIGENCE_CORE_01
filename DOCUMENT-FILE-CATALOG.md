# TPS_INTELLIGENCE_CORE_01 — Normative Document Catalog v0.01

This catalog identifies the role of each documentation family. Files are normative unless explicitly described as templates/research.

## Root authorities

| File | Authority |
|---|---|
| `README.md` | Repository/database identity, PRODUCTION classification, D3KA target and technology foundation |
| `PROJECT-MAP.md` | Complete workstream and CORE gate map |
| `DOCUMENTATION-MAP.md` | Documentation hierarchy, required sections and completeness rule |
| `SOURCE-MAP.md` | Source/test directory architecture and reversibility classes |
| `SOURCE-FILE-CATALOG.md` | File-by-file executable source responsibility/traceability |
| `DOCUMENT-FILE-CATALOG.md` | This document: document-by-document authority map |
| `TRACEABILITY-MAP.md` | Business/system requirements to architecture/source/test/evidence |
| `SECURITY.md` | Repository credential/security policy |
| `CONTRIBUTING.md` | Change contribution rules |

## `docs/00-governance`

- `PROJECT-CHARTER.md`: mission, scope, success and production status.
- `AUTHORITY-MODEL.md`: business/data/security/change/AI authority hierarchy and data authority classes.
- `VERSIONING.md`: repository, migration, API, AI and taxonomy versioning.
- `ADR-POLICY.md`: when/how architecture decisions are recorded.
- `EVIDENCE-STANDARD.md`: minimum immutable evidence metadata and secret-redaction rule.

## `docs/01-business`

- `BUSINESS-ANALYSIS.md`: business problem, desired state, capabilities, value and critical risk.
- `CAPABILITY-MAP.md`: top-level corporate/media/commercial/intelligence capabilities.
- `STAKEHOLDERS-ACTORS.md`: humans, services and AI actors separated from authorization roles.
- `PROCESS-MAP.md`: programming, onboarding, advertising, AI recommendation and stewardship processes.
- `BUSINESS-RULES.md`: initial deterministic/canonical business rules.

## `docs/02-requirements`

- `MASTER-REQUIREMENTS.md`: requirement namespaces, fields and priorities.
- `FUNCTIONAL-REQUIREMENTS.md`: core functional behavior.
- `NONFUNCTIONAL-REQUIREMENTS.md`: integrity, availability, security, auditability, scalability, portability, observability and recovery.
- `DATA-REQUIREMENTS.md`: canonical identity/relation/time/provenance/vector/media data rules.
- `AI-REQUIREMENTS.md`: AI authority, grounding, versioning, injection defense, tool scope and failure requirements.

## `docs/03-architecture`

- `SYSTEM-CONTEXT.md`: external consumers/providers/storage and trust/data-plane boundaries.
- `LOGICAL-ARCHITECTURE.md`: identity/D3KA/graph/vector/knowledge/domain/policy/event/API layers.
- `PHYSICAL-ARCHITECTURE.md`: Oracle 26ai physical technology mapping.
- `DEPLOYMENT-ARCHITECTURE.md`: Git-to-production controlled deployment path.
- `TECHNOLOGY-DECISION-MATRIX.md`: need -> Oracle technology -> rationale -> risk/control.

## `docs/04-d3ka`

- `D3KA-FORMAL-MODEL.md`: formal tensor domain, cell tuple, sparse representation, operations and invariants.
- `D3KA-ALGEBRA-AND-QUERY-SEMANTICS.md`: selection/projection/composition/temporal/vector-assisted query semantics.
- `D3KA-CONTEXT-SEMANTICS.md`: atomic/composite/hierarchical context and network/local override semantics.
- `D3KA-TEMPORAL-SEMANTICS.md`: valid/observed/recorded/event time semantics.
- `D3KA-COVERAGE-METRIC.md`: >=90% fact-class coverage denominator/numerator/anti-gaming rules.
- `D3KA-EXPLAINABILITY.md`: machine evidence and human explanation contract.

## `docs/05-domain`

- `DOMAIN-MASTER-MAP.md`: canonical domain list and D3KA cross-domain rule.
- `ORGANIZATION-NETWORK-STATION.md`: networks/stations/channels/affiliates/repeaters/regions.
- `PROGRAMMING-SCHEDULING.md`: schedule classes, local override and 24x7 continuity authority.
- `MEDIA-ASSET-MUSIC-VIDEO.md`: intellectual content vs physical renditions, hashes/lineage/vectors.
- `ADVERTISING-COMMERCIAL.md`: advertisers/campaigns/creative/inventory/placement constraints.
- `RIGHTS-LICENSING.md`: grants/denials/territory/windows/source documents.
- `AUDIENCE.md`: aggregate/pseudonymous observations and affinity.
- `EDITORIAL.md`: news/report provenance, verification and AI classification.
- `OPERATIONS.md`: infrastructure/service/incident knowledge without making Oracle the stream data plane.

## `docs/06-data-dictionary`

- `OBJECT-CATALOG.md`: planned canonical database object inventory.
- `ENTITY-DICTIONARY.md`: TPS_ENTITY semantics/columns/lifecycle.
- `RELATION-DICTIONARY.md`: TPS_RELATION D3KA cell semantics/columns/cardinality.
- `CONTEXT-DICTIONARY.md`: context dimension/payload rules.
- `EVENT-DICTIONARY.md`: event taxonomy/append semantics.
- `VECTOR-DICTIONARY.md`: vector type/model/source metadata.
- `AI-DICTIONARY.md`: model/agent/tool/decision object semantics.

## `docs/07-ai`

- `AI-ARCHITECTURE.md`: complete AI layer and protected-action authority boundary.
- `GRAPH-RAG-DESIGN.md`: vector + graph + temporal/context/security/provenance retrieval pipeline.
- `MODEL-GOVERNANCE.md`: model-card/evaluation/data-exposure/version lifecycle.
- `AGENT-CATALOG.md`: governed logical agents and allowed roles.
- `PROMPT-TOOL-SECURITY.md`: injection/trust/tool/credential controls.
- `VECTOR-ARCHITECTURE.md`: multi-vector lifecycle, exact/ANN validation, hybrid search.
- `AI-DECISION-LEDGER.md`: material AI decision evidence semantics.

## `docs/08-api`

- `API-ARCHITECTURE.md`: versioned TPS MEDIA API resources and mutation/security rules.
- `JSON-DUALITY-CONTRACTS.md`: selected Oracle JSON Relational Duality projection policy.
- `API-ERROR-MODEL.md`: deterministic API/business/AI error taxonomy.
- `CONTRACT-VERSIONING.md`: API compatibility independent of physical schema evolution.

## `docs/09-security`

- `SECURITY-ARCHITECTURE.md`: least privilege, role families, graph/vector/AI security.
- `PRIVILEGE-MODEL.md`: owner/runtime/API/AI separation and protected mutations.
- `DATA-CLASSIFICATION.md`: PUBLIC/INTERNAL/CONFIDENTIAL/RESTRICTED classifications.
- `AUDIT-ARCHITECTURE.md`: Oracle native audit plus business/AI audit ledgers.

## `docs/10-performance`

- `PERFORMANCE-ARCHITECTURE.md`: workload classes, percentiles and optimization order.
- `WORKLOAD-MODEL.md`: representative transactions and scale factors.
- `INDEXING-STRATEGY.md`: relational/D3KA/vector/text/spatial indexing rules.
- `CAPACITY-COST-MODEL.md`: entity/relation/vector/event/storage/query/AI growth metrics.

## `docs/11-testing`

- `MASTER-TEST-STRATEGY.md`: complete test/certification levels and evidence requirements.
- `TEST-CATALOG.md`: enumerated UT/D3KA/G/V/AI/SEC/PERF/REC/REG cases.
- `PERFORMANCE-TEST-PLAN.md`: scale/percentile/recall methodology.
- `AI-SAFETY-TEST-PLAN.md`: hallucination/injection/tool/policy/provider failure campaigns.
- `SECURITY-TEST-PLAN.md`: positive and negative privilege tests.
- `RECOVERY-TEST-PLAN.md`: rebuild/import/migration/recovery certification.

## `docs/12-operations`

- `PRODUCTION-CHANGE-CONTROL.md`: mandatory production mutation record/process.
- `BACKUP-RECOVERY-DR.md`: backup/restore/rebuild/RPO/RTO principles.
- `OBSERVABILITY-RUNBOOK.md`: operational metrics/health/alerts.
- `INCIDENT-MODEL.md`: incident classes and required record.
- `DEPLOYMENT-RUNBOOK.md`: precheck/apply/postcheck/recovery workflow.
- `RECOVERY-RUNBOOK.md`: integrity-first disaster recovery sequence.
- `TIER-PROMOTION-MIGRATION-RUNBOOK.md`: Free->paid/migration recertification.
- `DATABASE-MAINTENANCE-RUNBOOK.md`: Autonomous-aware maintenance.
- `AI-EMERGENCY-DISABLE-RUNBOOK.md`: immediate controlled disable/fallback for AI incidents.

## `docs/13-migrations`

- `MIGRATION-STRATEGY.md`: immutable migration/checksum/reversibility rules.
- `RELEASE-MANAGEMENT.md`: release lifecycle and distinction between DEPLOYED/CERTIFIED.
- `SCHEMA-EVOLUTION-PATTERNS.md`: expand/migrate/contract and compatibility patterns.

## `docs/14-compliance`

- `RETENTION-RIGHTS-COMPLIANCE.md`: retention/legal/rights/privacy audit architecture.
- `AI-GOVERNANCE-COMPLIANCE.md`: purpose/provider/evidence/authority controls for AI.
- `PRIVACY-DATA-MINIMIZATION.md`: minimize personal data and classify embeddings derived from it.

## `docs/15-evidence`

- `CERTIFICATION-EVIDENCE-MODEL.md`: gate evidence manifest concepts/statuses.
- `CORE-GATE-MANIFEST-TEMPLATE.md`: standard gate decision record template.

## `docs/16-decisions`

- `ADR-0001-D3KA-DOMINANT-LOGICAL-MODEL.md`: D3KA >=90% eligible fact-class decision.
- `ADR-0002-PRODUCTION-CLASSIFICATION.md`: TPSDBCORE01 is production despite current Free tier.
- `ADR-0003-ONE-RELATIONAL-AUTHORITY.md`: relational SoR with convergent graph/vector/JSON projections.
- `ADR-0004-AI-NOT-AUTHORITY.md`: protected decisions remain deterministic/policy-controlled.
- `ADR-0005-VECTOR-SEPARATE-FROM-D3KA.md`: semantic vectors do not replace explicit knowledge relations.
- `ADR-0006-JSON-DUALITY-FOR-PROJECTIONS.md`: selective duality projections without duplicate truth.

## `docs/17-research`

- `ORACLE-26AI-OFFICIAL-REFERENCES.md`: official Oracle source register.
- `TECHNOLOGY-VALIDATION-REGISTER.md`: documented -> visible -> privilege -> runtime -> performance/security -> certified states.

## Completeness control

A future documentation file must be added here in the same change. A source file is not production-certifiable unless its behavior is represented in `SOURCE-FILE-CATALOG.md` and linked to requirements/tests/evidence.
