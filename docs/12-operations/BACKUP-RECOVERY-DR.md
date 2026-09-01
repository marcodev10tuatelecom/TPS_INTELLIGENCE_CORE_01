# Backup, Recovery and Disaster Recovery

A backup is not certified until a restore/rebuild drill succeeds.

Recovery layers: Oracle service backup capabilities, logical metadata/data export where applicable, repository source/migrations, external media storage recovery and immutable evidence.

RPO/RTO are defined by data class: canonical identity/configuration, schedules/rights, events/audit and derivable vectors have different criticality. Vector embeddings can be rebuilt if source/model/version are preserved; canonical business transactions cannot be treated as disposable.

Always Free service limitations are explicitly accounted for. Promotion/migration to paid is part of the capacity/DR roadmap, and full production certification requires a recovery mechanism that meets approved RPO/RTO.
