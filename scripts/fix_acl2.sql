-- Ajouter le schema ORASSUIT aux ACL
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\acl2_result.txt

BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT: OK');
END;
/

-- Aussi pour 192.168.108.134 specifiquement
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '192.168.108.134',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT 192.168.108.134: OK');
END;
/

COMMIT;
SPOOL OFF
EXIT;
