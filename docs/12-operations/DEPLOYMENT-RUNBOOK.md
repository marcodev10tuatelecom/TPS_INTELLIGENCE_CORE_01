# TPSDBCORE01 Production Deployment Runbook v0.01

## Before
1. approved change ID and source commit;
2. exact migration/source checksum;
3. DB/service/user identity precheck;
4. current object/migration inventory;
5. dependency/capability check;
6. backup/recovery method appropriate to change class;
7. maintenance/communication decision;
8. tested postcheck and abort criteria.

## Apply
Use immutable reviewed source. Stop immediately on wrong DB, missing prerequisite, unexpected object state or SQL error. Do not continue with manual improvised repair inside the same change unless the recovery plan explicitly permits it.

## After
Run object validity, domain invariants, D3KA coverage, security/audit, targeted performance and migration ledger checks. Capture evidence/checksums. Close change only when acceptance criteria are proven.

## Rollback/recovery
Use the change-specific recovery path. Additive pre-data objects may be dropped in reverse order if validated. Once canonical data exists, prefer forward correction or tested restore/clone rather than destructive generic rollback.
