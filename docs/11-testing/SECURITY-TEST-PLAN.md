# Security Test Plan

Test each runtime role from a separate authenticated session. Verify positive required privileges and negative forbidden privileges. Attempt direct DML against protected core tables, owner-only DDL, cross-domain reads, audit modification and AI tool escalation.

Evidence names user/role/service and records expected Oracle denials without exposing credentials or wallet content.
