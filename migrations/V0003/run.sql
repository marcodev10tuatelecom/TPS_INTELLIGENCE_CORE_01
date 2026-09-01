-- V0003 ONE-PASS SOURCE DEPLOYMENT RUNNER
-- Production mutation. Does not run rollback-only functional test.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 V0003 PRECHECK
PROMPT ============================================================
@@precheck.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0003 APPLY
PROMPT ============================================================
@@apply.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0003 POSTCHECK
PROMPT ============================================================
@@postcheck.sql

PROMPT V0003_RUN=PASS
