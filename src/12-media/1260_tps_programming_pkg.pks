/*=============================================================================
 @file              src/12-media/1260_tps_programming_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-14/17/18
 @workstream        Programming / scheduling / rights / media availability
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package; routines perform R2_STATEFUL caller-owned DML
 @purpose           Expose the deterministic PL/SQL authority for creating, populating,
                    validating, approving and activating programming schedules and for
                    resolving authorized current/next schedule items.
 @business_impact   Converts station programming from direct table manipulation into one
                    governed transaction boundary shared by radio, TV, network, affiliates,
                    local override, emergency and fallback schedules.
 @objects           Creates/replaces TPS_PROGRAMMING_PKG specification.
 @dependencies      TPS_ENTITY, TPS_SCHEDULE, TPS_SCHEDULE_ITEM, TPS_MEDIA_ASSET,
                    TPS_RIGHTS_PKG and supporting constraints/indexes.
 @upstream          Human control plane, approved APIs, bounded AI tools and migrations.
 @downstream        TPS_CONTINUITY_PKG, playout/orchestration API, tests and audit/event layers.
 @d3ka_role         ENTITY/TEMPORAL/POLICY
 @d3ka_links        OWNER_ENTITY_ID and CONTENT_ENTITY_ID are canonical D3KA entities; schedule
                    windows are temporal; rights authorization is deterministic policy.
 @ai_role           AI may call these routines only through an authorized tool boundary.
                    AI proposes; this package validates deterministic invariants before state change.
 @security          AUTHID DEFINER. Runtime identities should receive EXECUTE, not direct DML
                    on TPS_SCHEDULE/TPS_SCHEDULE_ITEM. Rights/asset checks are fail-closed.
 @performance       Schedule edits lock one TPS_SCHEDULE row to serialize overlap validation.
                    Current/next item resolution uses schedule/item time indexes and short loops.
 @transaction       No routine commits or rolls back. Caller owns atomic transaction.
 @idempotency       CREATE_SCHEDULE uses unique SCHEDULE_KEY. ADD_SCHEDULE_ITEM is intentionally
                    non-idempotent and rejects time overlap; API callers should carry idempotency keys
                    in a future request ledger before network retries are enabled.
 @failure_modes     Invalid owner/content, invalid time, non-DRAFT edit, overlap, unavailable asset,
                    rights != ALLOW, active-schedule collision and missing objects/privileges.
 @rollback_recovery Caller rollback before commit. After commit, schedule lifecycle uses
                    CANCELLED/SUPERSEDED/RETIRED rather than physical history deletion.
 @tests             tests/programming/PRG-001_create_schedule.sql through PRG-005_current_item.sql;
                    tests/compile/COMP-001_programming_continuity.sql.
 @evidence          CORE-14 programming behavior; CORE-17 performance; CORE-18 privilege boundary.
 @references        Oracle AI Database 26ai PL/SQL Language Reference; SELECT FOR UPDATE,
                    DML RETURNING, JSON_OBJECT and transaction semantics.
 @links             src/12-media/1230_tps_schedule.sql;
                    src/12-media/1240_tps_schedule_item.sql;
                    src/12-media/1250_tps_media_asset.sql;
                    src/14-rights/1410_tps_rights_pkg.pks;
                    src/12-media/1280_tps_continuity_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial production-grade PL/SQL programming contract.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_programming_pkg AUTHID DEFINER AS

  /* @routine create_schedule
     @purpose       Create one DRAFT schedule for a canonical owner entity.
     @inputs        Stable key, owner, timezone, class, validity window, precedence.
     @outputs       New TPS_SCHEDULE.SCHEDULE_ID.
     @reads         TPS_ENTITY.
     @writes        TPS_SCHEDULE.
     @calls         NONE.
     @called_by     Control plane/API/bounded tooling.
     @d3ka_impact   Associates schedule ownership with a canonical D3KA entity.
     @ai_impact     AI may request creation only through authorized tooling; this is real DML.
     @security      Package EXECUTE required; direct schedule INSERT should be withheld.
     @transaction   INSERT only; caller owns COMMIT/ROLLBACK.
     @performance   One entity lookup plus one insert.
     @errors        -20201 owner invalid; -20202 validity invalid; DB uniqueness/constraint errors.
     @tests         PRG-001_create_schedule.sql.
  */
  FUNCTION create_schedule(
      p_schedule_key    IN VARCHAR2,
      p_owner_entity_id IN NUMBER,
      p_timezone_name   IN VARCHAR2,
      p_schedule_class  IN VARCHAR2,
      p_valid_from      IN TIMESTAMP WITH TIME ZONE,
      p_valid_to        IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
      p_precedence      IN NUMBER DEFAULT 100
  ) RETURN NUMBER;

  /* @routine add_schedule_item
     @purpose       Add one item to a DRAFT schedule after serializing the edit and validating
                    time bounds, overlap, content identity, technical asset and broadcast rights.
     @inputs        Schedule/content/context/time/class/priority.
     @outputs       New TPS_SCHEDULE_ITEM.SCHEDULE_ITEM_ID.
     @reads         TPS_SCHEDULE, TPS_ENTITY, TPS_SCHEDULE_ITEM, TPS_MEDIA_ASSET,
                    TPS_RIGHT_GRANT indirectly through TPS_RIGHTS_PKG.
     @writes        TPS_SCHEDULE_ITEM.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     Human/API/authorized AI programming tool.
     @d3ka_impact   Schedules canonical content entity in owner/time context.
     @ai_impact     Probabilistic proposals cannot bypass overlap/asset/rights checks.
     @security      Real state change through definer-rights package; fail-closed rights.
     @transaction   Locks schedule row FOR UPDATE; no COMMIT.
     @performance   Point lookups + overlap range count + asset existence + rights lookup.
     @errors        -20210..-20216 documented in body.
     @tests         PRG-002_overlap_rejected.sql; PRG-003_rights_fail_closed.sql.
  */
  FUNCTION add_schedule_item(
      p_schedule_id      IN NUMBER,
      p_content_entity_id IN NUMBER,
      p_context_id       IN NUMBER DEFAULT NULL,
      p_start_at         IN TIMESTAMP WITH TIME ZONE,
      p_end_at           IN TIMESTAMP WITH TIME ZONE,
      p_item_class       IN VARCHAR2,
      p_priority         IN NUMBER DEFAULT 100
  ) RETURN NUMBER;

  /* @routine validation_report
     @purpose       Return machine-readable JSON validation counts for a schedule.
     @inputs        Schedule ID.
     @outputs       CLOB JSON with item, overlap, out-of-window, missing-asset and rights counts.
     @reads         Schedule/item/entity/asset/rights tables.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     Approval workflow, API, AI explanations, certification.
     @d3ka_impact   Deterministic validation over D3KA-linked owner/content entities.
     @ai_impact     Suitable as grounding evidence; report itself never authorizes execution.
     @security      Read through package; no raw rights rows returned.
     @transaction   Read-only.
     @performance   O(number of active items) plus overlap self-join count.
     @errors        -20220 schedule missing; underlying Oracle errors.
     @tests         PRG-004_validation_report.sql.
  */
  FUNCTION validation_report(p_schedule_id IN NUMBER) RETURN CLOB;

  /* @routine approve_schedule
     @purpose       Transition DRAFT -> APPROVED only when deterministic validation passes.
     @inputs        Schedule ID.
     @outputs       NONE.
     @reads         Schedule/items/assets/rights.
     @writes        TPS_SCHEDULE.STATE.
     @calls         Internal validation engine.
     @called_by     Human/control-plane approval workflow.
     @d3ka_impact   Marks temporal programming plan eligible for later activation.
     @ai_impact     AI recommendation cannot bypass validation; approval caller authorization is external.
     @security      EXECUTE grant restricted to programming authority.
     @transaction   Update in caller transaction; no COMMIT.
     @performance   Validation scan then one-row update.
     @errors        -20221 invalid schedule; -20222 wrong lifecycle state.
     @tests         PRG-004_validation_report.sql.
  */
  PROCEDURE approve_schedule(p_schedule_id IN NUMBER);

  /* @routine activate_schedule
     @purpose       Transition APPROVED -> ACTIVE when no overlapping ACTIVE schedule of the
                    same owner/class exists and validation remains clean.
     @inputs        Schedule ID.
     @outputs       NONE.
     @reads         Schedule/items/assets/rights.
     @writes        TPS_SCHEDULE.STATE.
     @calls         Internal validation engine.
     @called_by     Production programming activation workflow.
     @d3ka_impact   Makes one temporal schedule authoritative for owner/class.
     @ai_impact     BOUNDED_AUTOMATION may be allowed only after separate policy approval.
     @security      High-impact EXECUTE capability; should be separate from proposal capability.
     @transaction   Locks target schedule; no COMMIT.
     @performance   Validation + overlap count + one-row update.
     @errors        -20223 invalid/wrong state; -20224 active schedule conflict.
     @tests         PRG-005_current_item.sql.
  */
  PROCEDURE activate_schedule(p_schedule_id IN NUMBER);

  /* @routine item_is_playable
     @purpose       Fail-closed technical/rights eligibility check for one schedule item.
     @inputs        Item ID and optional evaluation time (defaults to item start time).
     @outputs       1=playable, 0=not playable/not found.
     @reads         Item/schedule/content/asset/rights.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     Current/next resolution and continuity engine.
     @d3ka_impact   Evaluates D3KA-linked content/owner under policy/time.
     @ai_impact     Deterministic safety filter for AI-selected candidates.
     @security      No raw rights details returned.
     @transaction   Read-only.
     @performance   Point lookups and one rights query.
     @errors        Returns 0 for semantic failure/not found; unexpected Oracle errors propagate.
     @tests         PRG-003_rights_fail_closed.sql.
  */
  FUNCTION item_is_playable(
      p_schedule_item_id IN NUMBER,
      p_at               IN TIMESTAMP WITH TIME ZONE DEFAULT NULL
  ) RETURN NUMBER;

  /* @routine current_item
     @purpose       Resolve highest-precedence playable item active at p_at for one owner.
     @inputs        Owner entity and point in time.
     @outputs       Schedule item ID or NULL.
     @reads         Active schedules/items plus item eligibility dependencies.
     @writes        NONE.
     @calls         ITEM_IS_PLAYABLE.
     @called_by     Playout/continuity/API.
     @d3ka_impact   Resolves temporal programming state for a canonical owner entity.
     @ai_impact     Read-only tool candidate.
     @security      Returns ID only; content retrieval remains separately authorized.
     @transaction   Read-only.
     @performance   Ordered indexed range cursor, usually stops on first playable row.
     @errors        Unexpected Oracle errors propagate; no candidate returns NULL.
     @tests         PRG-005_current_item.sql.
  */
  FUNCTION current_item(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  /* @routine next_item
     @purpose       Resolve next future playable item for one owner.
     @inputs        Owner entity and search point.
     @outputs       Schedule item ID or NULL.
     @reads         Active schedules/items plus eligibility dependencies.
     @writes        NONE.
     @calls         ITEM_IS_PLAYABLE.
     @called_by     Playout planning/continuity/API.
     @d3ka_impact   Temporal programming look-ahead.
     @ai_impact     Read-only planning tool.
     @security      Returns ID only.
     @transaction   Read-only.
     @performance   Ordered indexed future-range cursor.
     @errors        Unexpected Oracle errors propagate; no candidate returns NULL.
     @tests         PRG-005_current_item.sql.
  */
  FUNCTION next_item(
      p_owner_entity_id IN NUMBER,
      p_after           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

END tps_programming_pkg;
/
