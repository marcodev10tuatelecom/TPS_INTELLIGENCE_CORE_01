# Recovery Test Plan

Exercises: rebuild empty compatible schema from tagged source; restore/import logical data subset; validate entity/relation counts/hashes; recreate property graph/views/packages/indexes; revalidate vectors or rebuild embeddings; verify migration ledger; run regression; measure RTO/RPO.

Production certification requires a successful isolated restore/rebuild, not merely the existence of backups.
