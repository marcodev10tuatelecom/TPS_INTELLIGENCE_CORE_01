-- TPSDBCORE01 FULL BUILD FROM EMPTY COMPATIBLE SCHEMA
-- PRODUCTION MUTATION. V0001 precheck fails closed if canonical core already exists.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL BUILD — V0001
PROMPT ============================================================
@@../V0001/run.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL BUILD — V0002
PROMPT ============================================================
@@../V0002/run.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL BUILD — V0003
PROMPT ============================================================
@@../V0003/run.sql

PROMPT ============================================================
PROMPT TPSDBCORE01 FULL BUILD — V0004
PROMPT ============================================================
@@../V0004/run.sql

PROMPT TPS_FULL_BUILD=PASS
