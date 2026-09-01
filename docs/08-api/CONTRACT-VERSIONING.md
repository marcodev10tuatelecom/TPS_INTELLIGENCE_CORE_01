# API Contract Versioning

Breaking semantic changes require a new contract version or negotiated migration. Additive optional fields may remain within a compatible version when clients tolerate unknown fields.

Database object evolution is independent from API version. A physical schema migration must not force a client break when a compatibility projection can preserve the contract safely.
