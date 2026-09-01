# Indexing Strategy

Relational: PK/FK supporting indexes and selective composite indexes based on observed query plans. Avoid speculative index explosion.

D3KA: prioritize `(SOURCE_ENTITY_ID, RELATION_TYPE_ID, VALID_FROM/TO)`, `(TARGET_ENTITY_ID, RELATION_TYPE_ID, VALID_FROM/TO)` and context lookups where workload proves value.

Vector: start exact for validation/small corpus; evaluate HNSW/IVF using recall vs exact baseline. Online build is preferred for production when supported and justified.

Text/spatial/hybrid indexes require explicit workload and capability evidence.
