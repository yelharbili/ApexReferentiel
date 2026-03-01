-- =========================================================================
-- SCRIPT DE REINITIALISATION FORCEE DU COMPTE APEX "AHMED"
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\unlock_ahmed_v2.txt

BEGIN
    -- Utiliser directement l'administration globale de l'instance APEX
    APEX_INSTANCE_ADMIN.UNRESTRICT_SCHEMA(p_schema => 'ORASSUIT_DEV1');
    
    -- Le mot de passe par defaut sera "Ahmed2026"
    -- Pour eviter les problemes de contexte, on associe l'ID exact
    FOR rec IN (SELECT workspace_id FROM apex_spaces WHERE workspace = 'ORASSUIT_DEV1')
    LOOP
        wwv_flow_api.set_security_group_id(rec.workspace_id);
    END LOOP;

    -- Debloquer et modifier
    FOR r_user IN (SELECT user_id FROM vw_apex_workspace_users WHERE user_name = 'AHMED' AND workspace_name = 'ORASSUIT_DEV1')
    LOOP
        apex_util.unlock_account(p_user_name => 'AHMED');
        apex_util.edit_user(
            p_user_id       => r_user.user_id,
            p_user_name     => 'AHMED',
            p_web_password  => 'Ahmed2026',
            p_new_password  => 'Ahmed2026'
        );
        DBMS_OUTPUT.PUT_LINE('Utilisateur AHMED debloque et reinitialise.');
    END LOOP;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/
SPOOL OFF
EXIT;
