/*=============================================================================
 @file              src/13-commercial/1321_tps_commercial_pkg.pkb
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-11/14/18
 @workstream        Commercial placement / frequency / rights
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE; invoked DML is R2_STATEFUL
 @purpose           Implement deterministic commercial authorization and lifecycle rules.
 @business_impact   Prevents inactive/expired campaigns, missing creatives, missing rights or frequency
                    overflow from becoming authorized commercial playback.
 @objects           Creates/replaces TPS_COMMERCIAL_PKG body.
 @dependencies      Package spec, TPS_CAMPAIGN, TPS_PLACEMENT, TPS_MEDIA_ASSET, TPS_RIGHTS_PKG.
 @upstream          Calls through TPS_COMMERCIAL_PKG.
 @downstream        Placement state and programming validation.
 @d3ka_role         POLICY/TEMPORAL/ENTITY
 @d3ka_links        Campaign/creative/channel entities are governed IDs; temporal/policy checks gate action.
 @ai_role           NONE probabilistic; AI remains subordinate.
 @security          AUTHID DEFINER, static SQL only, no arbitrary SQL execution.
 @performance       Point lookups and bounded count by campaign/channel/time window.
 @transaction       No COMMIT/ROLLBACK. Caller controls atomicity.
 @idempotency       State transitions are guarded by current state.
 @failure_modes     Explicit DENY_* decisions; state-transition application errors -20501/-20502.
 @rollback_recovery Caller rollback before commit; later lifecycle records remain auditable.
 @tests             tests/commercial/COM-001_commercial_pkg.sql.
 @evidence          CORE-11/14/18.
 @references        Oracle AI Database 26ai PL/SQL and SQL Language Reference.
 @links             src/13-commercial/1320_tps_commercial_pkg.pks;
                    src/14-rights/1420_tps_rights_pkg.pkb
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.03 2026-09-01 — initial implementation.
=============================================================================*/

