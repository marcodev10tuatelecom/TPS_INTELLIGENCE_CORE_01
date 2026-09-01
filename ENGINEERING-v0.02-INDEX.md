# TPS_INTELLIGENCE_CORE_01 — ENGINEERING v0.02 INDEX

## Canonical production identity

- Repository: `marcodev10tuatelecom/TPS_INTELLIGENCE_CORE_01`
- Database: `TPSDBCORE01`
- Display name: `TPS_INTELLIGENCE_CORE_01`
- Environment: PRODUCTION
- Platform: Oracle AI Database 26ai / Autonomous AI Transaction Processing
- Current tier: Always Free (capacity/billing tier, not environment class)

## Architectural center

The database is designed as a corporate intelligence fabric with >=90% target semantic relationship coverage through the D3KA model:

`D3KA(source_entity, relation_type, target_entity)`

with orthogonal dimensions for context, valid/observed/recorded time, properties, evidence/provenance, confidence, vectors, policy and AI.

## Authoritative maps

1. `PROJECT-MAP.md` — program/workstreams/CORE gates.
2. `DOCUMENTATION-MAP.md` — document families.
3. `SOURCE-MAP.md` — source-tree authority.
4. `SOURCE-FILE-CATALOG-v0.02.md` — detailed source/object ownership and purpose.
5. `TRACEABILITY-MAP.md` — requirement-to-design-to-source-to-test-to-evidence chain.
6. `docs/00-governance/DEFINITION-OF-COMPLETE.md` — literal completion criteria.
7. `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md` — master engineering architecture.
8. `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md` — formal tensor/knowledge model.
9. `docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md` — AI architecture and safety.
10. `docs/09-security/SECURITY-ARCHITECTURE-MASTER-v0.02.md` — production security architecture.
11. `docs/10-performance/PERFORMANCE-CAPACITY-MASTER-v0.02.md` — workload and capacity engineering.
12. `docs/11-testing/TEST-VALIDATION-CERTIFICATION-MASTER-v0.02.md` — complete test strategy.
13. `docs/12-operations/BACKUP-RECOVERY-MIGRATION-MASTER-v0.02.md` — recovery and migration engineering.
14. `docs/06-data-dictionary/SOURCE-FILE-DOCUMENTATION-STANDARD.md` — mandatory documentation for every source file.

## Source state rule

Git source and production deployment are separate states. Files may exist in this repository while remaining `NOT DEPLOYED`. Nothing in v0.02 automatically mutates TPSDBCORE01.

## Engineering sequence

CORE-00 Discovery baseline  
CORE-01 Oracle 26ai capability certification  
CORE-02 Security identities/schemas  
CORE-03 Universal Entity Kernel  
CORE-04 D3KA Relation Kernel  
CORE-05 Property Graph  
CORE-06 Context Engine  
CORE-07 Temporal Engine  
CORE-08 Vector Layer  
CORE-09 Assertions/Provenance  
CORE-10 AI/ML/RAG/Agents  
CORE-11 Policy Engine  
CORE-12 Audit  
CORE-13 API/JSON Duality  
CORE-14 Synthetic/reference dataset  
CORE-15 D3KA/Graph validation  
CORE-16 AI validation  
CORE-17 Performance/Capacity  
CORE-18 Security/Privacy  
CORE-19 Backup/Recovery/DR  
CORE-20 Certification/Release

## Completion formula

`COMPLETE = BUSINESS + REQUIREMENTS + ARCHITECTURE + D3KA + PHYSICAL_DESIGN + SOURCE + TESTS + SECURITY + PERFORMANCE + RECOVERY + EVIDENCE + TRACEABILITY + GATE_APPROVAL`

Any missing mandatory term keeps the component incomplete.
