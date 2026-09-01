/*=============================================================================
 @file              src/12-media/1280_tps_continuity_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-05/07/11/12/14
 @workstream        24x7 continuity / affiliate-network fallback / playout resolution
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE package; RESOLVE_PLAYOUT inserts R2 audit state
 @purpose           Resolve what a station/channel should play at a point in time when its
                    primary/live source is available or unavailable, using deterministic schedule,
                    asset, rights and D3KA network-affiliation rules.
 @business_impact   Implements database-side continuity logic so an affiliate/local studio can
                    fail to provide a live source while the network continues authorized programming.
 @objects           Creates/replaces TPS_CONTINUITY_PKG specification.
 @dependencies      TPS_PROGRAMMING_PKG, TPS_RELATION, TPS_RELATION_TYPE, TPS_ENTITY,
                    TPS_SCHEDULE/TPS_SCHEDULE_ITEM and TPS_CONTINUITY_DECISION.
 @upstream          Playout/orchestrator heartbeat/state and control plane.
 @downstream        Selected schedule item ID + immutable continuity decision ledger.
 @d3ka_role         RELATION/TEMPORAL/POLICY/EVENT
 @d3ka_links        Resolves parent network through current D3KA relations `REPEATS` or
                    `AFFILIATED_WITH`, then evaluates programming at Tv=p_at.
 @ai_role           AI is not required for safety/continuity. AI may later rank candidate fallback
                    content only inside deterministic eligibility boundaries.
 @security          AUTHID DEFINER. Execute privilege is a production playout capability and must
                    be narrowly granted. No dynamic SQL or arbitrary tool dispatch.
 @performance       Short-circuit current-time lookups; D3KA parent lookup is indexed relation traversal.
 @transaction       RESOLVE_PLAYOUT inserts one audit decision and does not COMMIT.
 @idempotency       Each call records a decision event; caller request-id deduplication is a future enhancement.
 @failure_modes     Invalid primary flag; no normal/emergency/fallback/network item; missing affiliation;
                    underlying rights/asset failures. No candidate returns NO_PLAYABLE_ITEM rather than inventing content.
 @rollback_recovery Caller rollback before commit. Committed decisions immutable.
 @tests             tests/continuity/CONT-001_local_fallback.sql;
                    CONT-002_network_fallback.sql; CONT-003_immutable_ledger.sql.
 @evidence          CORE-05 D3KA relation lookup; CORE-14 continuity; CORE-12 audit; CORE-18 security.
 @references        Oracle AI Database 26ai PL/SQL/SQL references; project D3KA/continuity architecture.
 @links             src/12-media/1260_tps_programming_pkg.pks;
                    src/12-media/1270_tps_continuity_decision.sql;
                    src/03-d3ka/310_tps_relation.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — initial 24x7 continuity contract.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_continuity_pkg AUTHID DEFINER AS

  /* @routine resolve_network_entity
     @purpose       Resolve the current canonical parent/network entity for an affiliate/repeater.
     @inputs        Owner entity and evaluation timestamp.
     @outputs       Target entity ID or NULL.
     @reads         TPS_RELATION, TPS_RELATION_TYPE, TPS_ENTITY.
     @writes        NONE.
     @calls         NONE.
     @called_by     RESOLVE_PLAYOUT and diagnostics.
     @d3ka_impact   Traverses current S --REPEATS/AFFILIATED_WITH--> T relation.
     @ai_impact     Deterministic graph/D3KA lookup; no AI.
     @security      Read-only relation metadata.
     @transaction   Read-only.
     @performance   Filtered S/R/current-time lookup; returns first deterministic candidate.
     @errors        Unexpected Oracle errors propagate; no relation returns NULL.
     @tests         CONT-002_network_fallback.sql.
  */
  FUNCTION resolve_network_entity(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  /* @routine resolve_playout
     @purpose       Resolve and audit the actual schedule item to use for playout now.
     @inputs        Owner entity, primary availability flag (0/1), evaluation time.
     @outputs       OUT decision ID, selected schedule item ID (nullable), decision code.
     @reads         D3KA relations, schedules/items/assets/rights through programming package.
     @writes        TPS_CONTINUITY_DECISION only.
     @calls         TPS_PROGRAMMING_PKG.ITEM_IS_PLAYABLE; RESOLVE_NETWORK_ENTITY.
     @called_by     Media orchestrator/playout controller.
     @d3ka_impact   Uses affiliate/network relation plus temporal content plan.
     @ai_impact     Deterministic safety path; does not require or trust an LLM to maintain air continuity.
     @security      High-impact runtime capability; EXECUTE restricted to playout authority.
     @transaction   One audit INSERT; no COMMIT.
     @performance   Bounded sequence of indexed current-time candidate scans.
     @errors        -20310 invalid primary flag; unexpected DB errors propagate. No eligible item is
                    represented as NO_PLAYABLE_ITEM, not an exception or fabricated selection.
     @tests         CONT-001/002/003.
  */
  PROCEDURE resolve_playout(
      p_owner_entity_id     IN NUMBER,
      p_primary_available   IN NUMBER,
      p_at                  IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
      o_continuity_decision_id OUT NUMBER,
      o_schedule_item_id    OUT NUMBER,
      o_decision_code       OUT VARCHAR2
  );

END tps_continuity_pkg;
/
