# Authority Model

## Authorities
1. Business authority defines business truth and operational policy.
2. Database architecture authority defines canonical data semantics.
3. Security authority defines access and protection controls.
4. Production change authority approves mutation of TPSDBCORE01.
5. AI is advisory unless a deterministic policy explicitly delegates a bounded action.

## Data authority classes
- `ORACLE_AUTHORITY`: canonical business/system-of-record state.
- `APPLICATION_DERIVED`: recomputable projection/cache.
- `CLIENT_PREFERENCE`: user-owned preference not corporate truth unless promoted by workflow.
- `CLIENT_EPHEMERAL`: transient UI/session state.

## Conflict rule
When two systems disagree, the authority registry determines which source may update the canonical fact. The losing source is not silently merged; conflict/provenance is recorded.
