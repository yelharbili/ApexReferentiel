-- =========================================================================
-- SCRIPT DE REINITIALISATION FORCEE DU COMPTE APEX "AHMED"
-- (A executer sur la base de donnees via SYS ou un DBA)
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\unlock_ahmed.txt

DECLARE
    v_workspace_id NUMBER;
BEGIN
    -- 1. Obtenir l'ID du Workspace ORASSUIT_DEV1
    SELECT workspace_id INTO v_workspace_id
      FROM apex_workspaces
     WHERE workspace_name = 'ORASSUIT_DEV1';
    
    -- 2. S'attacher au contexte du Workspace (Essentiel pour utiliser APEX_UTIL)
    wwv_flow_api.set_security_group_id(v_workspace_id);
    
    -- 3. Utiliser l'API APEX pour modifier le mot de passe et debloquer le compte
    -- On doit d'abord s'assurer que le compte n'est plus bloque administrativement
    apex_util.unlock_account(p_user_name => 'AHMED');
    
    -- On force ensuite un nouveau mot de passe robuste ("Ahmed2026_Securise")
    apex_util.edit_user(
        p_user_id       => apex_util.get_user_id(p_username => 'AHMED'),
        p_user_name     => 'AHMED',
        p_web_password  => 'Ahmed2026_Securise', -- Nouveau mot de passe a saisir lors de la connexion
        p_new_password  => 'Ahmed2026_Securise'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SUCCES : Le compte AHMED dans ORASSUIT_DEV1 a ete debloque.');
    DBMS_OUTPUT.PUT_LINE('Le nouveau mot de passe est : Ahmed2026_Securise');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERREUR : ' || SQLERRM);
END;
/
SPOOL OFF
EXIT;
