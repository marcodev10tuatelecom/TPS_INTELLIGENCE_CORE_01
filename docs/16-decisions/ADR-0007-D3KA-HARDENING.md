# ADR-0007 — D3KA Hardening Before First Deployment

Status: ACCEPTED.

Design review before any production execution changed four details:

1. Active-cell uniqueness is implemented with function-based conditional keys so historical inactive rows are not accidentally made unique.
2. Generic `TPS_D3KA_PKG.assert_relation` rejects relation types marked `policy_sensitive`; protected relations require specialized deterministic domain APIs.
3. Inference/AI/import assertion classes require provenance even if a relation type did not independently require it.
4. Property Graph exposes explicit scalar properties instead of `ALL COLUMNS`, avoiding accidental exposure of extensible JSON payloads and reducing graph surface.
5. D3KA coverage separately reports implemented, validated and certified fact classes; CORE-15 evaluates validated coverage, not merely designed source mappings.

Rationale: fail closed, preserve history, make coverage honest and keep graph surface governed.
