-- REG-001 | MUTATING TEST SUITE | APPROVED ISOLATED TEST SESSION ONLY
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
@@../fixtures/000_fixture_begin.sql
@@../unit/UT-001_entity_constraints.sql
@@../unit/UT-002_relation_constraints.sql
@@../D3KA/D3KA-001_assert_relation.sql
@@../D3KA/D3KA-002_reject_self.sql
@@../D3KA/D3KA-003_require_context.sql
@@../D3KA/D3KA-004_require_provenance.sql
@@../D3KA/D3KA-005_duplicate_active.sql
@@../D3KA/D3KA-010_invariants.sql
@@../graph/G-001_graph_smoke.sql
@@../vector/V-001_vector_distance.sql
@@../AI/AI-001_authority_classes.sql
@@../AI/AI-002_inference_verification.sql
@@../fixtures/999_fixture_rollback.sql
PROMPT REG-001 PASS if no SQLERROR occurred.
