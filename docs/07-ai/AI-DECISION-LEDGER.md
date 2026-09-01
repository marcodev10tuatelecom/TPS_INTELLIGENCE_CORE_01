# AI Decision Ledger v0.01

TPS_AI_DECISION records material AI involvement without storing unnecessary raw secrets or private provider payloads.

Required semantics: request/correlation ID, agent/model/profile versions, context, evidence references, output, confidence/uncertainty, policy result, final action, human override and time.

Not every autocomplete or low-value inference must create a heavy audit record; materiality policy defines retention. Protected decisions always retain sufficient evidence to reconstruct why AI contributed and why deterministic policy allowed/denied the outcome.
