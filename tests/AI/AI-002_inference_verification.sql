-- AI-002 | verified AI inference requires human/verifier evidence | R0
SELECT COUNT(*) AS invalid_verified_ai_assertions
FROM tps_assertion
WHERE assertion_class='AI_INFERENCE'
  AND verification_status='VERIFIED'
  AND (verified_by_entity_id IS NULL OR verified_at IS NULL);
