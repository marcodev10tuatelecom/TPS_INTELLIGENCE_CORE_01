-- D3KA-009 | temporal validity predicate
SELECT relation_id FROM tps_relation
WHERE :as_of_time >= valid_from AND (:as_of_time < valid_to OR valid_to IS NULL);
