# AI Model Governance v0.01

Every model used by TPSDBCORE01 has a model card: model key, provider/model ID, version, purpose, owner, data classifications allowed, region/provider data handling, context limit, embedding dimension/format if applicable, cost model, latency baseline, evaluation dataset/version, quality metrics, safety tests, known limitations, fallback, lifecycle and deprecation date.

A provider/model change is not transparent configuration when it can change output quality or data exposure; it is a controlled AI change requiring regression.

Embeddings record their source hash and model version. Re-embedding creates a new version/lifecycle state rather than pretending old and new vectors are equivalent.
