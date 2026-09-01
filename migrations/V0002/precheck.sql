/* V0002 PRECHECK — READ ONLY. No schema/data mutation. */
SET SERVEROUTPUT ON

DECLARE
    l_missing NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_missing
      FROM (
        SELECT 'TPS_ENTITY' name, 'TABLE' type FROM dual UNION ALL
        SELECT 'TPS_RELATION_TYPE','TABLE' FROM dual UNION ALL
        SELECT 'TPS_RELATION','TABLE' FROM dual UNION ALL
        SELECT 'TPS_SCHEDULE','TABLE' FROM dual UNION ALL
        SELECT 'TPS_SCHEDULE_ITEM','TABLE' FROM dual UNION ALL
        SELECT 'TPS_MEDIA_ASSET','TABLE' FROM dual UNION ALL
        SELECT 'TPS_RIGHT_GRANT','TABLE' FROM dual UNION ALL
        SELECT 'TPS_RIGHTS_PKG','PACKAGE' FROM dual UNION ALL
        SELECT 'TPS_AI_MODEL','TABLE' FROM dual UNION ALL
        SELECT 'TPS_AI_AGENT','TABLE' FROM dual UNION ALL
        SELECT 'TPS_AI_TOOL','TABLE' FROM dual UNION ALL
        SELECT 'TPS_AI_DECISION','TABLE' FROM dual
      ) req
     WHERE NOT EXISTS (
        SELECT 1
          FROM user_objects o
         WHERE o.object_name = req.name
           AND o.object_type = req.type
           AND o.status = 'VALID'
     );

    IF l_missing > 0 THEN
        RAISE_APPLICATION_ERROR(-20970, 'V0002_PRECHECK=FAIL MISSING_OR_INVALID=' || l_missing);
    END IF;

    DBMS_OUTPUT.PUT_LINE('V0002_PRECHECK=PASS');
END;
/
