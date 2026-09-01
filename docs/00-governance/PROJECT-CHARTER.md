# Project Charter — TPS_INTELLIGENCE_CORE_01

## Mission
Design, build, validate and operate TPSDBCORE01 as the production Oracle AI Database 26ai intelligence core for all Tech Pro Solutions media operations.

## Scope
Corporate identity, radio/TV topology, programming, content, media assets, advertising, rights, audience, editorial data, operational references, D3KA/property graph, vector semantics, knowledge assertions, policies, audit, API projections, AI/ML/RAG/agents, performance, security and recovery.

## Out of scope
Raw long-form media bytes are not required to reside in the database; the database governs their identity, hashes, metadata, lineage, storage location, rights and semantic representations. Application UI code is outside this repository.

## Success criteria
- >=90% canonical logical fact-class coverage by D3KA representation.
- no duplicate source of truth for identities.
- protected actions cannot be authorized solely by AI.
- complete provenance for imported/inferred material facts.
- performance, security and recovery gates evidenced.
- application access through controlled API/read models rather than unrestricted database access.

## Production status
The live Oracle instance is production. Repository source is engineering authority but requires explicit production change approval before execution.
