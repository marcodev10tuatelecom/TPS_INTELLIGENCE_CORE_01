-- SEC-002 | application roles must not inherit broad admin roles | R0
SELECT grantee,granted_role
FROM dba_role_privs
WHERE grantee IN ('TPS_MEDIA_RUNTIME','TPS_MEDIA_API','TPS_MEDIA_INGEST','TPS_MEDIA_AI','TPS_MEDIA_ANALYTICS','TPS_MEDIA_AUDITOR')
  AND granted_role IN ('DBA','PDB_DBA','DATAPUMP_EXP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE');
