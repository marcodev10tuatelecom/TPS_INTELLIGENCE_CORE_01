-- V0004 ONE-PASS SOURCE DEPLOYMENT RUNNER
-- Production mutation: creates/replaces PL/SQL packages.
-- Does NOT run the rollback-only functional test.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 V0004 PRECHECK
PROMPT ============================================================
@@precheck.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0004 APPLY
PROMPT ============================================================
@@apply.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0004 POSTCHECK
PROMPT ============================================================
@@postcheck.sql

PROMPT V0004_RUN=PASS
