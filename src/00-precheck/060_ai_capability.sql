/*=============================================================================
 @file              src/00-precheck/060_ai_capability.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-01/10/16
 @workstream        WS-03 Oracle capability / WS-11 AI/ML/RAG/Agents
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Inventory visible Select AI and AI Agent package objects/procedures
                    without creating profiles, credentials, agents, tasks or invoking a model.
 @business_impact   Establishes what the production database exposes before the project designs
                    AI-assisted retrieval/reasoning, avoiding unsupported or tier-incompatible assumptions.
 @objects           Reads ALL_OBJECTS and ALL_PROCEDURES for DBMS_CLOUD_AI and DBMS_CLOUD_AI_AGENT.
 @dependencies      Dictionary visibility to listed packages.
 @upstream          CORE-00 identity and feature inventory.
 @downstream        CORE-10 AI architecture, agent/tool templates and CORE-16 validation design.
 @d3ka_role         AI capability around D3KA knowledge; no cell/graph data is accessed here.
 @d3ka_links        Future AI uses graph/vector/relational retrieval over D3KA, subject to policy/provenance.
 @ai_role           Discovery only. No credential, provider, profile, task, tool, agent or LLM call.
 @security          Explicitly avoids reading/creating credentials. Procedure names are metadata only.
                    Package visibility does not imply the session should be granted execution.
 @performance       Small dictionary scans only; no external model/network request.
 @transaction       SELECT only; no persistent state or commit.
 @idempotency       Repeatable; results may change after Oracle service upgrades/privilege changes.
 @failure_modes     Empty/incomplete visibility means NOT PROVEN. Procedure presence does not prove
                    provider support, network access, quota, credential configuration or successful inference.
 @rollback_recovery None; read-only.
 @tests             tests/AI/AI-001..005 are later architecture/safety tests; provider/profile tests require
                    an approved CORE-10 change and must not be inferred from this discovery.
 @evidence          CORE-01 AI package discovery; CORE-10/16 readiness inputs.
 @references        Oracle Autonomous AI Database Select AI and DBMS_CLOUD_AI_AGENT documentation
                    for the installed Oracle AI Database 26ai service.
 @links             docs/07-ai-ml/AI-ML-RAG-AGENTS-MASTER-SPEC-v0.02.md;
                    src/11-ai/1150_select_ai_profile_template.sql;
                    src/11-ai/1160_agent_program_director_template.sql
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Package object visibility only; this does not create or invoke AI functionality.
SELECT owner, object_name, object_type, status
FROM all_objects
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT')
ORDER BY owner, object_name, object_type;

-- Public procedure inventory is used to compare installed API surface to versioned documentation.
SELECT owner, object_name, procedure_name
FROM all_procedures
WHERE object_name IN ('DBMS_CLOUD_AI','DBMS_CLOUD_AI_AGENT')
ORDER BY owner, object_name, procedure_name;
