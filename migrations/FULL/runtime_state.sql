-- TPSDBCORE01 RUNTIME STATE DETECTOR
-- READ ONLY. Safe first command before choosing any migration.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

DECLARE
  FUNCTION object_exists(p_name VARCHAR2, p_type VARCHAR2) RETURN NUMBER IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n
      FROM user_objects
     WHERE object_name=UPPER(p_name)
       AND object_type=UPPER(p_type);
    RETURN CASE WHEN l_n>0 THEN 1 ELSE 0 END;
  END;

  FUNCTION object_valid(p_name VARCHAR2, p_type VARCHAR2) RETURN NUMBER IS
    l_n NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_n
      FROM user_objects
     WHERE object_name=UPPER(p_name)
       AND object_type=UPPER(p_type)
       AND status='VALID';
    RETURN CASE WHEN l_n>0 THEN 1 ELSE 0 END;
  END;

  l_core NUMBER := 0;
  l_v2 NUMBER := 0;
  l_v3 NUMBER := 0;
  l_v4 NUMBER := 0;
  l_invalid NUMBER := 0;
  l_errors NUMBER := 0;
  l_total_tps NUMBER := 0;
  l_next VARCHAR2(100);
BEGIN
  SELECT COUNT(*) INTO l_total_tps
    FROM user_objects
   WHERE object_name LIKE 'TPS\_%' ESCAPE '\';

  -- V0001 representative mandatory objects.
  l_core :=
      object_valid('TPS_ENTITY','TABLE')
    * object_valid('TPS_RELATION','TABLE')
    * object_valid('TPS_D3KA_PKG','PACKAGE')
    * object_valid('TPS_D3KA_PKG','PACKAGE BODY')
    * object_valid('TPS_RIGHTS_PKG','PACKAGE')
    * object_valid('TPS_RIGHTS_PKG','PACKAGE BODY')
    * object_valid('TPS_SCHEDULE','TABLE')
    * object_valid('TPS_MEDIA_ASSET','TABLE');

  -- V0002 representative functional objects.
  l_v2 :=
      object_valid('TPS_PROGRAMMING_PKG','PACKAGE')
    * object_valid('TPS_PROGRAMMING_PKG','PACKAGE BODY')
    * object_valid('TPS_CONTINUITY_PKG','PACKAGE')
    * object_valid('TPS_CONTINUITY_PKG','PACKAGE BODY')
    * object_valid('TPS_AI_GUARD_PKG','PACKAGE')
    * object_valid('TPS_AI_GUARD_PKG','PACKAGE BODY')
    * object_valid('TPS_AI_PROGRAMMING_TOOL_PKG','PACKAGE')
    * object_valid('TPS_AI_PROGRAMMING_TOOL_PKG','PACKAGE BODY')
    * object_valid('TPS_CONTINUITY_DECISION','TABLE');

  -- V0003 representative rules/commercial objects.
  l_v3 :=
      object_valid('TPS_CONTENT_RATING','TABLE')
    * object_valid('TPS_PROGRAMMING_RULE_PROFILE','TABLE')
    * object_valid('TPS_PROGRAMMING_RULES_PKG','PACKAGE')
    * object_valid('TPS_PROGRAMMING_RULES_PKG','PACKAGE BODY')
    * object_valid('TPS_COMMERCIAL_PKG','PACKAGE')
    * object_valid('TPS_COMMERCIAL_PKG','PACKAGE BODY')
    * object_valid('TRG_TPS_SCHEDULE_POLICY_GUARD','TRIGGER');

  -- V0004 representative operational API objects.
  l_v4 :=
      object_valid('TPS_BROADCAST_ADMIN_PKG','PACKAGE')
    * object_valid('TPS_BROADCAST_ADMIN_PKG','PACKAGE BODY')
    * object_valid('TPS_RIGHTS_ADMIN_PKG','PACKAGE')
    * object_valid('TPS_RIGHTS_ADMIN_PKG','PACKAGE BODY')
    * object_valid('TPS_PLAYOUT_API_PKG','PACKAGE')
    * object_valid('TPS_PLAYOUT_API_PKG','PACKAGE BODY');

  SELECT COUNT(*) INTO l_invalid
    FROM user_objects
   WHERE object_name LIKE 'TPS\_%' ESCAPE '\'
     AND status <> 'VALID';

  SELECT COUNT(*) INTO l_errors
    FROM user_errors
   WHERE name LIKE 'TPS\_%' ESCAPE '\';

  IF l_total_tps=0 THEN
    l_next := 'EMPTY_SCHEMA_CANDIDATE_FOR_V0001';
  ELSIF l_core=0 THEN
    l_next := 'PARTIAL_OR_UNKNOWN_CORE_RECONCILIATION_REQUIRED';
  ELSIF l_v2=0 THEN
    l_next := 'V0002_CANDIDATE_AFTER_PRECHECK';
  ELSIF l_v3=0 THEN
    l_next := 'V0003_CANDIDATE_AFTER_PRECHECK';
  ELSIF l_v4=0 THEN
    l_next := 'V0004_CANDIDATE_AFTER_PRECHECK';
  ELSE
    l_next := 'V0001_TO_V0004_PRESENT_RUN_FULL_TESTS';
  END IF;

  DBMS_OUTPUT.PUT_LINE('============================================================');
  DBMS_OUTPUT.PUT_LINE('TPSDBCORE01_RUNTIME_STATE');
  DBMS_OUTPUT.PUT_LINE('DB_NAME='||SYS_CONTEXT('USERENV','DB_NAME'));
  DBMS_OUTPUT.PUT_LINE('CON_NAME='||SYS_CONTEXT('USERENV','CON_NAME'));
  DBMS_OUTPUT.PUT_LINE('CURRENT_USER='||SYS_CONTEXT('USERENV','CURRENT_USER'));
  DBMS_OUTPUT.PUT_LINE('SERVICE_NAME='||SYS_CONTEXT('USERENV','SERVICE_NAME'));
  DBMS_OUTPUT.PUT_LINE('TPS_OBJECT_COUNT='||l_total_tps);
  DBMS_OUTPUT.PUT_LINE('V0001_CORE_VALID='||l_core);
  DBMS_OUTPUT.PUT_LINE('V0002_VALID='||l_v2);
  DBMS_OUTPUT.PUT_LINE('V0003_VALID='||l_v3);
  DBMS_OUTPUT.PUT_LINE('V0004_VALID='||l_v4);
  DBMS_OUTPUT.PUT_LINE('INVALID_TPS_OBJECTS='||l_invalid);
  DBMS_OUTPUT.PUT_LINE('TPS_USER_ERRORS='||l_errors);
  DBMS_OUTPUT.PUT_LINE('NEXT_ACTION='||l_next);
  DBMS_OUTPUT.PUT_LINE('RUNTIME_STATE=PASS_READ_ONLY');
  DBMS_OUTPUT.PUT_LINE('============================================================');
END;
/

SELECT object_name, object_type, status
  FROM user_objects
 WHERE object_name LIKE 'TPS\_%' ESCAPE '\'
   AND status <> 'VALID'
 ORDER BY object_type, object_name;

SELECT name, type, line, position, text
  FROM user_errors
 WHERE name LIKE 'TPS\_%' ESCAPE '\'
 ORDER BY name, sequence;
