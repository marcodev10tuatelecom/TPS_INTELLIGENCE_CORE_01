/*=============================================================================
 V0002 APPLY MANIFEST — PRODUCTION MUTATION SOURCE

 DO NOT RUN WITHOUT APPROVED V0002 CHANGE GATE.
 This script intentionally performs DDL and one governed reference-data MERGE.
 It does not COMMIT explicitly; note that Oracle DDL itself has implicit commit semantics.
=============================================================================*/

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT === V0002 01/12 AI AGENT TOOL AUTHORIZATION TABLE ===
@@../../src/11-ai/1190_tps_ai_agent_tool.sql

PROMPT === V0002 02/12 AI GUARD SPEC ===
@@../../src/11-ai/1191_tps_ai_guard_pkg.pks

PROMPT === V0002 03/12 AI GUARD BODY ===
@@../../src/11-ai/1192_tps_ai_guard_pkg.pkb

PROMPT === V0002 04/12 PROGRAMMING SPEC ===
@@../../src/12-media/1260_tps_programming_pkg.pks

PROMPT === V0002 05/12 PROGRAMMING BODY ===
@@../../src/12-media/1261_tps_programming_pkg.pkb

PROMPT === V0002 06/12 CONTINUITY DECISION LEDGER ===
@@../../src/12-media/1270_tps_continuity_decision.sql

PROMPT === V0002 07/12 CONTINUITY LEDGER IMMUTABILITY TRIGGER ===
@@../../src/12-media/1271_tps_continuity_decision_immutable_trg.sql

PROMPT === V0002 08/12 CONTINUITY SPEC ===
@@../../src/12-media/1280_tps_continuity_pkg.pks

PROMPT === V0002 09/12 CONTINUITY BODY ===
@@../../src/12-media/1281_tps_continuity_pkg.pkb

PROMPT === V0002 10/12 AI PROGRAMMING TOOL SPEC ===
@@../../src/11-ai/1193_tps_ai_programming_tool_pkg.pks

PROMPT === V0002 11/12 AI PROGRAMMING TOOL BODY ===
@@../../src/11-ai/1194_tps_ai_programming_tool_pkg.pkb

PROMPT === V0002 12/12 CANONICAL AI TOOL REFERENCE ===
@@../../src/20-reference/2070_ai_tools.sql

PROMPT === V0002 APPLY SOURCE COMPLETED — RUN postcheck.sql ===
