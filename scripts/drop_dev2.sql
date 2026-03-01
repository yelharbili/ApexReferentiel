-- =========================================================================
-- SUPPRESSION DU WORKSPACE APEX ORASSUIT_DEV2 ET DU SCHEMA ORACLE ASOCIE
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\drop_dev2.txt

BEGIN
    -- Suppression du Workspace APEX "ORASSUIT_DEV2" (Ceci supprime les utilisateurs APEX lies comme SARA)
    APEX_INSTANCE_ADMIN.REMOVE_WORKSPACE(
        p_workspace => 'ORASSUIT_DEV2', 
        p_drop_users => 'N', 
        p_drop_tablespaces => 'N'
    );
    DBMS_OUTPUT.PUT_LINE('SUCCES : Workspace APEX ORASSUIT_DEV2 et ses utilisateurs internes supprimes.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT WORKSPACE : ' || SQLERRM);
END;
/

---------------------------------------------------------------------------
-- Suppression du Schema Oracle "ORASSUIT_DEV2" (et tout son contenu)
---------------------------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'DROP USER ORASSUIT_DEV2 CASCADE';
    DBMS_OUTPUT.PUT_LINE('SUCCES : Schema Oracle ORASSUIT_DEV2 supprime (CASCADE).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AVERTISSEMENT SCHEMA : ' || SQLERRM);
END;
/

COMMIT;
SPOOL OFF
EXIT;
