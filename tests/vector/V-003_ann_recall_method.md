# V-003 — Approximate Vector Recall Validation

For each benchmark query vector, persist the exact-search top-K IDs in the test harness, execute the candidate ANN index search with the same K, and calculate:

`recall@K = |ANN_topK ∩ exact_topK| / K`.

Report mean, minimum and percentile recall together with p50/p95/p99 latency, corpus size, vector dimension, distance metric, index type/parameters and update age. The requested `TARGET ACCURACY` is configuration, not proof; measured recall is the certification evidence.
