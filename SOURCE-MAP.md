# TPS_INTELLIGENCE_CORE_01 — SOURCE MAP v0.03

## 1. Source authority rule

Source files implement engineering design; they do not authorize execution on production. Every source must identify its purpose, dependencies, D3KA/AI role, transaction/locking impact, reversibility, tests and evidence.

Current detailed source/object/routine authority:

`docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`

Naming origin/approval authority:

`docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`

Runtime proof authority:

`docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`

## 2. Current source tree responsibility

```text
src/
00-precheck/       read-only database/version/capability/privilege/audit/capacity discovery
02-kernel/         universal entity/type/property/source identity and provenance foundations
03-d3ka/           relation ontology, sparse tensor cell, package, projections, invariants, coverage
04-context/        context taxonomy and instances
05-temporal/       current-valid projection and shared half-open interval functions
06-graph/          Oracle Property Graph and graph-neighbor projection
07-vector/         vector type/storage and exact similarity source
08-knowledge/      provenance-bearing assertions
09-event/          event taxonomy and event ledger
10-policy/         policy/rule tables and current deterministic policy package
11-ai/             AI model/agent/tool/decision metadata, RAG/templates and bounded AI control plane
12-media/          station/channel/program/schedule/assets, programming, continuity and hard rules
13-commercial/     campaign, placement and commercial authorization
14-rights/         rights grants and deterministic rights decision
15-audience/       audience segment/observation projections
16-editorial/      editorial item projection
17-api/            entity/programming read models and JSON Duality source
18-observability/  audit-event source
19-admin/          schema migration ledger/admin source
20-reference/      governed entity/relation/context/event/vector/fact/AI-tool/rating reference sources
21-indexes/        vector index templates
26-certification/  read-only object/D3KA/graph/vector/knowledge/AI/schedule-rights/release evidence queries
```

There is no current `src/01-security`, `src/22-jobs`, `src/23-export-import`, `src/24-migrations` or `src/25-rollback` implementation family in the authoritative source catalog unless actual files are later added. Security/migration/recovery responsibilities are currently represented by documentation, migration packages and existing source families. A directory name must not be documented as implemented merely because it appeared in an old plan.

## 3. Current executable PL/SQL package families

```text
TPS_D3KA_PKG
TPS_TEMPORAL_PKG
TPS_POLICY_ENGINE_PKG
TPS_RIGHTS_PKG
TPS_AI_GUARD_PKG
TPS_AI_PROGRAMMING_TOOL_PKG
TPS_PROGRAMMING_PKG
TPS_CONTINUITY_PKG
TPS_PROGRAMMING_RULES_PKG
TPS_COMMERCIAL_PKG
```

Exact routine names/call dependencies are in the detailed source catalog and `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md`.

## 4. Intentional trigger source

```text
TRG_TPS_CONT_DECISION_IMMUTABLE
TRG_TPS_SCHEDULE_POLICY_GUARD
```

Triggers are used for evidence immutability or bypass-resistant state guards, not as the primary place to hide business workflows.

## 5. Migration source authority

```text
migrations/V0001/   canonical kernel bootstrap
migrations/V0002/   programming + AI guard + continuity
migrations/V0003/   programming hard rules + commercial authorization
```

Each production change unit uses a precheck/apply/postcheck/rollback-or-recovery structure where available. Migration titles are engineering-provisional; numeric migration IDs are stable once referenced.

## 6. Test families currently represented

```text
tests/
AI/
D3KA/
compile/
fixtures/
graph/
performance/
programming/
recovery/
regression/
security/
temporal/
unit/
vector/
```

Additional commercial/continuity/AI-control tests may be introduced as dedicated folders; their absence as a folder does not mean no related test exists elsewhere.

## 7. Source/repository state distinction

```text
SOURCE_EXISTS
  -> documentation/static review
  -> SOURCE_READY
  -> approved production migration
  -> DEPLOYED
  -> VALID_COMPILED where applicable
  -> functional/security/performance/recovery tests
  -> CERTIFIED
```

No state transition is inferred.

## 8. Reversibility classes

- `READ_ONLY` / R0 — no persistent mutation.
- `R1_ADDITIVE` — additive object/metadata; removable before use.
- `R2_STATEFUL` — persistent state/schema behavior requiring compensating recovery.
- `R3_TRANSFORMATIVE` — destructive/external-contract/data-transforming; backup/restore or forward recovery required.
- `R4_IRREVERSIBLE_HISTORY` — exceptional/prohibited without explicit authority.

## 9. Naming status

Object and package names introduced during engineering are `ENGINEERING_PROVISIONAL` unless separately recorded as owner-approved. Source presence is not naming approval.
