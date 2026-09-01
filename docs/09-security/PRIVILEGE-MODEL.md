# Privilege Model

Owner/deployment identity owns schema objects but is not used by apps. Runtime/API/ingest/AI/analytics/auditor roles receive only required object/package privileges.

Protected mutations occur through validated packages/API rather than direct table DML where business invariants require enforcement.

Privilege-negative tests prove that each role cannot read/modify domains outside its contract. Graph privileges and package EXECUTE privileges are explicitly tested.
