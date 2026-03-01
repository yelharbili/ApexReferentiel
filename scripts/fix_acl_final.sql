-- =========================================================================
-- ACL COMPLET : Tous les schemas identifies + APEX_230200
-- Executer en tant que SYS sur ORASSUITPDB
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\acl_final_result.txt

-- ORASSADM (schema du workspace ORASSUIT + parsing schema des devs)
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSADM',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSADM *: OK');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ACL ORASSADM *: ' || SQLERRM);
END;
/

-- APEX_230200 (moteur APEX qui fait les appels HTTP)
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'APEX_230200',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL APEX_230200 *: OK');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ACL APEX_230200 *: ' || SQLERRM);
END;
/

-- ORASSUIT_DEV1 (dev Ahmed)
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV1',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV1 *: OK');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV1 *: ' || SQLERRM);
END;
/

-- ORASSUIT_DEV2 (dev Sara)
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV2',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV2 *: OK');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV2 *: ' || SQLERRM);
END;
/

COMMIT;
DBMS_OUTPUT.PUT_LINE('=== ACL FINAL OK ===');

-- Verification : lister les ACL en place
SELECT host, principal, privilege, is_grant
  FROM dba_host_aces
 WHERE principal IN ('ORASSADM','APEX_230200','ORASSUIT_DEV1','ORASSUIT_DEV2')
 ORDER BY principal, host;

SPOOL OFF
EXIT;
