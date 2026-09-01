# TPS_INTELLIGENCE_CORE_01 — DOCUMENTATION MAP v0.01

## Authority hierarchy

1. `README.md` — repository identity and production classification.
2. `PROJECT-MAP.md` — program/workstream authority.
3. `DOCUMENTATION-MAP.md` — document inventory and required content.
4. `SOURCE-MAP.md` — source-code inventory and responsibilities.
5. `TRACEABILITY-MAP.md` — requirement-to-evidence authority.
6. `docs/00-governance/*` — governance and decisions.
7. Domain/architecture documents — normative design.
8. `src/*` — implementation source, never self-authorizing for production.
9. `tests/*` — executable verification.
10. `evidence/*` — immutable or referenced proof.

## Documentation tree

```text
docs/
00-governance/      project charter, authority, versioning, ADR rules, change control
01-business/        business architecture, stakeholders, capabilities, processes, economics
02-requirements/    functional, nonfunctional, data, AI, security, compliance requirements
03-architecture/    context, logical, physical, deployment, integration architecture
04-d3ka/            tensor formalism, algebra, invariants, coverage, temporal/context semantics
05-domain/          radio/TV/programming/music/ads/rights/audience/editorial domain models
06-data-dictionary/ logical/physical objects, columns, constraints, indexes, views, packages
07-ai/              AI/ML/vector/RAG/agent architecture, models, tools, prompts, safety
08-api/             ORDS/API contracts, JSON duality, versioning, error model
09-security/        IAM, roles, grants, encryption, privacy, audit, secret handling
10-performance/     SLOs, workloads, query classes, capacity, index strategy, benchmark method
11-testing/         master strategy, test cases, fixtures, regression, chaos/failure tests
12-operations/      runbooks, monitoring, deployment, incident, backup, recovery, maintenance
13-migrations/      migration model, release ledger, rollback/recovery plans
14-compliance/      data classification, retention, legal/rights controls, evidence requirements
15-evidence/        evidence standards, checksums, manifests, certification templates
16-decisions/       ADRs
17-research/        Oracle official references, standards, research notes
```

## Required document families

Each normative document must state: purpose, scope, authority, assumptions, AS-IS evidence, TO-BE design, technology, why selected, alternatives, risks, constraints, interfaces, data, security, performance implications, failure modes, observability, testability, migration impact, rollback/recovery, acceptance criteria, traceability IDs and revision history.

## Completeness rule

A documentation family is `COMPLETE` only when every mandatory section is populated and every claim about the live production database is backed by evidence. Unknown facts remain `UNKNOWN/NOT_PROVEN`; they are never filled by assumption.
