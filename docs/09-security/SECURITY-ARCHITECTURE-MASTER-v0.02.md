# SECURITY ARCHITECTURE MASTER v0.02

## 1. Scope

Security architecture for the production TPSDBCORE01 Oracle AI Database 26ai and every schema object, API projection, AI capability and migration defined by this repository.

## 2. Security objectives

- preserve confidentiality, integrity and availability;
- prevent application-level DBA access;
- isolate human administration from runtime service identities;
- preserve provenance and auditability;
- enforce least privilege;
- prevent AI/tool privilege escalation;
- protect rights, commercial, audience and identity data;
- make every production mutation attributable and reviewable.

## 3. Identity classes

Human:
- break-glass database administrator;
- database engineer/migration operator;
- security auditor;
- read-only support/analyst where approved.

Service:
- TPS_MEDIA_API
- TPS_MEDIA_RUNTIME
- TPS_MEDIA_INGEST
- TPS_MEDIA_AI
- TPS_MEDIA_ANALYTICS
- TPS_MEDIA_AUDITOR

No service identity uses the owner/DBA credential.

## 4. Privilege architecture

Privileges are granted through roles wherever possible. Direct grants are exceptional and documented. Runtime roles receive object-level privileges only on required packages/views/tables. DDL belongs to controlled migration identity. AI receives curated views/packages/tools, not unrestricted SQL execution.

## 5. Data classification

Classes:
- PUBLIC
- INTERNAL
- CONFIDENTIAL
- RESTRICTED
- SECRET_REFERENCE_ONLY

Credentials, private keys, wallets, access tokens and secret values are SECRET_REFERENCE_ONLY and never committed to this repository or persisted into general AI context.

## 6. D3KA security

Graph traversal can expose relationships that individual rows do not obviously reveal. Therefore security review applies to:
- vertex visibility;
- edge visibility;
- graph property exposure;
- inference through path existence;
- context and temporal filters;
- cross-domain/tenant traversal;
- aggregate re-identification.

Security-sensitive projections must be separated from unrestricted owner views.

## 7. Vector security

Embeddings may encode information from sensitive source content. Vector storage inherits at least the classification of its source unless a formal declassification assessment proves otherwise. Semantic search must respect authorization before ranking/returning results.

## 8. AI security boundary

AI agents have explicit tool allowlists. Tool calls are checked by deterministic authorization. Models receive minimum necessary context. Prompt injection, indirect injection, data exfiltration and tool misuse are mandatory adversarial tests.

## 9. Network and transport

Current production connectivity requires TCPS/mTLS as discovered. Network ACL/private endpoint decisions are controlled infrastructure changes, not assumptions. All application traffic uses encrypted transport and credential/wallet material is managed outside source control.

## 10. Audit

Audit scope includes:
- privileged login/use;
- schema changes;
- role/grant changes;
- policy changes;
- sensitive data access where required;
- AI profile/agent changes;
- scheduler/job changes;
- API security changes;
- production migration execution;
- break-glass activity.

AI operational decisions are also logged in TPS_AI_DECISION or equivalent decision ledger.

## 11. Negative tests

At minimum prove:
- API role cannot create/alter/drop objects;
- AI role cannot bypass policy engine;
- analytics role cannot mutate canonical business state;
- unauthorised graph traversal is blocked;
- unauthorized vector retrieval is blocked;
- hidden/restricted contexts are excluded;
- retired/retracted knowledge is not exposed as current fact;
- secret values are absent from repository and evidence bundles.

## 12. Change control

Security changes are production changes. Every grant/revoke/audit-policy/network-control source must carry precheck, expected diff, rollback, post-check and evidence requirements.

## 13. Certification

CORE-18 PASS requires privilege matrix, negative tests, audit proof, secret scan, AI authorization tests, graph/vector exposure tests, network/TLS evidence and unresolved-risk review.