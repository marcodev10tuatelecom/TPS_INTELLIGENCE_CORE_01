# Always Free -> Paid / Migration Runbook v0.01

The environment remains production before and after tier change.

## Prechecks
Inventory database ID/version/workload, storage, network endpoint, mTLS/ACL, users/roles, objects, migrations, feature usage, backup capabilities, service limits, integrations and cost target.

## Promotion/migration validation
- service identity and connection strings;
- wallet/certificate rotation impact where applicable;
- network/ACL/private endpoint architecture if changed;
- Oracle feature/privilege parity;
- object counts/status and D3KA invariants;
- schedules/rights/event/audit integrity;
- vector/graph capability;
- backup/restore functions;
- workload performance/cost.

No application should depend on Free-specific limitations. Capacity change is infrastructure evolution; canonical logical IDs/data semantics remain.
