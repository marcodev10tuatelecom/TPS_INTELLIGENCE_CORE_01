-- V0002 SECURITY POSTCHECK | R0
SELECT role FROM dba_roles WHERE role LIKE 'TPS_MEDIA_%' ORDER BY role;
SELECT grantee,owner,table_name,privilege,grantable FROM dba_tab_privs WHERE grantee LIKE 'TPS_MEDIA_%' ORDER BY grantee,owner,table_name,privilege;
@@../../tests/security/SEC-002_no_dba_role.sql
