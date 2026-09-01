-- V0004 POSTCHECK — READ ONLY
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@../../tests/compile/COMP-003_broadcast_admin_playout.sql

SELECT object_name, object_type, status
  FROM user_objects
 WHERE object_name IN ('TPS_BROADCAST_ADMIN_PKG','TPS_RIGHTS_ADMIN_PKG','TPS_PLAYOUT_API_PKG')
 ORDER BY object_name, object_type;

SELECT name, type, line, position, text
  FROM user_errors
 WHERE name IN ('TPS_BROADCAST_ADMIN_PKG','TPS_RIGHTS_ADMIN_PKG','TPS_PLAYOUT_API_PKG')
 ORDER BY name, sequence;

PROMPT V0004_POSTCHECK=COMPLETE
