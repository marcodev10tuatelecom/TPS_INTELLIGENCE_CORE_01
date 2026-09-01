# SEC-003 — Protected Table Direct-DML Negative Test

For each application/runtime role, attempt the minimum harmless transaction-scoped DML needed to prove that protected tables such as `TPS_RELATION`, `TPS_RIGHT_GRANT`, `TPS_POLICY`, `TPS_RULE` and `TPS_AI_AGENT` are not directly mutable when the contract requires package/API mediation. Roll back immediately. Expected result is Oracle authorization denial. Evidence records user, enabled roles, SQLCODE and object; never credentials.
