# TPS Graph RAG Design v0.01

## Retrieval pipeline

```text
request/security context
 -> query understanding
 -> vector/lexical candidate retrieval
 -> canonical entity resolution
 -> D3KA/property-graph expansion
 -> temporal filter
 -> context filter
 -> rights/policy/security filter
 -> provenance/confidence selection
 -> bounded evidence pack
 -> model generation
 -> post-generation evidence/policy validation
 -> response + evidence IDs + uncertainty
```

## Why graph plus vector

Vector similarity locates semantically related candidates. Graph traversal provides explicit corporate relationships and provenance pathways. Relational filters enforce exact state/time/policy constraints. Combining all three avoids treating a nearest neighbor as a business fact.

## Evidence pack

Each retrieved item carries entity/relation/assertion/source IDs, timestamps, confidence and data classification. Prompt construction uses a deterministic serializer with token/size limits and excludes objects outside the authorized profile.

## Generation

The model is instructed to distinguish verified facts, observations and inference. Unsupported claims are not silently persisted. Material answers persist a decision record when required by policy.

## Failure modes

No vector results, graph disconnect, conflicting sources, stale rights, unavailable model, token overflow and security-denied evidence each have explicit outcomes. Fallback may return structured non-AI data or `UNAVAILABLE/INSUFFICIENT_EVIDENCE`.
