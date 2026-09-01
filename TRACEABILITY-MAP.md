# TPS_INTELLIGENCE_CORE_01 — TRACEABILITY MAP v0.01

## Traceability chain

```text
BUSINESS NEED
  -> BUSINESS REQUIREMENT (BR)
  -> SYSTEM REQUIREMENT (SR)
  -> ARCHITECTURE DECISION (ADR)
  -> DATA/AI REQUIREMENT (DR/AIR)
  -> SOURCE OBJECT/FILE
  -> TEST CASE (TC)
  -> EVIDENCE (EV)
  -> CORE GATE
  -> RELEASE/CERTIFICATION
```

## Initial canonical requirements

| ID | Requirement | Design/source family | Test family | Gate |
|---|---|---|---|---|
| BR-001 | One corporate source of truth for media identities | TPS_ENTITY | D3KA/kernel | 03 |
| BR-002 | Radio/TV/affiliate/repeater relationships without duplicate identities | TPS_RELATION/D3KA | D3KA/graph | 04-05 |
| BR-003 | Regional/local programming while sharing network content | context + schedule relations | integration/D3KA | 06,14 |
| BR-004 | 24x7 programming authority independent of local studio presence | schedule/policy/event model | integration/recovery | 11,14 |
| BR-005 | Rights-aware content decisions | rights + policy relations | policy/security | 11,18 |
| BR-006 | Advertising eligibility/frequency/territory enforcement | campaigns + policy | commercial/policy | 11,14 |
| BR-007 | Auditable AI recommendations | AI decision + provenance | AI/audit | 10,12,16 |
| BR-008 | Historical reconstruction of business state | temporal relation model | temporal/regression | 07 |
| BR-009 | Semantic similarity and recommendation | TPS_VECTOR | vector/AI | 08,16 |
| BR-010 | Applications consume versioned API, not direct DBA access | API/Duality/ORDS | API/security | 13,18 |
| SR-001 | >=90% logical knowledge coverage through D3KA | D3KA coverage model | D3KA coverage suite | 15 |
| SR-002 | AI cannot directly authorize broadcast/commercial/right-sensitive actions | policy engine boundary | AI negative tests | 10-11,16 |
| SR-003 | Every important assertion carries provenance/confidence | TPS_ASSERTION/TPS_SOURCE | knowledge tests | 09 |
| SR-004 | Every production mutation has audit/change evidence | audit/change control | audit tests | 12,20 |
| SR-005 | Performance targets measured by workload class | performance architecture | benchmark suites | 17 |
| SR-006 | Recovery is certified by restore/rebuild drill, not backup existence | recovery architecture | recovery tests | 19 |

This map grows monotonically. Requirement IDs are never silently recycled.
