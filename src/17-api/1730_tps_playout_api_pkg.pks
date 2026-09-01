/*=============================================================================
 @file              src/17-api/1730_tps_playout_api_pkg.pks
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-13/14/18
 @workstream        Controlled playout/read-model API
 @source_state      SOURCE_READY_PENDING_RUNTIME_COMPILE_TEST
 @production_state  NOT_DEPLOYED
 @reversibility     R1_ADDITIVE; RESOLVE_PLAYOUT_JSON invokes stateful continuity ledger insert
 @purpose           Expose compact JSON now/next and continuity resolution contracts over the
                    deterministic programming and continuity engines.
 @business_impact   Provides an immediately consumable database API for player/control-plane
                    integration without direct schedule-table access.
 @objects           Creates/replaces TPS_PLAYOUT_API_PKG specification.
 @dependencies      TPS_PROGRAMMING_PKG, TPS_CONTINUITY_PKG, TPS_SCHEDULE_ITEM,
                    TPS_SCHEDULE, TPS_ENTITY.
 @upstream          ORDS/control plane/playout services and diagnostics.
 @downstream        JSON clients; continuity decision ledger through continuity package.
 @d3ka_role         TEMPORAL/RELATION/API
 @d3ka_links        Resolves content and owner identities selected by D3KA-aware continuity.
 @ai_role           Safe read/decision surface; no free-form SQL generation.
 @security          AUTHID DEFINER. API service gets EXECUTE instead of underlying table grants.
 @performance       Two indexed programming lookups for now/next; continuity is bounded.
 @transaction       NOW_NEXT_JSON read-only. RESOLVE_PLAYOUT_JSON writes one continuity decision;
                    caller owns COMMIT/ROLLBACK.
 @idempotency       NOW/NEXT repeatable for stable state/time. Continuity calls create audit events.
 @failure_modes     Invalid owner/primary flag or underlying package errors; no item returns JSON null.
 @rollback_recovery Drop package before use; caller rollback for uncommitted continuity decision.
 @tests             tests/integration/INT-010_broadcast_end_to_end.sql; COMP-003.
 @evidence          CORE-13/14 API behavior.
 @references        Oracle AI Database 26ai JSON_OBJECT and PL/SQL documentation.
 @links             src/12-media/1260_tps_programming_pkg.pks; src/12-media/1280_tps_continuity_pkg.pks
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.04 2026-09-01 — initial controlled playout JSON API.
=============================================================================*/

CREATE OR REPLACE PACKAGE tps_playout_api_pkg AUTHID DEFINER AS

  FUNCTION now_next_json(
      p_owner_entity_id IN NUMBER,
      p_at              IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB;

  FUNCTION resolve_playout_json(
      p_owner_entity_id   IN NUMBER,
      p_primary_available IN NUMBER,
      p_at                IN TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP
  ) RETURN CLOB;

END tps_playout_api_pkg;
/
