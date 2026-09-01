-- V0002 FUNCTIONAL TEST RUNNER
-- Executes synthetic DML but rolls back its test rows.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@postcheck.sql
@@../../tests/programming/PRG-900_vertical_plsql_slice.sql

PROMPT V0002_TEST=PASS
