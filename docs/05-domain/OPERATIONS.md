# Operations Knowledge Domain

The database may represent infrastructure/service identities, delivery endpoints, incidents, health observations and operational events without becoming the streaming data plane.

Entities: SERVICE, SYSTEM, ENDPOINT, HOST_REFERENCE, INCIDENT, STREAM/FEED identity. Events include STREAM_FAILED, SERVICE_DEGRADED, FAILOVER_STARTED, FAILOVER_COMPLETED and RECOVERY_VERIFIED.

Secrets and full sensitive runtime configurations do not belong in the knowledge graph. Store references/fingerprints/approved metadata only.
