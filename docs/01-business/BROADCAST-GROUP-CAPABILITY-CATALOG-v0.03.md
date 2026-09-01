# TPS_INTELLIGENCE_CORE_01 — BROADCAST GROUP CAPABILITY CATALOG v0.03

## 1. Purpose

This catalog defines the business functionality that the database/AI core must support for a group of radio and television broadcasters. It prevents the physical database from driving the business model backward: tables/packages exist to implement these capabilities, not the other way around.

Status values:

- `MODELED` — data/source architecture exists.
- `PLSQL_SOURCE` — executable PL/SQL source exists in Git.
- `PARTIAL` — some capability exists but mandatory rules remain.
- `PLANNED` — documented requirement, implementation not yet complete.
- `RUNTIME_NOT_PROVEN` — source exists but production execution/compile not evidenced.

## 2. Corporate/network topology

| Capability | Required behavior | Current implementation | State |
|---|---|---|---|
| Organization identity | one canonical company/legal/brand identity | TPS_ENTITY/D3KA | MODELED |
| Broadcast network | represent parent network without duplicate station identities | TPS_ENTITY + D3KA relations | MODELED |
| Radio/TV station | canonical station identity and operational metadata | TPS_STATION + entity | MODELED |
| Channel | logical channel belonging to station/network | TPS_CHANNEL + D3KA | MODELED |
| Affiliate | station linked to network with temporal/contextual relationship | D3KA `AFFILIATED_WITH` | PARTIAL |
| Repeater | station/repeater inheriting parent programming | D3KA `REPEATS` | PARTIAL |
| Multiple affiliations | an entity may have multiple relationships with explicit precedence/context | D3KA supports it; explicit network precedence still required | PARTIAL |
| Regional/local identity | region/context qualification without cloning master identity | TPS_CONTEXT + D3KA | MODELED |

## 3. Programming and scheduling

| Capability | Required behavior | Source | State |
|---|---|---|---|
| Create schedule | create controlled DRAFT schedule | TPS_PROGRAMMING_PKG | PLSQL_SOURCE/RUNTIME_NOT_PROVEN |
| Add content to schedule | validate time, overlap, asset and rights | ADD_SCHEDULE_ITEM | PLSQL_SOURCE/RUNTIME_NOT_PROVEN |
| Prevent overlap | fail closed, concurrency-safe edit serialization | schedule row `FOR UPDATE` + overlap query | PLSQL_SOURCE |
| Approve schedule | full validation before DRAFT -> APPROVED | programming package + policy guard | PLSQL_SOURCE |
| Activate schedule | reject competing active windows | programming package | PLSQL_SOURCE |
| Current item | return first current playable content by precedence | CURRENT_ITEM | PLSQL_SOURCE |
| Next item | return next playable content | NEXT_ITEM | PLSQL_SOURCE |
| Repeat control | configurable per-owner no-repeat window | programming rule profile/package | PLSQL_SOURCE |
| Content rating | enforce maximum/minimum-age policy | content rating + rule package | PLSQL_SOURCE; regulatory review pending |
| Duration fit | compare scheduled duration and active asset duration | rule package/profile tolerance | PLSQL_SOURCE |
| Local vs network share | e.g. 70% network / 30% local over defined period | requirement recognized; quota engine not built | PLANNED |
| Local override windows | override network schedule for local programming | schedule class/context model | PARTIAL |
| Timezone/DST | correct local schedule semantics across regions | timezone field exists; full DST suite not complete | PARTIAL |
| Episode/track rotation | repeat rules by episode/track/artist/category | generic repeat window exists; richer rotation rules pending | PARTIAL |

## 4. Continuity and 24x7 playout authority

