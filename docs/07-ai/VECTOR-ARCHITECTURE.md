# Vector Architecture v0.01

TPS_VECTOR is a multi-vector registry. One entity may have text, audio, image, style, emotional, audience, editorial or context embeddings from multiple model versions.

## Lifecycle

GENERATED -> ACTIVE -> STALE/SUPERSEDED -> RETIRED. Source hash plus model/version supports reproducibility and staleness detection.

## Search

Exact `VECTOR_DISTANCE` is the mathematical baseline. HNSW/IVF are optional accelerators selected by corpus/update/query workload. Certification measures recall@K against exact results and latency/resource impact.

## Hybrid retrieval

Where lexical precision matters, Oracle Text/hybrid approaches may combine keyword and semantic search, but adoption requires CORE-01 capability proof and CORE-17 benchmark evidence.
