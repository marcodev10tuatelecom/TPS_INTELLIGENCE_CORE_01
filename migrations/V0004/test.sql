-- V0004 FUNCTIONAL TEST RUNNER
-- Executes rollback-only synthetic integration test.
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON

@@postcheck.sql
@@../../tests/integration/INT-010_broadcast_end_to_end.sql

PROMPT V0004_TEST=PASS
