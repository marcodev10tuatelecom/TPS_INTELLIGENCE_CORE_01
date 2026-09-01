# Technology Decision Matrix

| Need | Primary Oracle technology | Why | Key risk/control |
|---|---|---|---|
| transactional truth | relational SQL | constraints/ACID/query maturity | normalize canonical facts |
| dynamic relationships | SQL Property Graph | native graph semantics over relational data | verify service capability/privileges |
| D3KA | relational relation kernel + property graph | sparse tensor without dense cube explosion | invariant/coverage tests |
| extensible attributes | JSON | controlled schema flexibility | do not hide canonical columns in JSON |
| application documents | JSON Relational Duality | same relational truth exposed as JSON | contract/version tests |
| semantic similarity | VECTOR / AI Vector Search | native vector storage/search | recall/perf/cost evaluation |
| keyword + semantic | Oracle Text/hybrid vector where justified | lexical + semantic retrieval | benchmark before adoption |
| geographic context | Spatial | native geometry/indexing | use only for real spatial requirements |
| deterministic decisions | PL/SQL + constraints/policies | predictable authority | unit/negative tests |
| predictive models | OML where supported | model close to governed data | capability and model governance |
| NL2SQL/RAG | Select AI | Oracle-integrated AI workflows | strict object/security scoping |
| agents | DBMS_CLOUD_AI_AGENT | tasks/tools/orchestration in ADB | AI not authority; tool allowlists |
| app interface | ORDS/API projections | decouple apps from physical schema | least privilege/versioning |
