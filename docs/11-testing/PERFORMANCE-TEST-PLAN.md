# Performance Test Plan

Datasets are scaled by E (entities), R (relations), V (vectors), EV (events), S (schedule items). Baselines are sized to the available capacity tier; no fictitious large-scale result is accepted.

For each query class record p50/p95/p99, throughput, errors, concurrent sessions, rows examined/returned, plan/hash where available, storage and CPU indicators. Vector approximate search also records recall@K against exact search. Graph tests record path length and fan-out.

No SLO is declared PASS until measured and approved.
