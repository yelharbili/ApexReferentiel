-- =========================================================================
-- PL/SQL SIMPLE POUR DEBLOQUER LE COMPTE APEX "AHMED"
-- (EXECUTION VIA SYSDBA)
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\unlock_ahmed_v3.txt

DECLARE
    v_workspace_id NUMBER;
BEGIN
    -- Obtenir l'ID du Workspace a partir de la vue administrateur globale
    SELECT workspace_id INTO v_workspace_id 
      FROM apex_workspaces 
     WHERE workspace_name = 'ORASSUIT_DEV1';

    -- Se placer dans le contexte de ce Workspace (Obligatoire pour config APEX)
    wwv_flow_api.set_security_group_id(v_workspace_id);

    -- Changer le mot de passe (ce procedure le debloque aussi generalement)
    APEX_UTIL.RESET_PASSWORD(
        p_user_name => 'AHMED',
        p_old_password => NULL,
        p_new_password => 'Ahmed2026'
    );
    
    -- Forcer le deblocage au cas ou
    APEX_UTIL.UNLOCK_ACCOUNT(p_user_name => 'AHMED');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('COMPTE AHMED DEBLOQUE PROPREMENT. MDP: Ahmed2026');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR : ' || SQLERRM);
END;
/
SPOOL OFF
EXIT;