| Capability | Required behavior | Source | State |
|---|---|---|---|
| Detect primary unavailable input | consume external source-health signal | input flag exists; persistent source-health registry pending | PARTIAL |
| Skip failed LIVE source | do not select unavailable local LIVE | TPS_CONTINUITY_PKG | PLSQL_SOURCE |
| Local emergency | prefer defined emergency schedule | continuity package | PLSQL_SOURCE |
| Local fallback | use local fallback schedule | continuity package | PLSQL_SOURCE |
| Network inheritance | resolve parent through REPEATS/AFFILIATED_WITH | D3KA + continuity package | PLSQL_SOURCE |
| Network fallback | fall back to network schedule/fallback | continuity package | PLSQL_SOURCE |
| Fail closed | return NO_PLAYABLE_ITEM rather than invent content | continuity package | PLSQL_SOURCE |
| Decision evidence | append resolution result with reason | TPS_CONTINUITY_DECISION | PLSQL_SOURCE |
| Evidence immutability | prevent UPDATE/DELETE of continuity decision | trigger | PLSQL_SOURCE |
| Multi-network precedence | explicit deterministic network priority rules | current relation ordering only | PARTIAL |
| Live-source telemetry integration | MediaMTX/encoder/health events feed continuity | event/source-health integration not built | PLANNED |

## 5. Media library

| Capability | Required behavior | Source/state |
|---|---|---|
| Canonical content identity | content represented as TPS_ENTITY | MODELED |
| Physical asset | hash, location, codecs, duration, lifecycle | TPS_MEDIA_ASSET — MODELED |
| Multiple renditions | master/proxy/transcode/audio/video/subtitle relationships | D3KA relation vocabulary; richer rendition table still planned |
| Asset availability before scheduling | non-LIVE requires active media asset | TPS_PROGRAMMING_PKG — PLSQL_SOURCE |
| Asset duration validation | compare asset vs slot within tolerance | TPS_PROGRAMMING_RULES_PKG — PLSQL_SOURCE |
| Semantic similarity | VECTOR embeddings/search | vector sources — runtime not proven |
| Media lineage | MASTER_OF/PROXY_OF/TRANSCODED_FROM/etc. | D3KA vocabulary — PARTIAL |

## 6. Rights/licensing

| Capability | Required behavior | Source/state |
|---|---|---|
| Rights grant | content + beneficiary + action + validity + evidence | TPS_RIGHT_GRANT — MODELED |
| Explicit deny | DENY must override ALLOW | TPS_RIGHTS_PKG — PLSQL_SOURCE |
| Unknown fail closed | no positive grant != permission | TPS_RIGHTS_PKG — PLSQL_SOURCE |
| Schedule rights check | programming calls rights at slot time | PLSQL_SOURCE |
| Commercial creative rights | commercial authorization calls rights | PLSQL_SOURCE |
| Territory | geographic rights scope | columns exist; evaluator incomplete — PARTIAL |
| Context | platform/station/device/event context rights | columns exist; evaluator incomplete — PARTIAL |
| Contract/evidence trace | source/provenance references | modeled; domain expansion required |

## 7. Advertising/commercial

| Capability | Required behavior | Source/state |
|---|---|---|
| Advertiser/campaign identity | campaign linked to advertiser/contract entities | TPS_CAMPAIGN — MODELED |
| Campaign validity | placement must lie inside active campaign | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Creative asset available | active media asset required | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Creative rights | broadcast rights must ALLOW | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Frequency cap | campaign max count/window | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Placement authorization | PLANNED -> AUTHORIZED/REJECTED | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Played confirmation | AUTHORIZED -> PLAYED linked to event | TPS_COMMERCIAL_PKG — PLSQL_SOURCE |
| Max ad load/hour | rolling-hour seconds per broadcaster | programming rules — PLSQL_SOURCE |
| Authorized placement in schedule | commercial item requires placement when configured | programming rules — PLSQL_SOURCE |
| Competitor/category conflict | prevent conflicting advertisers within configured separation | not built | PLANNED |
| Inventory/pricing/billing | sellable inventory, rate card, invoice integration | not complete | PLANNED |
| Regional advertising | affiliate/local ad windows and territory targeting | context model only | PARTIAL |

## 8. Audience

| Capability | Required behavior | Current state |
|---|---|---|
| Audience segment | canonical audience groups | TPS_AUDIENCE_SEGMENT — MODELED |
| Audience observation | aggregate observations/events | TPS_AUDIENCE_OBSERVATION — MODELED |
| Affinity/recommendation | vector/graph relationships to content | architecture exists; full domain source pending |
| Privacy classification | personal/raw telemetry governed separately | documented security requirement; runtime design incomplete |
| Regional audience | context/territory segmentation | context/D3KA architecture | PARTIAL |

