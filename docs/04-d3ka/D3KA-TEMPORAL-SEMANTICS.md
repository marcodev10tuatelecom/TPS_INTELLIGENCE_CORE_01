# TPS D3KA — Temporal Semantics v0.01

## Four relevant times

1. `valid_from/valid_to`: when a business relationship is valid.
2. `observed_at`: when an external fact/event was observed.
3. `recorded_at`: when TPSDBCORE01 learned/persisted it.
4. `event_time`: for append-oriented events.

## Rules

- historically significant state is ended/superseded instead of overwritten;
- corrections preserve old evidence and link to correction/supersession where needed;
- a query must state whether it asks business-time truth, knowledge-time truth or current recorded state;
- AI/RAG queries with historical questions must apply temporal filters before producing claims.

## Example

A right may be valid 08:00–18:00 and be recorded at 08:05. A query “what was legally valid at 08:02?” differs from “what did the database know at 08:02?”. Both must be representable.

## Scheduling

Schedule item intervals use half-open semantics `[start_at,end_at)` to avoid double ownership at exact boundaries. Overlap policies depend on schedule class/precedence and are validated separately.
