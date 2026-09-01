-- V0002 ONE-PASS SOURCE DEPLOYMENT RUNNER
-- Production mutation. Does not run rollback-only functional test.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 V0002 PRECHECK
PROMPT ============================================================
@@precheck.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0002 APPLY
PROMPT ============================================================
@@apply.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0002 POSTCHECK
PROMPT ============================================================
@@postcheck.sql

PROMPT V0002_RUN=PASS
