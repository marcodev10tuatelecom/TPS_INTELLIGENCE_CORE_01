-- TPSDBCORE01 | CORE-01/02 | R0 READ ONLY
SELECT privilege FROM session_privs ORDER BY privilege;
SELECT role FROM session_roles ORDER BY role;
SELECT owner, table_name, privilege, grantable
FROM user_tab_privs_recd
ORDER BY owner, table_name, privilege;
