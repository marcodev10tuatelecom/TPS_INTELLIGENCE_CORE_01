-- V0004 ROLLBACK
-- Safe only while no external consumer depends on these package contracts.
WHENEVER SQLERROR EXIT SQL.SQLCODE

DROP PACKAGE tps_playout_api_pkg;
DROP PACKAGE tps_rights_admin_pkg;
DROP PACKAGE tps_broadcast_admin_pkg;

PROMPT V0004_ROLLBACK=COMPLETE
