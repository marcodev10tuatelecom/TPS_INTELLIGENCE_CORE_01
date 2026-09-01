-- V0004 APPLY
-- Execute only after precheck PASS and explicit production change approval.
WHENEVER SQLERROR EXIT SQL.SQLCODE

@@../../src/12-media/1295_tps_broadcast_admin_pkg.pks
@@../../src/12-media/1296_tps_broadcast_admin_pkg.pkb
@@../../src/14-rights/1430_tps_rights_admin_pkg.pks
@@../../src/14-rights/1431_tps_rights_admin_pkg.pkb
@@../../src/17-api/1730_tps_playout_api_pkg.pks
@@../../src/17-api/1731_tps_playout_api_pkg.pkb

PROMPT V0004_APPLY=COMPLETE_SOURCE_EXECUTION
