# Physical Oracle Architecture

Target is Oracle AI Database 26ai Autonomous AI Transaction Processing, database TPSDBCORE01.

Physical design principles:
- relational tables own authoritative state;
- native JSON for controlled extensible attributes;
- SQL Property Graph over entity/relation tables;
- native VECTOR in separate multi-vector tables;
- JSON Relational Duality for selected application projections;
- PL/SQL packages for deterministic invariant/policy operations;
- native indexes chosen from measured workload;
- unified audit/security controls where supported;
- ORDS/API schema separated from owner/deployment authority.

No assumption that a feature is available merely because 26ai documents it; CORE-01 capability tests prove availability/privileges in the actual Autonomous service.
