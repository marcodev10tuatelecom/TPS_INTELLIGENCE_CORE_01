-- REC-002 | migration ledger integrity | R0
SELECT migration_id,release_version,git_commit_sha,source_sha256,change_id,reversibility_class,status
FROM tps_schema_migration
ORDER BY started_at,migration_id;
