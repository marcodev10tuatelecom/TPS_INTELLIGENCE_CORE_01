# ADR-0002 — TPSDBCORE01 is Production

Status: ACCEPTED.

Decision: TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01 is classified PRODUCTION. Always Free is current capacity/billing tier only.

Consequence: all DDL/DML, grants, jobs, AI profiles/agents and OCI mutations use production change control. Tier promotion/migration does not redefine logical authority.
