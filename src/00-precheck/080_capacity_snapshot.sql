/*=============================================================================
 @file              src/00-precheck/080_capacity_snapshot.sql
 @project           TPS MEDIA INTELLIGENCE FABRIC CORE
 @database          TPSDBCORE01 / TPS_INTELLIGENCE_CORE_01
 @environment       PRODUCTION
 @oracle_target     Oracle AI Database 26ai
 @gate              CORE-00/17
 @workstream        WS-03 Oracle capability / WS-20 Performance/capacity
 @source_state      SOURCE_READY
 @production_state  READ_ONLY_NOT_DEPLOYED
 @reversibility     READ_ONLY
 @purpose           Capture selected runtime workload metrics and tablespace utilization as
                    a point-in-time production capacity baseline before feature deployment.
 @business_impact   Establishes measured evidence for sizing D3KA/graph/vector/AI workloads and
                    deciding when the present capacity tier must be increased or migrated.
 @objects           Reads V$SYSMETRIC and DBA_TABLESPACE_USAGE_METRICS only.
 @dependencies      Dictionary/performance-view privileges and available metric names.
 @upstream          Connected production database under normal/known operating context.
 @downstream        CORE-17 baseline, capacity/cost model, index/vector/graph performance planning.
 @d3ka_role         NONE directly; capacity evidence supports all D3KA/graph/vector layers.
 @d3ka_links        Future relation cardinality/vector growth forecasts must be compared to this baseline.
 @ai_role           AI workload sizing input only; no model call.
 @security          Infrastructure performance/storage metadata only; no business rows selected.
 @performance       The probe itself reads dynamic performance/usage views and should be lightweight;
                    it is not a substitute for AWR-like longitudinal analysis or workload replay.
 @transaction       SELECT only; no DML/DDL/commit/locks.
 @idempotency       Repeatable but deliberately time-dependent; each run is a new observation.
 @failure_modes     Metric names can vary by service/release and privileges may restrict views.
                    Missing rows mean metric NOT OBSERVED, not zero usage. Snapshot must include timestamp
                    in the external evidence package to be meaningful.
 @rollback_recovery None; read-only.
 @tests             Performance plans PERF-001..005 use later workload-specific measurements.
 @evidence          CORE-00 baseline snapshot; CORE-17 capacity/performance evidence.
 @references        Oracle AI Database 26ai Reference: V$SYSMETRIC and DBA_TABLESPACE_USAGE_METRICS.
 @links             docs/10-performance/PERFORMANCE-CAPACITY-MASTER-v0.02.md;
                    docs/10-performance/CAPACITY-COST-MODEL.md;
                    tests/performance/
 @owner             TPS MEDIA DATABASE ENGINEERING
 @change_history    v0.02 2026-09-01 — full embedded documentation; queries unchanged.
=============================================================================*/

-- Selected current system workload indicators. Values are observational and time-sensitive.
SELECT metric_name, value
FROM v$sysmetric
WHERE metric_name IN ('Database CPU Time Ratio','Executions Per Sec','Physical Reads Per Sec','Physical Writes Per Sec')
ORDER BY metric_name;

-- Tablespace utilization baseline. No storage setting is changed.
SELECT tablespace_name, used_space, tablespace_size, used_percent
FROM dba_tablespace_usage_metrics
ORDER BY tablespace_name;
