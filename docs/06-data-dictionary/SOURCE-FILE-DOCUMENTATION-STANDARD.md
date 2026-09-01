# SOURCE FILE DOCUMENTATION STANDARD

Every executable or declarative database source file in `src/`, `migrations/` or deployment tooling must be documented to file level.

## Mandatory metadata header

Each source file shall identify, in comments or adjacent catalog metadata:

- FILE_ID
- PATH
- TITLE
- VERSION
- STATUS
- DATABASE=TPSDBCORE01
- ENVIRONMENT=PRODUCTION
- DOMAIN
- OBJECT_NAME(S)
- OBJECT_TYPE(S)
- REQUIREMENT_IDS
- CORE_GATE
- D3KA_ROLE
- DEPENDENCIES
- REVERSIBILITY_CLASS
- SECURITY_CLASSIFICATION
- EXPECTED_LOCKING
- EXPECTED_DATA_MUTATION
- EXPECTED_DURATION_CLASS
- PRECHECK
- POSTCHECK
- ROLLBACK_OR_RECOVERY
- TEST_FILES
- EVIDENCE_OUTPUT
- AUTHORING_DATE

## Mandatory prose documentation per file

For every source file the Source Catalog must explain:

1. WHAT — objects and behavior created/changed/read.
2. WHY — business/system reason.
3. WHERE — schema/domain and dependencies.
4. HOW — Oracle features and algorithms used.
5. DATA — data read/written and classification.
6. D3KA — entity/relation/context/temporal/graph/vector role.
7. AI — whether AI reads/writes/uses the object and authority restrictions.
8. SECURITY — privileges and exposure.
9. PERFORMANCE — expected workload, indexing and locking impact.
10. DEPLOYMENT — ordering and prerequisites.
11. FAILURE MODES — expected failure cases and fail-closed behavior.
12. RECOVERY — rollback/rebuild/restore strategy.
13. TESTS — exact unit/integration/security/performance/recovery tests.
14. EVIDENCE — output proving successful deployment/behavior.
15. LIFECYCLE — planned/source-ready/tested/deployed/certified/retired.

## Source categories

- R0 DISCOVERY/CERTIFICATION: SELECT/read-only, no persistent mutation.
- R1 ADDITIVE: new objects/metadata with straightforward controlled removal before business use.
- R2 STATEFUL ADDITIVE: changes schema or persistent state; compensating migration required.
- R3 TRANSFORMATIVE: data transformation, externally visible contract or destructive risk; backup/restore or blue-green migration required.
- R4 IRREVERSIBLE BUSINESS HISTORY: normally prohibited; exceptional authority required.

## Production control

Being present in Git does not mean deployed. Each file has two independent states:

`SOURCE_STATE` and `PRODUCTION_STATE`.

Example:

`SOURCE_STATE=TESTED`  
`PRODUCTION_STATE=NOT_DEPLOYED`

No documentation may conflate those states.

## D3KA source classification

Every source file must declare one D3KA role:

- D3KA_CORE
- D3KA_ENTITY
- D3KA_RELATION
- D3KA_CONTEXT
- D3KA_TEMPORAL
- D3KA_GRAPH
- D3KA_VECTOR
- D3KA_PROVENANCE
- D3KA_POLICY
- D3KA_AI
- D3KA_DOMAIN_PROJECTION
- D3KA_OBSERVABILITY
- D3KA_NOT_APPLICABLE

This classification is used by coverage and traceability reports.
