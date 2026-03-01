-- =========================================================================
-- SUPPRESSION DE L'UTILISATEUR AHMED ET DU SCHEMA ORASSUIT_DEV1
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\drop_ahmed_dev1.txt

DECLARE
    v_workspace_id NUMBER;
BEGIN
    ---------------------------------------------------------------------------
    -- 1. Suppression de l'utilisateur APEX "AHMED"
    ---------------------------------------------------------------------------
    BEGIN
        SELECT workspace_id INTO v_workspace_id 
          FROM apex_workspaces 
         WHERE workspace_name = 'ORASSUIT_DEV1';
         
        wwv_flow_api.set_security_group_id(v_workspace_id);
        
        APEX_UTIL.REMOVE_USER(p_user_name => 'AHMED');
        DBMS_OUTPUT.PUT_LINE('SUCCES : Utilisateur APEX AHMED supprime.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('INFO : Workspace ORASSUIT_DEV1 ou utilisateur non trouve dans APEX.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT APEX : ' || SQLERRM);
    END;

    ---------------------------------------------------------------------------
    -- 2. Suppression du Workspace APEX "ORASSUIT_DEV1"
    ---------------------------------------------------------------------------
    BEGIN
        APEX_INSTANCE_ADMIN.REMOVE_WORKSPACE(
            p_workspace => 'ORASSUIT_DEV1', 
            p_drop_users => 'N', 
            p_drop_tablespaces => 'N'
        );
        DBMS_OUTPUT.PUT_LINE('SUCCES : Workspace APEX ORASSUIT_DEV1 supprime.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT WORKSPACE : ' || SQLERRM);
    END;

END;
/

---------------------------------------------------------------------------
-- 3. Suppression du Schema Oracle "ORASSUIT_DEV1" (et tout son contenu)
---------------------------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ORASSUIT_DEV1 CASCADE';
    DBMS_OUTPUT.PUT_LINE('SUCCES : Schema Oracle ORASSUIT_DEV1 supprime (CASCADE).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT SCHEMA : ' || SQLERRM);
END;
/

COMMIT;
SPOOL OFF
EXIT;
