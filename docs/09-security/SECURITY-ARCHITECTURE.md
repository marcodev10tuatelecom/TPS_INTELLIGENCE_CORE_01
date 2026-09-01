# Security Architecture

Principles: least privilege, separation of duties, explicit trust boundaries, encrypted transport, secret isolation, deny-by-default for protected actions, auditable privilege use and AI authority isolation.

Logical roles: TPS_MEDIA_OWNER (deployment only), TPS_MEDIA_RUNTIME, TPS_MEDIA_API, TPS_MEDIA_INGEST, TPS_MEDIA_AI, TPS_MEDIA_ANALYTICS, TPS_MEDIA_AUDITOR, TPS_MEDIA_ADMIN. Exact grants are derived from capability tests and source objects, never `GRANT DBA` to applications.

Graph access is treated as object access; vector/AI retrieval must honor the same underlying security context. Agent tools have dedicated least-privilege execution paths.
