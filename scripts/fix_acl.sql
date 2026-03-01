-- =========================================================================
-- CORRECTION ACL ORACLE : Autoriser les appels HTTP depuis APEX/ORDS
-- Exécuter en tant que SYS
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\acl_result.txt

-- Creer l'ACL pour autoriser les connexions HTTP sortantes
BEGIN
    -- Supprimer l'ancien ACE si existe
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
            host => '192.168.108.134',
            ace  => xs$ace_type(
                privilege_list => xs$name_list('http'),
                principal_name => 'ORASSUIT_DEV1',
                principal_type => xs_acl.ptype_db
            )
        );
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
            host => '192.168.108.134',
            ace  => xs$ace_type(
                privilege_list => xs$name_list('http'),
                principal_name => 'ORASSUIT_DEV2',
                principal_type => xs_acl.ptype_db
            )
        );
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
    
    BEGIN
        DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
            host => '192.168.108.134',
            ace  => xs$ace_type(
                privilege_list => xs$name_list('http'),
                principal_name => 'ORASSADM',
                principal_type => xs_acl.ptype_db
            )
        );
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    BEGIN
        DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
            host => '192.168.108.134',
            ace  => xs$ace_type(
                privilege_list => xs$name_list('http'),
                principal_name => 'APEX_230200',
                principal_type => xs_acl.ptype_db
            )
        );
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    DBMS_OUTPUT.PUT_LINE('ACL: Anciens ACE supprimes');
END;
/

-- Autoriser les connexions HTTP pour tous les schemas concernes
BEGIN
    -- ORASSUIT_DEV1 (Ahmed)
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '192.168.108.134',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV1',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV1: OK');
END;
/

BEGIN
    -- ORASSUIT_DEV2 (Sara)
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '192.168.108.134',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV2',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSUIT_DEV2: OK');
END;
/

BEGIN
    -- ORASSADM (Admin)
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '192.168.108.134',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSADM',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL ORASSADM: OK');
END;
/

BEGIN
    -- APEX engine (le schema interne APEX)
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '192.168.108.134',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'APEX_230200',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL APEX_230200: OK');
END;
/

-- Autoriser aussi pour localhost
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'localhost',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV1',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'localhost',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV2',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'localhost',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSADM',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'localhost',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'APEX_230200',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL localhost: OK pour tous');
END;
/

-- Autoriser pour * (tous les hosts) - plus permissif en dev
BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV1',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'ORASSUIT_DEV2',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace  => xs$ace_type(
            privilege_list => xs$name_list('http', 'connect', 'resolve'),
            principal_name => 'APEX_230200',
            principal_type => xs_acl.ptype_db
        )
    );
    DBMS_OUTPUT.PUT_LINE('ACL wildcard *: OK');
END;
/

COMMIT;
DBMS_OUTPUT.PUT_LINE('=== ACL CONFIGURATION TERMINEE ===');

SPOOL OFF
EXIT;
