SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\drop_ahmed_dev1_v2.txt

BEGIN
    -- Suppression du Workspace APEX "ORASSUIT_DEV1" (Ceci supprime les utilisateurs APEX lies comme AHMED)
    APEX_INSTANCE_ADMIN.REMOVE_WORKSPACE(
        p_workspace => 'ORASSUIT_DEV1', 
        p_drop_users => 'N', 
        p_drop_tablespaces => 'N'
    );
    DBMS_OUTPUT.PUT_LINE('SUCCES : Workspace APEX ORASSUIT_DEV1 et ses utilisateurs internes supprimes.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT WORKSPACE : ' || SQLERRM);
END;
/

COMMIT;
SPOOL OFF
EXIT;