CREATE OR REPLACE PACKAGE BODY tps_commercial_pkg AS

  /* @routine placement_decision
     @purpose       Evaluate campaign state/time, creative asset, rights and frequency.
     @inputs        Placement ID, timestamp.
     @outputs       ALLOW or DENY_*.
     @reads         TPS_PLACEMENT, TPS_CAMPAIGN, TPS_MEDIA_ASSET, TPS_RIGHTS_PKG.
     @writes        NONE.
     @calls         TPS_RIGHTS_PKG.DECISION_FOR.
     @called_by     AUTHORIZE_PLACEMENT, programming rules.
     @d3ka_impact   Policy evaluation over canonical entities.
     @ai_impact     Deterministic authorization.
     @security      No raw dynamic SQL.
     @transaction   Read-only.
     @performance   Point lookups plus one frequency count.
     @errors        Standard Oracle errors propagate; not-found returns deny code.
     @tests         COM-001.
  */
  FUNCTION placement_decision(
      p_placement_id IN NUMBER,
      p_at           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2 IS
      l_campaign_entity_id NUMBER;
      l_creative_entity_id NUMBER;
      l_channel_entity_id  NUMBER;
      l_placement_state    VARCHAR2(30);
      l_campaign_state     VARCHAR2(30);
      l_valid_from         TIMESTAMP WITH TIME ZONE;
      l_valid_to           TIMESTAMP WITH TIME ZONE;
      l_freq_window_sec    NUMBER;
      l_freq_count_max     NUMBER;
      l_asset_count        NUMBER;
      l_recent_count       NUMBER;
      l_rights             VARCHAR2(40);
  BEGIN
      BEGIN
          SELECT p.campaign_entity_id,
                 p.creative_entity_id,
                 p.channel_entity_id,
                 p.state,
                 c.state,
                 c.valid_from,
                 c.valid_to,
                 c.max_frequency_window_sec,
                 c.max_frequency_count
            INTO l_campaign_entity_id,
                 l_creative_entity_id,
                 l_channel_entity_id,
                 l_placement_state,
                 l_campaign_state,
                 l_valid_from,
                 l_valid_to,
                 l_freq_window_sec,
                 l_freq_count_max
            FROM tps_placement p
            JOIN tps_campaign c
              ON c.campaign_entity_id = p.campaign_entity_id
           WHERE p.placement_id = p_placement_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RETURN 'DENY_PLACEMENT_NOT_FOUND';
      END;

      IF l_placement_state NOT IN ('PLANNED','AUTHORIZED') THEN
          RETURN 'DENY_PLACEMENT_STATE';
      END IF;

      IF l_campaign_state <> 'ACTIVE' THEN
          RETURN 'DENY_CAMPAIGN_NOT_ACTIVE';
      END IF;

      IF p_at < l_valid_from OR p_at >= l_valid_to THEN
          RETURN 'DENY_CAMPAIGN_OUTSIDE_WINDOW';
      END IF;

      SELECT COUNT(*)
        INTO l_asset_count
        FROM tps_media_asset
       WHERE content_entity_id = l_creative_entity_id
         AND lifecycle_state = 'ACTIVE';

      IF l_asset_count = 0 THEN
          RETURN 'DENY_CREATIVE_ASSET_MISSING';
      END IF;

      l_rights := tps_rights_pkg.decision_for(
          p_content_entity_id     => l_creative_entity_id,
          p_beneficiary_entity_id => l_channel_entity_id,
          p_action_code           => 'BROADCAST',
          p_at                    => p_at
      );

      IF l_rights <> 'ALLOW' THEN
          RETURN 'DENY_RIGHTS_' || NVL(l_rights,'UNKNOWN');
      END IF;

      IF l_freq_window_sec IS NOT NULL
         AND l_freq_count_max IS NOT NULL
         AND l_freq_window_sec > 0
         AND l_freq_count_max >= 0 THEN

          SELECT COUNT(*)
            INTO l_recent_count
            FROM tps_placement p
           WHERE p.campaign_entity_id = l_campaign_entity_id
             AND p.channel_entity_id = l_channel_entity_id
             AND p.placement_id <> p_placement_id
             AND p.state IN ('AUTHORIZED','PLAYED')
             AND p.planned_at >= p_at - NUMTODSINTERVAL(l_freq_window_sec,'SECOND')
             AND p.planned_at < p_at;

          IF l_recent_count >= l_freq_count_max THEN
              RETURN 'DENY_FREQUENCY_LIMIT';
          END IF;
      END IF;

      RETURN 'ALLOW';
  END placement_decision;

  /* @routine authorize_placement
     @purpose       Lock and transition PLANNED placement according to deterministic decision.
     @inputs        Placement ID, timestamp.
     @outputs       Decision code.
     @reads         Placement/campaign/media/rights state.
     @writes        TPS_PLACEMENT.
     @calls         PLACEMENT_DECISION.
     @called_by     Commercial scheduler/API.
     @d3ka_impact   Persists authorization result.
     @ai_impact     AI request cannot bypass package decision.
     @security      Definer-rights DML.
     @transaction   No commit.
     @performance   PK lock + decision lookup.
     @errors        -20501 if placement not PLANNED.
     @tests         COM-001.
  */
  FUNCTION authorize_placement(
      p_placement_id IN NUMBER,
      p_at           IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN VARCHAR2 IS
      l_state    VARCHAR2(30);
      l_decision VARCHAR2(80);
  BEGIN
      BEGIN
          SELECT state
            INTO l_state
            FROM tps_placement
           WHERE placement_id = p_placement_id
           FOR UPDATE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20501,'TPS_COMMERCIAL_PLACEMENT_NOT_FOUND');
      END;

      IF l_state <> 'PLANNED' THEN
          RAISE_APPLICATION_ERROR(-20501,'TPS_COMMERCIAL_PLACEMENT_NOT_PLANNED');
      END IF;

      l_decision := placement_decision(p_placement_id, p_at);

      IF l_decision = 'ALLOW' THEN
          UPDATE tps_placement
             SET state = 'AUTHORIZED',
                 decision_json = JSON_OBJECT(
                     'decision' VALUE l_decision,
                     'evaluated_at' VALUE TO_CHAR(p_at,'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM')
                     RETURNING JSON
                 )
           WHERE placement_id = p_placement_id;
      ELSE
          UPDATE tps_placement
             SET state = 'REJECTED',
                 decision_json = JSON_OBJECT(
                     'decision' VALUE l_decision,
                     'evaluated_at' VALUE TO_CHAR(p_at,'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM')
                     RETURNING JSON
                 )
           WHERE placement_id = p_placement_id;
      END IF;

      RETURN l_decision;
  END authorize_placement;

  /* @routine mark_played
     @purpose       Mark one authorized placement as played and attach confirmed event evidence.
     @inputs        Placement ID, played event ID.
     @outputs       NONE.
     @reads         TPS_PLACEMENT.
     @writes        TPS_PLACEMENT.
     @calls         NONE.
     @called_by     Playout/event ingestion.
     @d3ka_impact   Adds execution evidence to commercial action history.
     @ai_impact     NONE.
     @security      Definer-rights transition.
     @transaction   No commit.
     @performance   One PK update.
     @errors        -20502 unless exactly one AUTHORIZED row transitions.
     @tests         COM-001.
  */
  PROCEDURE mark_played(
      p_placement_id IN NUMBER,
      p_played_event_id IN NUMBER
  ) IS
  BEGIN
      UPDATE tps_placement
         SET state = 'PLAYED',
             played_event_id = p_played_event_id
       WHERE placement_id = p_placement_id
         AND state = 'AUTHORIZED';

      IF SQL%ROWCOUNT <> 1 THEN
          RAISE_APPLICATION_ERROR(-20502,'TPS_COMMERCIAL_PLACEMENT_NOT_AUTHORIZED');
      END IF;
  END mark_played;

END tps_commercial_pkg;
/
