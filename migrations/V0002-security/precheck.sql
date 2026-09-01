-- V0002 SECURITY PRECHECK | R0
SELECT role FROM dba_roles WHERE role LIKE 'TPS_MEDIA_%' ORDER BY role;
SELECT grantee,granted_role FROM dba_role_privs WHERE grantee LIKE 'TPS_MEDIA_%' ORDER BY grantee,granted_role;
SELECT grantee,owner,table_name,privilege FROM dba_tab_privs WHERE grantee LIKE 'TPS_MEDIA_%' ORDER BY grantee,owner,table_name,privilege;