## 9. Editorial/journalism

| Capability | Required behavior | Current state |
|---|---|---|
| Editorial item | news/report/interview/podcast metadata | TPS_EDITORIAL_ITEM — MODELED |
| Sources/provenance | every important claim traceable | TPS_SOURCE/TPS_ASSERTION — MODELED |
| Verification state | unverified/verified/disputed/rejected | assertions — MODELED |
| AI-assisted drafting/research | RAG/AI uses evidence, never invents authority | architecture/source partial |
| Editorial approval workflow | human/editor role, release lifecycle | not complete | PLANNED |
| Correction/retraction | preserve history/provenance | temporal/assertion model supports; workflow incomplete |

## 10. AI and automation

| Capability | Required behavior | Source/state |
|---|---|---|
| AI model registry | provider/model/version/risk metadata | TPS_AI_MODEL — MODELED |
| Agent registry | purpose/state/authority metadata | TPS_AI_AGENT — MODELED |
| Tool registry | tool identity/configuration | TPS_AI_TOOL — MODELED |
| Decision ledger | record AI input/output/policy/final action | TPS_AI_DECISION — MODELED |
| Tool permission | temporal agent/tool grant | TPS_AI_AGENT_TOOL — PLSQL_SOURCE |
| Read-only agent | ANALYTICS_ONLY may read only | TPS_AI_GUARD_PKG — PLSQL_SOURCE |
| Advisory agent | may read/propose, not execute | guard — PLSQL_SOURCE |
| Bounded automation | only specifically granted tool operations | guard/tool package — PLSQL_SOURCE |
| Programming proposal | write proposal/audit, not schedule | AI programming tool — PLSQL_SOURCE |
| Bounded schedule insert | must pass programming package validation | AI programming tool — PLSQL_SOURCE |
| Arbitrary SQL | prohibited as general AI authority | architecture invariant |
| Graph RAG | graph/vector/relational evidence retrieval | source architecture exists; certification incomplete |
| Hallucination control | provenance/verification/fail-closed action boundary | architecture/tests partial |

## 11. API/application access

| Capability | Required behavior | Current state |
|---|---|---|
| Entity read model | controlled projection | source exists |
| Current programming read model | station/current programming projection | source exists |
| JSON Duality | JSON view over relational authority | source/template exists; runtime capability not proven |
| ORDS versioned API | applications do not receive DBA access | architecture planned; deployment incomplete |
| Package-based writes | protected DML through packages | programming/rights/commercial/AI control source exists |

## 12. Operations, security and recovery

| Capability | Required behavior | Current state |
|---|---|---|
| Production classification | Free tier does not downgrade environment | ADR-0002 ACCEPTED |
| Least privilege | owner/migration/runtime/API/ingest/AI/auditor roles separated | design exists; runtime grants not certified |
| Audit | native/project audit evidence | source/design partial |
| Migration ledger | deployed commit/checksum/state recorded | source exists; runtime not proven |
| Precheck/apply/postcheck | every production mutation packaged | V0002/V0003 implement pattern |
| Rollback/recovery | each mutation has compensating/rebuild strategy | migration docs exist; runtime drills pending |
| Performance | measured by workload class | plans/tests exist; runtime baselines pending |
| Documentation recovery | project survives chat loss | canonical manual/runbook/state/catalog now present |

## 13. Business capability completion rule

A business capability cannot be called complete until all applicable rows below exist and link to evidence:

```text
BUSINESS RULE
DATA/D3KA MODEL
PL/SQL/API IMPLEMENTATION
SECURITY
TESTS: positive + negative
PERFORMANCE
OPERATIONS/OBSERVABILITY
RECOVERY
DOCUMENTATION
RUNTIME EVIDENCE
OWNER ACCEPTANCE
```

This catalog is the business-side counterpart to `SOURCE-ROUTINE-DEPENDENCY-CATALOG-v0.03.md`.
