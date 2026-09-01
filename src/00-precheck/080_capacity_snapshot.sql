-- TPSDBCORE01 | CORE-00/17 | R0 READ ONLY
SELECT metric_name, value
FROM v$sysmetric
WHERE metric_name IN ('Database CPU Time Ratio','Executions Per Sec','Physical Reads Per Sec','Physical Writes Per Sec')
ORDER BY metric_name;

SELECT tablespace_name, used_space, tablespace_size, used_percent
FROM dba_tablespace_usage_metrics
ORDER BY tablespace_name;
