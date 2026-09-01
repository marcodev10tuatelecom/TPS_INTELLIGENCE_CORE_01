# TPS_RELATION Data Dictionary

TPS_RELATION is the physical relation kernel for D3KA.

Columns: RELATION_ID, SOURCE_ENTITY_ID, RELATION_TYPE_ID, TARGET_ENTITY_ID, CONTEXT_ID nullable, WEIGHT, CONFIDENCE, STATE, ATTRIBUTES_JSON, VALID_FROM, VALID_TO, OBSERVED_AT, RECORDED_AT, SOURCE_ID/provenance reference where applicable, CREATED_AT, CREATED_BY.

Uniqueness is relation-type/cardinality aware; a single blanket unique constraint cannot encode every temporal/context relationship. TPS_D3KA_PKG/policies enforce advanced invariants.
