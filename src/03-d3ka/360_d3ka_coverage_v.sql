-- TPSDBCORE01 | CORE-15 | R1 VIEW | NOT DEPLOYED
CREATE OR REPLACE VIEW tps_d3ka_coverage_v AS
SELECT
    COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END) AS eligible_fact_classes,
    COUNT(CASE WHEN fc.d3ka_eligible=1 AND EXISTS (
        SELECT 1 FROM tps_fact_class_mapping m
        WHERE m.fact_class_id=fc.fact_class_id
          AND m.representation_class='D3KA_RELATION'
          AND m.implementation_status IN ('IMPLEMENTED','VALIDATED','CERTIFIED')
    ) THEN 1 END) AS represented_fact_classes,
    CASE
      WHEN COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END)=0 THEN 0
      ELSE ROUND(
        COUNT(CASE WHEN fc.d3ka_eligible=1 AND EXISTS (
            SELECT 1 FROM tps_fact_class_mapping m
            WHERE m.fact_class_id=fc.fact_class_id
              AND m.representation_class='D3KA_RELATION'
              AND m.implementation_status IN ('IMPLEMENTED','VALIDATED','CERTIFIED')
        ) THEN 1 END)
        / COUNT(CASE WHEN fc.d3ka_eligible=1 THEN 1 END), 6)
    END AS d3ka_logical_coverage
FROM tps_fact_class fc
WHERE fc.lifecycle_state='ACTIVE';
