# Database Release Management

A release groups approved immutable migrations and compatible documentation/tests. A release tag records commit, migration set, Oracle compatibility evidence, known risks and certification status.

Release stages: DESIGN -> STATIC_VALIDATED -> CAPABILITY_VALIDATED -> CHANGE_APPROVED -> DEPLOYED -> POSTCHECK_PASS -> CERTIFIED. `DEPLOYED` is not synonymous with `CERTIFIED`.
