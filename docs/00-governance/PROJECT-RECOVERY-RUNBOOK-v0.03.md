# TPS_INTELLIGENCE_CORE_01 — PROJECT RECOVERY RUNBOOK v0.03

## Purpose

This runbook exists so the project can be reconstructed from GitHub even if chat history, local notes or an assistant session disappear.

## Recovery rule

Do not rebuild project context from memory. Rebuild it from the repository in this order.

## Step 1 — Identify the authority

Read:

1. `/CANONICAL-PROJECT-MANUAL-v0.03.md`
2. `/docs/00-governance/NAMING-AND-IDENTITY-REGISTER-v0.03.md`
3. `/docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`
4. `/PROJECT-MAP.md`
5. `/TRACEABILITY-MAP.md`

Confirm:

```text
REPOSITORY=TPS_INTELLIGENCE_CORE_01
DATABASE=TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
ENVIRONMENT=PRODUCTION
```

If any source says the current production database is merely a laboratory because of Free tier, that statement is superseded by ADR-0002.

## Step 2 — Reconstruct architecture

Read:

- `docs/03-architecture/MASTER-DATABASE-ENGINEERING-SPEC-v0.02.md`
- `docs/04-d3ka/D3KA-ENGINEERING-SPEC-v0.02.md`
- `docs/03-architecture/PLSQL-CALL-GRAPH-v0.03.md`
- `docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md`
- `docs/09-security/SECURITY-ARCHITECTURE-MASTER-v0.02.md`
- `docs/10-performance/PERFORMANCE-CAPACITY-MASTER-v0.02.md`
- `docs/12-operations/BACKUP-RECOVERY-MIGRATION-MASTER-v0.02.md`

Fundamental invariants to recover:

```text
ONE_RELATIONAL_AUTHORITY=YES
D3KA_DOMINANT_LOGICAL_MODEL=YES
D3KA_TARGET_COVERAGE=>=90_PERCENT
AI_RECOMMENDATION_NE_AUTHORIZED_OPERATION=YES
PRODUCTION_CHANGE_CONTROL=MANDATORY
SOURCE_STATE_NE_PRODUCTION_STATE=YES
```

## Step 3 — Reconstruct database objects and routines

Read:

- `docs/06-data-dictionary/SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`
- `docs/06-data-dictionary/OBJECT-CATALOG.md`
- `docs/06-data-dictionary/ENTITY-DICTIONARY.md`
- `docs/06-data-dictionary/RELATION-DICTIONARY.md`
- other dictionaries in the same directory.

Then inspect the actual source files under `src/`. The source header is mandatory documentation, but a source file does not prove deployment.

## Step 4 — Reconstruct migration history

Read in numeric order:

```text
migrations/V0001/README.md
migrations/V0002/README.md
migrations/V0003/README.md
```

For each migration, inspect:

```text
precheck.sql
apply.sql
postcheck.sql
rollback.md
```

Never execute `apply.sql` merely to determine what it does. Read the source and precheck first.

## Step 5 — Reconstruct runtime proof status

Read `docs/15-evidence/ENGINEERING-STATE-LEDGER-v0.03.md`.

Important distinction:

```text
SOURCE_BUILT
!=
ORACLE_DEPLOYED
!=
ORACLE_COMPILED_VALID
!=
FUNCTIONALLY_TESTED
!=
CERTIFIED
```

If production evidence is missing, status is `NOT_PROVEN`.

## Step 6 — Reconstruct naming decisions

Read `NAMING-AND-IDENTITY-REGISTER-v0.03.md`.

Do not assume an engineering-assigned table/package/title was selected by the owner. Names marked `ENGINEERING_PROVISIONAL` remain reviewable until explicitly approved.

## Step 7 — Resume work

Resume from the first unresolved item in the state ledger and trace it through:

```text
BUSINESS REQUIREMENT
 -> SYSTEM/DATA/AI REQUIREMENT
 -> ADR
 -> DESIGN
 -> SOURCE FILE
 -> ROUTINE/OBJECT
 -> TEST
 -> EVIDENCE
 -> CORE GATE
```

No new object should be created if an existing object already represents the same responsibility unless an ADR explains why duplication is required.

## Step 8 — Emergency reconstruction checklist

Before making any change after context loss, answer from repository evidence:

- What is the exact database identity?
- Is this production?
- What branch/commit is being reviewed?
- What migration is the candidate change part of?
- Has its precheck passed?
- Has the object ever been deployed?
- What are the upstream dependencies?
- What calls it and what does it call?
- What D3KA dimension/domain does it represent?
- Does AI have any access to it?
- What locks/DML/implicit commits can occur?
- What tests prove success and failure modes?
- What is the rollback/recovery path?
- Is the object name owner-approved or engineering-provisional?

If one of these cannot be answered, stop and mark it `UNKNOWN/NOT_PROVEN`.

## Project survival principle

The project must survive loss of any single chat, developer workstation or assistant session. GitHub documentation + source + migrations + tests + evidence are the durable project record.
