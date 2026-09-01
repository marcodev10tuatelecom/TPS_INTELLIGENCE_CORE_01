/*=============================================================================
 @file              tests/compile/COMP-001_programming_continuity.sql
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION — READ-ONLY COMPILE/DICTIONARY TEST
 @purpose           Fail unless the new programming/AI/continuity objects exist VALID and
                    USER_ERRORS contains no compiler errors for them.
 @writes            NONE.
 @expected          Anonymous block prints COMP-001=PASS.
=============================================================================*/

SET SERVEROUTPUT ON

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'TPS_PROGRAMMING_PKG',
    'TPS_CONTINUITY_DECISION',
    'TRG_TPS_CONT_DECISION_IMMUTABLE',
    'TPS_CONTINUITY_PKG',
    'TPS_AI_AGENT_TOOL',
    'TPS_AI_GUARD_PKG',
    'TPS_AI_PROGRAMMING_TOOL_PKG'
)
ORDER BY object_name, object_type;

SELECT name, type, line, position, text
FROM user_errors
WHERE name IN (
    'TPS_PROGRAMMING_PKG',
    'TRG_TPS_CONT_DECISION_IMMUTABLE',
    'TPS_CONTINUITY_PKG',
    'TPS_AI_GUARD_PKG',
    'TPS_AI_PROGRAMMING_TOOL_PKG'
)
ORDER BY name, sequence;

DECLARE
    l_invalid NUMBER;
    l_errors  NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO l_invalid
      FROM user_objects
     WHERE object_name IN (
        'TPS_PROGRAMMING_PKG',
        'TPS_CONTINUITY_DECISION',
        'TRG_TPS_CONT_DECISION_IMMUTABLE',
        'TPS_CONTINUITY_PKG',
        'TPS_AI_AGENT_TOOL',
        'TPS_AI_GUARD_PKG',
        'TPS_AI_PROGRAMMING_TOOL_PKG'
     )
       AND status <> 'VALID';

    SELECT COUNT(*)
      INTO l_errors
      FROM user_errors
     WHERE name IN (
        'TPS_PROGRAMMING_PKG',
        'TRG_TPS_CONT_DECISION_IMMUTABLE',
        'TPS_CONTINUITY_PKG',
        'TPS_AI_GUARD_PKG',
        'TPS_AI_PROGRAMMING_TOOL_PKG'
     );

    IF l_invalid > 0 OR l_errors > 0 THEN
        RAISE_APPLICATION_ERROR(-20980, 'COMP-001=FAIL INVALID=' || l_invalid || ' ERRORS=' || l_errors);
    END IF;

    DBMS_OUTPUT.PUT_LINE('COMP-001=PASS');
END;
/
