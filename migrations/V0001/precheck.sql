-- V0001 PRECHECK | READ ONLY | FAIL CLOSED
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@../../src/00-precheck/000_database_identity.sql
@@../../src/00-precheck/010_feature_inventory.sql
@@../../src/00-precheck/020_privilege_inventory.sql
@@../../src/00-precheck/030_graph_capability.sql
@@../../src/00-precheck/040_vector_capability.sql
@@../../src/00-precheck/050_json_duality_capability.sql
@@../../src/00-precheck/060_ai_capability.sql
@@../../src/00-precheck/070_audit_capability.sql
@@../../src/00-precheck/080_capacity_snapshot.sql

DECLARE
  l_existing NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_existing
    FROM user_objects
   WHERE object_name IN (
     'TPS_SCHEMA_MIGRATION','TPS_ENTITY_TYPE','TPS_ENTITY',
     'TPS_RELATION_TYPE','TPS_RELATION','TPS_D3KA_PKG'
   );

  DBMS_OUTPUT.PUT_LINE('V0001_EXISTING_CORE_OBJECTS='||l_existing);

  IF l_existing <> 0 THEN
    RAISE_APPLICATION_ERROR(
      -20901,
      'V0001_PRECHECK=FAIL: canonical core objects already exist; reconcile runtime before bootstrap'
    );
  END IF;

  DBMS_OUTPUT.PUT_LINE('V0001_PRECHECK=PASS');
END;
/
