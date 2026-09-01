-- TPSDBCORE01 | CORE-13 | R1 | NOT DEPLOYED
-- Oracle 26ai JSON Relational Duality read projection. Capability must pass CORE-01.
CREATE JSON RELATIONAL DUALITY VIEW tps_entity_dv AS
  tps_entity {
    _id           : entity_id,
    entityTypeId  : entity_type_id,
    canonicalKey  : canonical_key,
    canonicalName : canonical_name,
    state         : state,
    attributes    : attributes_json,
    validFrom     : valid_from,
    validTo       : valid_to
  };
