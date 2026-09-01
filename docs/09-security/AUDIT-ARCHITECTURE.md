# Audit Architecture

Use two complementary layers: native Oracle audit for database/security activity and TPS_AUDIT_EVENT/TPS_AI_DECISION for business/AI semantics.

Material audit fields include actor/role, action, object/entity/relation, before/after references when appropriate, request/correlation ID, policy result, source commit/change ID, UTC timestamp and outcome.

Audit records are append-oriented. Audit suppression by application roles is prohibited.
