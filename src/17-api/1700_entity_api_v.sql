-- TPSDBCORE01 | CORE-13 | R1 VIEW | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_entity_api_v AS
SELECT e.entity_id,
       et.type_code AS entity_type,
       e.canonical_key,
       e.canonical_name,
       e.state,
       e.valid_from,
       e.valid_to,
       e.attributes_json
FROM tps_entity e
JOIN tps_entity_type et ON et.entity_type_id=e.entity_type_id;
