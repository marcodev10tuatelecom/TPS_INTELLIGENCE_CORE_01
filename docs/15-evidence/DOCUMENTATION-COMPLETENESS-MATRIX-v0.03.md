# TPS_INTELLIGENCE_CORE_01 — DOCUMENTATION COMPLETENESS MATRIX v0.03

## Purpose

This matrix answers a simple question: **if the project stops now, what is documented well enough to recover, and what documentation is still missing or incomplete?**

No row is marked COMPLETE merely because a file exists.

Status:

- `RECOVERY_COMPLETE` — enough durable documentation exists to reconstruct current project intent/state without chat history.
- `BASELINE_COMPLETE` — baseline document family exists and is usable, but detail can continue to grow.
- `PARTIAL` — material gaps remain.
- `NOT_STARTED` — no adequate current document.
- `STALE/SUPERSEDED` — historical only.

## Matrix

| Documentation family | Current authority | Status | Missing work |
|---|---|---|---|
| Repository recovery entry point | `CANONICAL-PROJECT-MANUAL-v0.03.md` | RECOVERY_COMPLETE | keep updated each major architecture/migration change |
| Context-loss recovery procedure | `PROJECT-RECOVERY-RUNBOOK-v0.03.md` | RECOVERY_COMPLETE | periodic recovery drill |
| Naming/origin/approval | `NAMING-AND-IDENTITY-REGISTER-v0.03.md` | BASELINE_COMPLETE | owner review of provisional names |
| Project state/source-vs-runtime | `ENGINEERING-STATE-LEDGER-v0.03.md` | RECOVERY_COMPLETE | update after every runtime gate |
| Business capability map | `BROADCAST-GROUP-CAPABILITY-CATALOG-v0.03.md` | BASELINE_COMPLETE | financial/billing/regulatory/local-quota detail |
| Project workstreams/gates | `PROJECT-MAP.md` | BASELINE_COMPLETE | reconcile future workstreams as scope evolves |
| Requirement traceability | `TRACEABILITY-MAP.md` v0.03 | PARTIAL | assign full BR/SR/DR/AIR IDs to every domain/routine |
| Documentation map | `DOCUMENTATION-MAP.md` v0.03 | RECOVERY_COMPLETE | keep authoritative links current |
| Source tree map | `SOURCE-MAP.md` v0.03 | RECOVERY_COMPLETE | update when directories change |
| Current source/object/routine/dependency catalog | `SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` | BASELINE_COMPLETE | add column-level and every private routine detail |
| Embedded source documentation contract | `SOURCE-EMBEDDED-DOCUMENTATION-CONTRACT-v0.02.md` | BASELINE_COMPLETE | run mechanical validator across all sources |
| Source documentation coverage | old v0.02 matrix | STALE/SUPERSEDED FOR CURRENT COUNT | regenerate mechanically after full retrofit |
| Master database architecture | `MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md` | BASELINE_COMPLETE | update to v0.03 after owner naming review |
| D3KA formal/engineering architecture | D3KA docs v0.02 | BASELINE_COMPLETE | weighted/per-domain coverage formal proof; conflict algebra |
| PL/SQL call architecture | `PLSQL-CALL-GRAPH-v0.03.md` | BASELINE_COMPLETE | include every older package/private helper and future API calls |
| Business analysis | `docs/01-business/*` | PARTIAL | economics, detailed station workflows, role/RACI, billing |
| Functional requirements | `docs/02-requirements/*` | PARTIAL | full requirement IDs and acceptance criteria per capability |
| Nonfunctional requirements | `docs/02-requirements/*` | PARTIAL | numeric SLO/RPO/RTO/concurrency/capacity targets |
| Domain organization/network/station | domain docs + capability catalog | PARTIAL | formal affiliate/repeater precedence/local-share rules |
| Programming/scheduling | architecture + PL/SQL + capability catalog | PARTIAL | full rule catalog, DST, quotas, rotation, live-event workflow |
| Media asset model | domain docs/source | PARTIAL | renditions, storage authority, checksum lifecycle, technical QC |
| Rights/licensing | domain docs + rights source | PARTIAL | territory/context, contract lifecycle, legal evidence workflow |
| Commercial/advertising | domain docs + V0003 source | PARTIAL | competitor conflict, inventory, rate card, billing, regional ads |
| Audience | domain docs/source | PARTIAL | privacy model, session/aggregate model, retention, measurement taxonomy |
| Editorial/journalism | domain docs/source | PARTIAL | approval/correction/retraction/workflow/source grading |
| AI/ML/RAG/Agents | master AI spec + AI source | PARTIAL | model cards, agent cards, eval sets, runtime provider profiles, cost limits |
| Security | security master docs | PARTIAL | executable roles/grants, VPD/redaction decision, runtime evidence |
| Audit | audit architecture/source | PARTIAL | native audit policies and retained evidence proof |
| Performance/capacity | performance master | PARTIAL | numeric SLOs, dataset sizes, benchmark outputs, index decisions |
| Testing/certification | test master + existing tests | PARTIAL | complete test matrix per source and runtime outputs |
| Backup/recovery/DR | recovery master | PARTIAL | actual export/rebuild/restore drill and measured RPO/RTO |
| Migration V0001 | README/source | PARTIAL | exact current precheck/apply/postcheck/rollback reconciliation and runtime evidence |
| Migration V0002 | full migration package | BASELINE_COMPLETE SOURCE DOC | runtime precheck/compile/functional/security/performance/recovery evidence |
| Migration V0003 | full migration package | BASELINE_COMPLETE SOURCE DOC | runtime precheck/compile/functional/security/performance/recovery evidence |
| API/ORDS/JSON contracts | API source/design | PARTIAL | versioned endpoint contracts, errors, auth, performance tests |
| Observability/runbooks | ops docs | PARTIAL | metrics/alerts/dashboard thresholds and incident procedures |
| Compliance/retention | compliance docs | PARTIAL | legal owner review and exact retention schedules |
| Oracle technology references | research docs/source headers | BASELINE_COMPLETE | pin exact 26ai documentation/version references per feature |
| ADR catalog | ADR-0001..0004 | PARTIAL | create ADRs for remaining major design choices |

## Minimum project-survival set

The following must never be removed without a replacement:

```text
README.md
CANONICAL-PROJECT-MANUAL-v0.03.md
PROJECT-MAP.md
DOCUMENTATION-MAP.md
SOURCE-MAP.md
TRACEABILITY-MAP.md
NAMING-AND-IDENTITY-REGISTER-v0.03.md
PROJECT-RECOVERY-RUNBOOK-v0.03.md
ENGINEERING-STATE-LEDGER-v0.03.md
SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md
BROADCAST-GROUP-CAPABILITY-CATALOG-v0.03.md
migrations/*
src/*
tests/*
```

## Completion rule

The documentation project itself is not COMPLETE until every in-scope row is `BASELINE_COMPLETE` or better, and every runtime-specific claim has evidence. This matrix must be updated whenever a documentation family crosses a maturity boundary.
