/*=============================================================================
 @file              src/13-commercial/1320_tps_commercial_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        Commercial placement / frequency / rights
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE; invoked DML is R2_STATEFUL
 @purpose           Expose deterministic authorization and lifecycle operations for commercial placements.
 @business_impact   Enforces campaign validity, active creative asset, broadcast rights and campaign frequency
                    before an advertisement placement can become AUTHORIZED or PLAYED.
 @objects           Creates/replaces TPS_COMMERCIAL_PKG specification.
 @dependencies      TPS_CAMPAIGN, TPS_PLACEMENT, TPS_MEDIA_ASSET, TPS_RIGHTS_PKG, TPS_EVENT.
 @upstream          Commercial scheduler, programming rules, approved API/AI tools.
 @downstream        Placement state and programming approval.
 @d3ka_role         POLICY/TEMPORAL/ENTITY
 @d3ka_links        Campaign, advertiser, creative and channel are canonical entities participating in D3KA.
 @ai_role           AI can choose candidates; authorization remains deterministic here.
 @security          AUTHID DEFINER; ordinary callers should have EXECUTE rather than table DML.
 @performance       Point placement/campaign lookup plus bounded frequency count.
 @transaction       No COMMIT/ROLLBACK. Caller owns transaction.
 @idempotency       AUTHORIZE_PLACEMENT only transitions PLANNED; MARK_PLAYED only transitions AUTHORIZED.
 @failure_modes     Fail-closed decision codes; state-transition errors use -205xx.
 @rollback_recovery Caller rollback for uncommitted changes; committed history remains auditable.
 @tests             tests/commercial/COM-001_commercial_pkg.sql; tests/programming/PRG-910_rules_engine.sql.
 @evidence          CORE-11/14/18 commercial authorization evidence.
 @references        Oracle AI Database 26ai PL/SQL Language Reference.
 @links             src/13-commercial/1300_tps_campaign.sql; src/13-commercial/1310_tps_placement.sql;
                    src/12-media/1293_tps_programming_rules_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_commercial_pkg AUTHID DEFINER AS

  /* @routine placement_decision
     @purpose       Return deterministic authorization code for one placement at p_at.
     @inputs        Placement ID and evaluation timestamp.
     @outputs       ALLOW or DENY_* code.
     @reads         TPS_PLACEMENT, TPS_CAMPAIGN, TPS_MEDIA_ASSET, TPS_RIGHTS_PKG.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     AUTHORIZE_PLACEMENT and programming rules.
     @d3ka_impact   Policy decision over campaign/creative/channel entities.
     @ai_impact     Deterministic boundary; AI cannot override result.
     @security      Coarse decision only; raw commercial rules remain inside DB.
     @transaction   Read-only.
     @performance   Indexed point lookup plus frequency count over campaign/channel/time.
     @errors        Standard Oracle errors propagate; missing placement returns DENY_PLACEMENT_NOT_FOUND.
     @tests         COM-001.
  */
  FUNCTION placement_decision(
      p_placement_id IN NUMBER,
      p_at           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2;

  /* @routine authorize_placement
     @purpose       Transition PLANNED -> AUTHORIZED only when PLACEMENT_DECISION returns ALLOW.
     @inputs        Placement ID and evaluation timestamp.
     @outputs       Decision code.
     @reads         Commercial/rights/media state.
     @writes        TPS_PLACEMENT.STATE/DECISION_JSON.
     @calls         PLACEMENT_DECISION.
     @called_by     Commercial scheduler/API.
     @d3ka_impact   Persists deterministic authorization for a D3KA-linked creative/channel action.
     @ai_impact     AI may request; cannot bypass state/rules.
     @security      Definer-rights controlled DML.
     @transaction   No commit.
     @performance   One row lock + decision query.
     @errors        -20501 missing/non-PLANNED placement.
     @tests         COM-001.
  */
  FUNCTION authorize_placement(
      p_placement_id IN NUMBER,
      p_at           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2;

  /* @routine mark_played
     @purpose       Transition AUTHORIZED -> PLAYED and link the immutable playback event.
     @inputs        Placement ID and TPS_EVENT ID.
     @outputs       NONE.
     @reads         TPS_PLACEMENT.
     @writes        TPS_PLACEMENT.STATE/PLAYED_EVENT_ID.
     @calls         NONE.
     @called_by     Playout/event ingestion after confirmed commercial play.
     @d3ka_impact   Records execution history adjacent to commercial D3KA relations.
     @ai_impact     NONE.
     @security      Controlled definer-rights update.
     @transaction   No commit.
     @performance   PK row lock/update.
     @errors        -20502 unless placement is AUTHORIZED.
     @tests         COM-001.
  */
  PROCEDURE mark_played(
      p_placement_id IN NUMBER,
      p_played_event_id IN NUMBER
  );

END tps_commercial_pkg;
/
