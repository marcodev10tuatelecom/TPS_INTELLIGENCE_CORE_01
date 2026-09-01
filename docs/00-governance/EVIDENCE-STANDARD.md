# Evidence Standard

Every certification artifact must be attributable and tamper-evident.

Minimum metadata: evidence ID, gate, test/change ID, source commit, database/service identity, UTC timestamps, command/query/script checksum, result, PASS/FAIL, operator, reviewer and artifact SHA-256 where exportable.

Secrets, wallets, private keys and raw credentials are forbidden in Git. Evidence must redact secrets while preserving diagnostic value.

A PASS without retained proof is treated as NOT PROVEN.
