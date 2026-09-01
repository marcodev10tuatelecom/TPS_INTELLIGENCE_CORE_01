# TPS_INTELLIGENCE_CORE_01 — DOCUMENTATION HOME

This directory is part of the production engineering authority for `TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01`.

## Start here after context loss

1. `../CANONICAL-PROJECT-MANUAL-v0.03.md`
2. `00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`
3. `15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`
4. `00-governance/PROJECT-RECOVERY-RUNBOOK-v0.03.md`
5. `../PROJECT-MAP.md`
6. `../TRACEABILITY-MAP.md`
7. `06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`
8. `01-business/BROADCAST-GROUP-CAPABILITY-CATALOG-v0.03.md`
9. `15-evidence/DOCUMENTATION-COMPLETENESS-MATRIX-v0.03.md`

## Governance

`00-governance/`

Project charter, authority model, definition of complete, versioning, documentation-first policy, naming authority and recovery runbook.

Key files:

- `PROJECT-CHARTER.md`
- `AUTHORITY-MODEL.md`
- `DEFINITION-OF-COMPLETE.md`
- `DOCUMENTATION-FIRST-POLICY-v0.02.md`
- `NAMING-AND-IDENTITY-REGISTER-v0.03.md`
- `PROJECT-RECOVERY-RUNBOOK-v0.03.md`

## Business

`01-business/`

Business analysis, business rules, capability/process/stakeholder maps and the current broadcaster-group capability catalog.

Key current map:

- `BROADCAST-GROUP-CAPABILITY-CATALOG-v0.03.md`

## Requirements

`02-requirements/`

Functional, nonfunctional, data and AI requirements. Detailed ID coverage is still incomplete and tracked in the documentation completeness matrix.

## Architecture

`03-architecture/`

- `MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md`
- `PLSQL-CALL-GRAPH-v0.03.md`
- system/logical/physical/deployment architecture documents.

## D3KA / Tensor

`04-d3ka/`

Formal/engineering description of the dynamic sparse S/R/T knowledge tensor and its context, time, provenance, vector and policy dimensions.

## Domain models

`05-domain/`

Organization/network/station, programming, media assets, advertising, rights, audience, editorial and operations domain documents.

## Data dictionary / source catalog

`06-data-dictionary/`

- object catalog;
- entity/relation/context/event/vector/AI dictionaries;
- source documentation standard;
- embedded documentation contract;
- `SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` — current source/routine/dependency authority.

## AI / ML / RAG / Agents

`07-ai/` and `07-ai-ml/`

Architecture, authority boundaries and model/tool/agent engineering.

## API

`08-api/`

Versioned API/ORDS/JSON contracts as they are completed.

## Security

`09-security/`

Identity/privilege architecture, classification, audit and security master specification.

## Performance

`10-performance/`

Workload model, SLO/capacity/indexing strategy and benchmark methodology.

## Testing

`11-testing/`

Master test strategy and functional/security/performance/recovery/AI validation plans.

## Operations / Recovery

`12-operations/`

Production change control, observability, incidents, backup/recovery/migration master documentation.

## Migrations / Compliance

`13-migrations/`, `14-compliance/`

Migration strategy, retention, rights and compliance documentation.

## Evidence

`15-evidence/`

Do not claim runtime PASS without evidence here or an immutable external evidence reference.

Key current documents:

- `ENGINEERING-STATE-LEDGER-v0.03.md`
- `DOCUMENTATION-COMPLETENESS-MATRIX-v0.03.md`
- `PLSQL-VERTICAL-SLICE-COVERAGE-v0.02.md` — historical V0002 source coverage; runtime still not proven.

## Decisions

`16-decisions/`

- ADR-0001 — D3KA dominant logical model.
- ADR-0002 — TPSDBCORE01 is production.
- ADR-0003 — one relational authority/convergent projections.
- ADR-0004 — documentation and naming are first-class authorities.

## Research

`17-research/`

Versioned Oracle/standards references and research notes.

## Rule

Documentation is not an appendix to the code. A source/routine/change is incomplete when its purpose, name status, dependencies, impact, tests, recovery and evidence cannot be reconstructed from this repository.
