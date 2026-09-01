# System Context Architecture

```text
Radio/TV Apps ─┐
Portals         ├─> TPS MEDIA API / controlled services ─> TPSDBCORE01
Automation      ┤                                      ├─ Relational kernel
Operations      ┘                                      ├─ D3KA/Property Graph
                                                       ├─ Vector/AI
Media ingest/metadata services -----------------------> ├─ Event/knowledge
                                                       └─ Audit/policy
External AI providers <---- controlled DB/service integration, credentials isolated
External media storage <--- asset identities/hashes/locations governed by DB
```

Direct browser-to-database access is prohibited. Operational media streaming is not forced through the database data plane.
