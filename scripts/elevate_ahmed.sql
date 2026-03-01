-- =========================================================================
-- PROMOUVOIR AHMED EN TANT QUE DEVELOPPEUR/ADMINISTRATEUR DANS APEX
-- (Directement via le schema APEX pour eviter les problemes d'API)
-- =========================================================================
SET SERVEROUTPUT ON
SPOOL d:\ProjetApexOrassuit\elevate_ahmed.txt

BEGIN
    UPDATE apex_230200.wwv_flow_fnd_user
       SET allow_app_building_yn = 'Y',
           allow_sql_workshop_yn = 'Y',
           allow_team_development_yn = 'Y',
           allow_access_to_schemas = 'ORASSADM'
     WHERE user_name = 'AHMED'
       AND security_group_id = (
           SELECT provisioning_company_id 
             FROM apex_230200.wwv_flow_companies 
            WHERE short_name = 'ORASSUIT_DEV1'
       );
       
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SUCCES : Le compte AHMED a ete promu Developpeur avec acces a App Builder et SQL.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERREUR : Utilisateur AHMED introuvable dans ce workspace.');
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR FATALE : ' || SQLERRM);
        ROLLBACK;
END;
/
SPOOL OFF
EXIT;
