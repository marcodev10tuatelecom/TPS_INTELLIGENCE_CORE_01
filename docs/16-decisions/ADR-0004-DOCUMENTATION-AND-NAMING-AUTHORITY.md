# ADR-0004 — Documentation and Naming Are First-Class Architecture Authorities

Status: ACCEPTED FOR ENGINEERING CONTROL; owner review of individual provisional names remains pending.

## Context

The project contains many database source files, packages, migrations, tests and architecture documents. Some technical names were introduced during engineering. Relying on chat history or undocumented assumptions creates unacceptable project-recovery and governance risk.

## Decision

1. The repository documentation, source, migrations, tests and evidence must be sufficient to reconstruct the project without chat history.
2. Every important name must have an origin/status recorded in `NAMING-AND-IDENTITY-REGISTER-v0.03.md`.
3. A technical identifier introduced by engineering is `ENGINEERING_PROVISIONAL` until explicit owner approval is recorded.
4. No engineer/assistant may describe a provisional name as an owner decision.
5. Renaming a canonical/deployed identifier requires explicit owner approval, impact analysis, migration/compatibility plan, tests and evidence.
6. `CANONICAL-PROJECT-MANUAL-v0.03.md` is the recovery entry point.
7. `ENGINEERING-STATE-LEDGER-v0.03.md` separates source existence from production runtime proof.
8. `SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md` is the current file/routine dependency catalog and supersedes older planned-file catalogs where they conflict.

## Consequences

- Chat/session loss is not a valid reason to lose project architecture.
- Documentation changes are reviewed as engineering changes.
- New source without documentation is incomplete.
- New naming without naming-register entry is incomplete.
- Older maps may remain for history but must be marked superseded when inaccurate.

## Alternatives rejected

- Treat chat history as the primary project record.
- Allow source code names to become canonical simply by being committed.
- Maintain separate undocumented mental models for business, database and AI layers.

## Recovery

If this ADR is superseded, the successor must preserve project-recovery capability and explicitly migrate the naming/documentation authority chain.
