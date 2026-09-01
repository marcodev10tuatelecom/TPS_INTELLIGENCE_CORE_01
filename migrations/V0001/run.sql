-- V0001 ONE-PASS BOOTSTRAP RUNNER
-- Production mutation after read-only precheck PASS.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 V0001 PRECHECK
PROMPT ============================================================
@@precheck.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0001 APPLY
PROMPT ============================================================
@@apply.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 V0001 POSTCHECK
PROMPT ============================================================
@@postcheck.sql

PROMPT V0001_RUN=PASS
