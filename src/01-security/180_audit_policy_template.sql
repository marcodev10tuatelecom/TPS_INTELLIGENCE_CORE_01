-- TPSDBCORE01 | CORE-12/18 | R3 AUDIT CONFIG | NOT DEPLOYED
-- Audit policy name is supplied only after CORE-01/12 validates Autonomous naming/privileges.
CREATE AUDIT POLICY &TPS_AUDIT_POLICY_NAME
  ACTIONS INSERT ON tps_relation,
          UPDATE ON tps_relation,
          DELETE ON tps_relation,
          INSERT ON tps_right_grant,
          UPDATE ON tps_right_grant,
          DELETE ON tps_right_grant,
          INSERT ON tps_policy,
          UPDATE ON tps_policy,
          DELETE ON tps_policy,
          EXECUTE ON tps_d3ka_pkg,
          EXECUTE ON tps_policy_engine_pkg,
          EXECUTE ON tps_rights_pkg;

AUDIT POLICY &TPS_AUDIT_POLICY_NAME;
