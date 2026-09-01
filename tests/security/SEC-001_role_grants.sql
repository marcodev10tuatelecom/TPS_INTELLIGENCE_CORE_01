-- SEC-001 | inspect grants to runtime roles | R0
SELECT grantee,privilege,owner,table_name,grantable
FROM dba_tab_privs
WHERE grantee IN ('TPS_MEDIA_RUNTIME','TPS_MEDIA_API','TPS_MEDIA_INGEST','TPS_MEDIA_AI','TPS_MEDIA_ANALYTICS','TPS_MEDIA_AUDITOR')
ORDER BY grantee,owner,table_name,privilege;
