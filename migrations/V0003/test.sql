-- V0003 FUNCTIONAL TEST RUNNER
-- Executes synthetic DML but rolls back its test rows.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@postcheck.sql
@@../../tests/programming/PRG-910_rules_engine.sql

PROMPT V0003_TEST=PASS
