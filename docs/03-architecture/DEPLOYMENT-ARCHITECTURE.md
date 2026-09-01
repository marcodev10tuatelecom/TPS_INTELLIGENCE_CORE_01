# Deployment Architecture

Production source flows Git commit -> review/change record -> precheck -> deployment authority -> versioned migration -> post-check -> evidence -> gate decision.

Deployment never reads credentials from committed files. Wallet/secret references are provided by approved secret mechanisms outside Git.

The live database is currently Always Free. Capacity promotion or migration to paid remains compatible at the logical architecture level but requires recertification of service-specific capabilities, network, backup/restore, performance and cost.
