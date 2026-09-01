# Role-to-Capability Matrix v0.01

| Role | Intended capabilities | Explicit exclusions |
|---|---|---|
| TPS_MEDIA_RUNTIME | resolve schedule/rights/policy; append operational events; approved read projections | no direct relation/rights/policy DML; no DDL |
| TPS_MEDIA_API | read API/graph projections; schedule/policy evaluation | no core table DML/DDL |
| TPS_MEDIA_INGEST | controlled entity/D3KA/event package execution | generic D3KA rejects policy-sensitive relations; no direct core DML |
| TPS_MEDIA_AI | read authorized entity/D3KA/graph/vector/assertion/source data | no direct DML; no role/grant/DDL authority |
| TPS_MEDIA_ANALYTICS | read historical/events/audience/AI/vector analytics | no operational mutation |
| TPS_MEDIA_AUDITOR | read audit/AI decision/migration/assertion/source evidence | no business mutation |
| TPS_MEDIA_ADMIN | application-domain packages/diagnostics | not DBA; no system-level privilege by this role |

Actual users/services receive only required roles after CORE-02 identity design. Role existence does not imply assignment.
