# API Error Model v0.01

Canonical categories:
- `TPS-VALIDATION-*` invalid input/schema;
- `TPS-NOTFOUND-*` canonical object absent/not visible;
- `TPS-CONFLICT-*` version/cardinality/state conflict;
- `TPS-POLICY-DENIED-*` deterministic business denial;
- `TPS-RIGHTS-DENIED-*` rights denial;
- `TPS-AUTH-*` authentication/authorization;
- `TPS-RATE-*` bounded service/rate limit;
- `TPS-AI-UNAVAILABLE-*` model/provider unavailable;
- `TPS-AI-INSUFFICIENT-EVIDENCE-*` grounding insufficient;
- `TPS-INTERNAL-*` unexpected internal failure with correlation ID.

Never expose stack traces, SQL text containing sensitive values, credentials or internal privilege details to public clients.
