# Contributing

Every database change preserves traceability: requirement -> architecture/ADR -> source -> migration -> tests -> evidence -> CORE gate.

Requirements:
- no credentials/secrets;
- no ad-hoc production SQL;
- source headers identify TPSDBCORE01, CORE area and mutability class;
- migrations are immutable after deployment;
- new D3KA fact classes update the coverage registry;
- AI changes update model/agent governance and safety tests;
- protected actions remain behind deterministic policy;
- no gate PASS without retained evidence.
