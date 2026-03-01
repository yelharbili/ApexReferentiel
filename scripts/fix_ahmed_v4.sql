-- =========================================================================
-- ULTIME SCRIPT POUR DEBLOQUER AHMED
-- On tape directement dans le schema APEX 23.2
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\unlock_ahmed_v4.txt

DECLARE
    v_workspace_id NUMBER;
BEGIN
    -- Obtenir l'ID depuis les tables internes APEX
    SELECT provisioning_company_id INTO v_workspace_id
      FROM apex_230200.wwv_flow_companies
     WHERE short_name = 'ORASSUIT_DEV1';

    -- Initialiser le contexte
    wwv_flow_api.set_security_group_id(v_workspace_id);

    -- Changer le mot de passe et debloquer
    APEX_UTIL.UNLOCK_ACCOUNT(p_user_name => 'AHMED');
    
    APEX_UTIL.EDIT_USER(
        p_user_id       => APEX_UTIL.GET_USER_ID('AHMED'),
        p_user_name     => 'AHMED',
        p_web_password  => 'Ahmed2026',
        p_new_password  => 'Ahmed2026'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SUCCES : Compte AHMED debloque et mdp a jour (Ahmed2026).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR FATALE : ' || SQLERRM);
END;
/
SPOOL OFF
EXIT;
