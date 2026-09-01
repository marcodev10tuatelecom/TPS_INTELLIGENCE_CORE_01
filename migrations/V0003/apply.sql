/*=============================================================================
 V0003 APPLY MANIFEST — PRODUCTION MUTATION SOURCE

 DO NOT RUN WITHOUT APPROVED V0003 CHANGE GATE.
 Performs DDL plus governed reference-data MERGE.
 Oracle DDL has implicit commit semantics.
=============================================================================*/

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT === V0003 01/08 CONTENT RATING TABLE ===
@@../../src/12-media/1290_tps_content_rating.sql

PROMPT === V0003 02/08 PROGRAMMING RULE PROFILE ===
@@../../src/12-media/1291_tps_programming_rule_profile.sql

PROMPT === V0003 03/08 COMMERCIAL PACKAGE SPEC ===
@@../../src/13-commercial/1320_tps_commercial_pkg.pks

PROMPT === V0003 04/08 COMMERCIAL PACKAGE BODY ===
@@../../src/13-commercial/1321_tps_commercial_pkg.pkb

PROMPT === V0003 05/08 PROGRAMMING RULES SPEC ===
@@../../src/12-media/1292_tps_programming_rules_pkg.pks

PROMPT === V0003 06/08 PROGRAMMING RULES BODY ===
@@../../src/12-media/1293_tps_programming_rules_pkg.pkb

PROMPT === V0003 07/08 SCHEDULE POLICY GUARD TRIGGER ===
@@../../src/12-media/1294_tps_schedule_policy_guard_trg.sql

PROMPT === V0003 08/08 CONTENT RATING REFERENCE SEED ===
@@../../src/20-reference/2080_content_ratings_br.sql

PROMPT === V0003 APPLY SOURCE COMPLETED — RUN postcheck.sql ===
