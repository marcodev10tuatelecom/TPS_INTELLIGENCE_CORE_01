/*=============================================================================
 @file              src/00-precheck/070_audit_capability.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/12/18
 @workstream        WS-03 Oracle capability / WS-13 Audit / WS-21 Security
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Discover visible Oracle auditing option metadata and count visible unified
                    audit policy definitions without enabling/disabling or changing audit policy.
 @business_impact   Provides evidence for designing traceability of schema changes, privileged
                    access, AI decisions and policy-sensitive production operations.
 @objects           Reads V$OPTION and AUDIT_UNIFIED_POLICIES only.
 @dependencies      Dictionary/audit metadata visibility.
 @upstream          CORE-00 identity and privilege inventory.
 @downstream        CORE-12 audit design; CORE-18 security; production change-control evidence.
 @d3ka_role         PROVENANCE/AUDIT adjacent; no D3KA cell is read or written.
 @d3ka_links        Audit records will later help prove who changed knowledge/policy sources and when.
 @ai_role           Future AI decision audit depends on audit architecture; no AI is invoked here.
 @security          Audit metadata is security-sensitive configuration information. No audit records,
                    credentials or user content are selected by this probe.
 @performance       Small metadata queries only.
 @transaction       SELECT only; no policy enable/disable, DDL, DML or commit.
 @idempotency       Repeatable; count may change after legitimate audit-policy changes.
 @failure_modes     Missing access to AUDIT_UNIFIED_POLICIES yields incomplete evidence. A nonzero count
                    does not prove TPS-specific audit coverage; policy contents/enabled state require later analysis.
 @rollback_recovery None; read-only.
 @tests             tests/security/SEC-004_audit_protection.md and later unified-audit coverage tests.
 @evidence          CORE-12 audit capability baseline and CORE-18 security evidence.
 @references        Oracle AI Database 26ai Security Guide / Unified Auditing documentation.
 @links             docs/09-security/AUDIT-ARCHITECTURE.md;
                    docs/09-security/SECURITY-ARCHITECTURE-MASTER-v0.02.md;
                    src/18-observability/1800_tps_audit_event.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Feature-option metadata relevant to auditing. This does not enable any audit mode.
SELECT parameter, value
FROM v$option
WHERE UPPER(parameter) LIKE '%AUDIT%'
ORDER BY parameter;

-- Visible policy-definition count only; enabled-state and coverage require later certification.
SELECT COUNT(*) AS unified_audit_policies_visible
FROM audit_unified_policies;
