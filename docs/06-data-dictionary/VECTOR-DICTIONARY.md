# Vector Dictionary

Vector types initially: TEXT_SEMANTIC_VECTOR, AUDIO_SEMANTIC_VECTOR, IMAGE_SEMANTIC_VECTOR, MUSIC_STYLE_VECTOR, EMOTIONAL_VECTOR, AUDIENCE_AFFINITY_VECTOR, EDITORIAL_VECTOR, BRAND_VECTOR, PROGRAM_VECTOR, COMMERCIAL_VECTOR, CONTEXT_VECTOR.

Each TPS_VECTOR row records owner entity/assertion/content reference, VECTOR_TYPE_ID, MODEL_ID/version, dimension, element/storage metadata, source hash, embedding VECTOR, lifecycle and timestamps.

Exact search is validation baseline. Approximate indexes require measured recall and workload justification.
