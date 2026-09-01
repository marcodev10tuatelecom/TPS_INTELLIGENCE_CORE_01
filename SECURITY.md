# TPS_INTELLIGENCE_CORE_01 Security Policy

TPSDBCORE01 is production. Never commit database passwords, Oracle wallet contents, private keys, OCI authentication private keys, external AI-provider credentials or access tokens.

Applications must not use ADMIN/owner credentials. Suspected credential exposure is a security incident requiring credential rotation/revocation through the owning platform and controlled repository-history remediation.

Source code in this repository is not automatically authorized for execution on production. See `docs/12-operations/PRODUCTION-CHANGE-CONTROL.md`.
