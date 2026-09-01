-- TPSDBCORE01 FULL FUNCTIONAL VALIDATION
-- Requires V0001..V0004 installed/compiled.
-- Functional test scripts use SAVEPOINT/ROLLBACK for synthetic rows.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL TEST — KERNEL
PROMPT ============================================================
@@../../tests/compile/COMP-000_kernel.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL TEST — V0002
PROMPT ============================================================
@@../V0002/test.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL TEST — V0003
PROMPT ============================================================
@@../V0003/test.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL TEST — V0004
PROMPT ============================================================
@@../V0004/test.sql

PROMPT TPS_FULL_TEST=PASS
