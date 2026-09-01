/* TPSDBCORE01 — COMPILE GATE COMP-002 — READ ONLY */
SET SERVEROUTPUT ON

DECLARE
    l_invalid NUMBER;
    l_errors  NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_invalid
      FROM user_objects
     WHERE object_name IN (
         'TPS_CONTENT_RATING',
         'TPS_PROGRAMMING_RULE_PROFILE',
         'TPS_PROGRAMMING_RULES_PKG',
         'TRG_TPS_SCHEDULE_POLICY_GUARD',
         'TPS_COMMERCIAL_PKG'
     )
       AND status <> 'VALID';

    SELECT COUNT(*)
      INTO l_errors
      FROM user_errors
     WHERE name IN (
         'TPS_PROGRAMMING_RULES_PKG',
         'TRG_TPS_SCHEDULE_POLICY_GUARD',
         'TPS_COMMERCIAL_PKG'
     );

    IF l_invalid <> 0 OR l_errors <> 0 THEN
        DBMS_OUTPUT.PUT_LINE('COMP-002=FAIL INVALID=' || l_invalid || ' ERRORS=' || l_errors);
        FOR r IN (
            SELECT name, type, line, position, text
              FROM user_errors
             WHERE name IN (
                 'TPS_PROGRAMMING_RULES_PKG',
                 'TRG_TPS_SCHEDULE_POLICY_GUARD',
                 'TPS_COMMERCIAL_PKG'
             )
             ORDER BY name, sequence
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.name || '|' || r.type || '|L' || r.line || ':C' || r.position || '|' || r.text);
        END LOOP;
        RAISE_APPLICATION_ERROR(-20982,'COMP-002_COMPILE_GATE_FAILED');
    END IF;

    DBMS_OUTPUT.PUT_LINE('COMP-002=PASS');
END;
/
