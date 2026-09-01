# Observability Runbook

Monitor service availability, connection/session pressure, storage, long-running SQL, error classes, API latency, graph/vector query latency, scheduler/jobs, ingest lag, audit health and AI provider latency/error/cost.

No monitoring query may require broad secret exposure. Health views expose minimal operational state to monitoring roles.

Alert thresholds are derived from SLOs and measured baselines, not arbitrary percentages.
