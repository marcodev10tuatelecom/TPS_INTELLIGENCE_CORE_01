# TPS_INTELLIGENCE_CORE_01 — DOCUMENTATION MAP v0.03

## 1. Authority hierarchy

1. `README.md` — repository entry point.
2. `CANONICAL-PROJECT-MANUAL-v0.03.md` — current recovery/master map.
3. `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md` — name origin/approval authority.
4. `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md` — source/runtime proof authority.
5. `PROJECT-MAP.md` — workstreams and CORE gates.
6. `TRACEABILITY-MAP.md` — business -> requirement -> source -> test -> evidence.
7. `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md` — system architecture.
8. `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md` — D3KA/tensor architecture.
9. `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md` — implemented PL/SQL call architecture.
10. `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` — current source/object/routine/dependency catalog.
11. domain/security/performance/testing/operations documents — normative subsystem design.
12. `src/*` — implementation source; never self-authorizing for production.
13. `tests/*` — executable validation.
14. `docs/15-evidence/*` — proof/evidence state.

If an older document conflicts with a later authority document, the later document controls only when it explicitly supersedes the older statement. Historical files are retained for audit rather than silently rewritten as if they never existed.

## 2. Recovery documents

These files exist specifically to ensure the project survives loss of chat/session context:

- `CANONICAL-PROJECT-MANUAL-v0.03.md`
- `docs/00-governance/PROJECT-RECOVERY-RUNBOOK-v0.03.md`
- `docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`
- `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`
- `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`

## 3. Documentation tree and responsibility

```text
docs/
00-governance/      project charter, authority, naming, ADR rules, versioning, recovery
01-business/        business architecture, actors, capabilities, processes, business rules
02-requirements/    functional, nonfunctional, data and AI requirements
03-architecture/    context, logical, physical, deployment, PL/SQL call architecture
04-d3ka/            tensor formalism, dimensions, invariants, coverage, semantics
05-domain/          network/station/programming/media/commercial/rights/audience/editorial domains
06-data-dictionary/ objects, tables, columns, packages, routines, source/dependency catalog
07-ai/              AI architecture
07-ai-ml/           AI/ML/RAG/agent master engineering specification
08-api/             API/ORDS/JSON contracts when built
09-security/        IAM, roles, grants, privacy, audit, secret handling
10-performance/     SLOs, workload classes, indexes, capacity, benchmark methods
11-testing/         test strategy, catalogs, negative/security/performance/recovery tests
12-operations/      change control, monitoring, incident, backup/recovery/maintenance
13-migrations/      migration strategy and release semantics
14-compliance/      classification, retention, rights/regulatory controls
15-evidence/        evidence standards and exact engineering/runtime state
16-decisions/       ADRs
17-research/        Oracle/standards/research references
```

## 4. Existing major documentation families

### Governance

- `PROJECT-CHARTER.md`
- `AUTHORITY-MODEL.md`
- `DEFINITION-OF-COMPLETE.md`
- `DOCUMENTATION-FIRST-POLICY-v0.02.md`
- `SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md`
- `NAMING-AND-IDENTITY-REGISTER-v0.03.md`
- `PROJECT-RECOVERY-RUNBOOK-v0.03.md`
- `VERSIONING.md`
- ADR policy and ADRs.

### Business and requirements

- business analysis;
- capability/process/stakeholder maps;
- business rules;
- functional/nonfunctional/data/AI requirements.

### Architecture

- master database engineering specification;
- logical/physical/deployment architecture;
- D3KA engineering;
- AI/ML/RAG/Agents master specification;
- PL/SQL call graph.

### Data/source documentation

- object catalog;
- entity, relation, context, event, vector and AI dictionaries;
- source-file documentation standard;
- embedded source documentation contract;
- source/routine/dependency catalog.

### Quality/operations

- performance/capacity master;
- test/validation/certification master;
- security master;
- backup/recovery/migration master;
- production change control;
- evidence/state ledgers.

## 5. Mandatory contents of a normative document

When applicable, every normative document must identify:

- title/version/status;
- purpose and scope;
- authority/owner;
- terminology and name status;
- assumptions and UNKNOWN items;
- AS-IS evidence;
- TO-BE design;
- business reason;
- technology and why selected;
- alternatives/rejections;
- D3KA/data semantics;
- interfaces/callers/consumers;
- security/privacy;
- transaction/locking;
- performance/capacity;
- failure modes;
- observability;
- testability;
- deployment/migration impact;
- rollback/recovery;
- acceptance criteria;
- source/test/evidence links;
- revision history.

## 6. Source documentation rule

Every `.sql`, `.pks`, `.pkb` must be documented at file level. Every PL/SQL function/procedure must be documented at routine level. The embedded contract is defined by:

`docs/06-data-dictionary/SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md`

The current catalog of source/routines/dependencies is:

`docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`

## 7. Naming documentation rule

No technical/business name introduced during engineering is assumed to be owner-approved. Its status must be recorded as `ENGINEERING_PROVISIONAL` until explicit approval.

Naming authority:

`docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`

## 8. Production/evidence rule

```text
SOURCE_EXISTS
!= DEPLOYED
!= VALID_COMPILED
!= FUNCTIONALLY_TESTED
!= CERTIFIED
```

Current proof authority:

`docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`

## 9. Completeness rule

A documentation family is `COMPLETE` only when every mandatory in-scope section is populated and every claim about live TPSDBCORE01 is backed by production evidence. Unknown facts remain `UNKNOWN/NOT_PROVEN`; they are never completed by inference.
