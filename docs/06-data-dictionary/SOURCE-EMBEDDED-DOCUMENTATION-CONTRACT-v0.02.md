# TPSDBCORE01 — SOURCE EMBEDDED DOCUMENTATION CONTRACT v0.02

## 1. Required file header

Every `.sql`, `.pks` and `.pkb` under `src/` must start with a structured comment block equivalent to:

```sql
/*=============================================================================
 @file              src/<domain>/<file>
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-XX
 @workstream        WS-XX
 @source_state      DRAFT | REVIEWED | SOURCE_READY | CERTIFIED_SOURCE
 @production_state  NOT_DEPLOYED | DEPLOYED_UNCERTIFIED | DEPLOYED_CERTIFIED
 @reversibility     READ_ONLY | R1_ADDITIVE | R2_STATEFUL | R3_TRANSFORMATIVE | R4_IRREVERSIBLE_HISTORY
 @purpose           <what this source exists to do>
 @business_impact   <business capability affected>
 @objects           <objects created/replaced/read/modified>
 @dependencies      <hard upstream object/source dependencies>
 @upstream          <business/technical producers>
 @downstream        <consumers, views, APIs, packages, graph, AI>
 @d3ka_role         ENTITY | RELATION | CONTEXT | TEMPORAL | PROVENANCE | VECTOR | POLICY | AI | GRAPH | NONE
 @d3ka_links        <specific D3KA objects/axes/relations touched>
 @ai_role           <AI/ML/RAG/agent role or NONE>
 @security          <privileges, sensitive data, least-privilege impact>
 @performance       <dominant query/write paths, cardinality/index/CPU impact>
 @transaction       <commit ownership, locks, consistency semantics>
 @idempotency       <re-execution behavior>
 @failure_modes     <known failures / fail-closed behavior>
 @rollback_recovery <drop/revert/rebuild/restore strategy>
 @tests             <exact test paths>
 @evidence          <exact certification/evidence target>
 @references        <Oracle/docs/standards references>
 @links             <internal docs/ADR/requirement/source links>
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    <version/date/summary>
=============================================================================*/
```

The exact wording may vary, but the semantic fields may not be omitted.

## 2. Required routine block

Immediately before every public or private PL/SQL function/procedure:

```sql
/* @routine <routine_name>
   @purpose       ...
   @inputs        ...
   @outputs       ...
   @reads         ...
   @writes        ...
   @calls         ...
   @called_by     ...
   @d3ka_impact   ...
   @ai_impact     ...
   @security      ...
   @transaction   ...
   @performance   ...
   @errors        ...
   @tests         ...
*/
```

### Parameters

For non-trivial routines, document each parameter using `@param`:

```sql
-- @param p_entity_id NUMBER NOT NULL : canonical TPS_ENTITY identifier.
```

Return semantics must be explicit. Do not write only "returns status"; define every admissible status when the routine returns a code/string.

## 3. Required table/view/object notes

DDL sources must document each persistent object with:

- row meaning;
- primary identity;
- foreign-key meaning;
- uniqueness semantics;
- state/lifecycle semantics;
- temporal semantics;
- JSON/vector semantics when present;
- expected cardinality/growth;
- retention/archive rules;
- write authority;
- main read consumers;
- indexes required or intentionally deferred;
- D3KA mapping.

Important columns should receive inline comments when their semantics cannot be derived from the name.

## 4. D3KA-specific documentation

Every D3KA-related source must explicitly identify whether it controls:

```text
S = SOURCE_ENTITY
R = RELATION_TYPE
T = TARGET_ENTITY
C = CONTEXT
Tv = VALID/EVENT TIME
To = OBSERVED/RECORDED TIME
P = PROPERTIES
V = VECTOR
E = EVIDENCE/PROVENANCE
Q = CONFIDENCE/VERIFICATION
A = AUTHORIZATION/POLICY
```

For example, `TPS_RELATION` is the persisted D3KA cell backbone and must document how `source_entity_id`, `relation_type_id`, `target_entity_id`, `context_id`, temporal fields, confidence and provenance form the cell.

## 5. AI-specific documentation

Every AI source must document:

- model/provider abstraction;
- model version;
- grounding sources;
- data exposure boundary;
- prompt/profile/task/tool responsibility;
- deterministic policy boundary;
- human override path where applicable;
- hallucination/unsupported-claim handling;
- provenance capture;
- confidence semantics;
- rate/cost/capacity concerns;
- failure behavior;
- whether execution is recommendation-only or can reach an authorized action gate.

The invariant is:

```text
AI_RECOMMENDATION != AUTHORIZED_OPERATION
```

## 6. Reference standard

References should prefer stable primary sources, including:

- Oracle AI Database 26ai SQL Language Reference;
- Oracle Property Graph documentation;
- Oracle AI Vector Search User's Guide;
- Oracle JSON-Relational Duality documentation;
- Oracle Autonomous AI Database / Select AI documentation;
- Oracle `DBMS_CLOUD_AI_AGENT` documentation;
- standards such as SQL:2023 where directly applicable;
- project ADRs and requirements.

A reference documents why a technology choice is valid; it never replaces an executable compatibility test on TPSDBCORE01.

## 7. Documentation debt states

Allowed documentation status:

- `DOC_MISSING`
- `DOC_PARTIAL`
- `DOC_REVIEW_REQUIRED`
- `DOC_COMPLETE_SOURCE`
- `DOC_CERTIFIED`

No source may become `SOURCE_READY` while its documentation state is below `DOC_COMPLETE_SOURCE`.

## 8. Mechanical validation

`tools/validate_source_documentation.py` is the repository gate for required source metadata and PL/SQL routine tags. CI must run it for pull requests and pushes that modify source.
