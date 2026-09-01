# Recovery Runbook v0.01

## Objectives
Restore canonical integrity and service within approved RPO/RTO while preserving audit/evidence.

## Sequence
1. declare incident and freeze unsafe mutations;
2. determine integrity boundary and last known good evidence;
3. identify recovery source: service backup, logical export, migration source, external media metadata references;
4. recover to isolated target when possible;
5. run object/invariant/count/hash/rights/schedule/audit validations;
6. run regression and critical performance smoke;
7. authorize cutover/reopen;
8. retain full evidence and postmortem.

Vectors and derived embeddings may be regenerated from preserved source/model versions. Canonical business entities, relations, contracts, rights and audit history require authoritative recovery, not regeneration guesses.
