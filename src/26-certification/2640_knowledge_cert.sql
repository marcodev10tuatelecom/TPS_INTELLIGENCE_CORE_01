-- CORE-09 KNOWLEDGE/PROVENANCE CERTIFICATION | R0
SELECT assertion_class,verification_status,COUNT(*)
FROM tps_assertion
GROUP BY assertion_class,verification_status
ORDER BY assertion_class,verification_status;

SELECT COUNT(*) AS relation_missing_required_provenance
FROM tps_relation r
JOIN tps_relation_type rt ON rt.relation_type_id=r.relation_type_id
WHERE rt.requires_provenance=1 AND r.provenance_source_id IS NULL;
