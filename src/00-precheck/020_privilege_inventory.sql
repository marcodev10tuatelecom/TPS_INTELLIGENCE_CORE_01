/*=============================================================================
 @file              src/00-precheck/020_privilege_inventory.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/02/18
 @workstream        WS-03 Oracle capability / WS-21 Security/privacy
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Record the effective session privileges, roles and received object grants
                    before defining schemas, package owners or runtime roles.
 @business_impact   Supports least privilege and prevents application/AI/runtime identities
                    from inheriting unnecessary administrative power over the production core.
 @objects           Reads SESSION_PRIVS, SESSION_ROLES and USER_TAB_PRIVS_RECD only.
 @dependencies      Connected authenticated Oracle session.
 @upstream          CORE-00 database identity and chosen engineering/admin session.
 @downstream        CORE-02 role/schema design, security tests, deployment prechecks.
 @d3ka_role         NONE directly; protects all D3KA/graph/knowledge objects by establishing
                    the privilege baseline before grants are designed.
 @d3ka_links        Indirect security boundary for ENTITY/RELATION/GRAPH/VECTOR/POLICY objects.
 @ai_role           Used to ensure future AI profiles/agents/tools do not receive DBA-like access.
 @security          Output is security-sensitive configuration metadata. No password/credential
                    values are read. Review for unexpected powerful privileges/roles.
 @performance       Small session/dictionary views only.
 @transaction       SELECT only; no mutation or locks intentionally acquired.
 @idempotency       Repeatable; effective privileges may change after approved security changes.
 @failure_modes     Incomplete dictionary visibility can produce an incomplete baseline; absence
                    must be marked NOT PROVEN rather than assumed. Any unexpected broad role
                    is a security finding, not something this source automatically changes.
 @rollback_recovery None; read-only.
 @tests             tests/security/SEC-001_role_grants.sql; SEC-002_no_dba_role.sql.
 @evidence          CORE-02 privilege baseline; CORE-18 least-privilege certification.
 @references        Oracle AI Database 26ai Reference: SESSION_PRIVS, SESSION_ROLES,
                    USER_TAB_PRIVS_RECD and privilege model.
 @links             docs/09-security/PRIVILEGE-MODEL.md;
                    docs/09-security/SECURITY-ARCHITECTURE-MASTER-v0.02.md;
                    src/00-precheck/000_database_identity.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Effective system privileges available to the connected session.
SELECT privilege FROM session_privs ORDER BY privilege;

-- Roles currently enabled for the session.
SELECT role FROM session_roles ORDER BY role;

-- Object privileges granted to the current user from other owners.
SELECT owner, table_name, privilege, grantable
FROM user_tab_privs_recd
ORDER BY owner, table_name, privilege;
