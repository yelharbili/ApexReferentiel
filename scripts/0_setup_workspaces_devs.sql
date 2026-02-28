-- =========================================================================
-- PREPARATION DU SERVEUR : Creation des Workspaces APEX pour chaque Dev
-- =========================================================================
-- A executer UNE SEULE FOIS par l'Admin (vous) sur 192.168.108.134
-- Connexion : SYS AS SYSDBA ou ADMIN APEX
-- =========================================================================

-- =============================================
-- ETAPE 1 : Creer les schemas Oracle pour les devs
-- =============================================

-- Schema pour Dev 1 (Ahmed)
CREATE USER ORASSUIT_DEV1 IDENTIFIED BY Dev1_2026
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO ORASSUIT_DEV1;

-- Schema pour Dev 2 (Sara) 
CREATE USER ORASSUIT_DEV2 IDENTIFIED BY Dev2_2026
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE TO ORASSUIT_DEV2;

-- =============================================
-- ETAPE 2 : Donner acces aux API de ORASSADM
-- =============================================
-- Les devs peuvent LIRE les tables et EXECUTER les packages
-- mais ils ne peuvent PAS modifier la structure (INSERT/UPDATE/DELETE)

-- Pour Dev 1
GRANT SELECT ON ORASSADM.ASS_CLIENTS TO ORASSUIT_DEV1;
GRANT SELECT ON ORASSADM.ASS_CONTRATS TO ORASSUIT_DEV1;
GRANT EXECUTE ON ORASSADM.PKG_API_CONTRATS TO ORASSUIT_DEV1;

-- Pour Dev 2
GRANT SELECT ON ORASSADM.ASS_CLIENTS TO ORASSUIT_DEV2;
GRANT SELECT ON ORASSADM.ASS_CONTRATS TO ORASSUIT_DEV2;
GRANT EXECUTE ON ORASSADM.PKG_API_CONTRATS TO ORASSUIT_DEV2;

-- =============================================
-- ETAPE 3 : Creer les Workspaces APEX pour les devs
-- =============================================
-- A executer en tant qu'ADMIN APEX (Internal Workspace)

BEGIN
    -- Workspace pour Dev 1
    APEX_INSTANCE_ADMIN.ADD_WORKSPACE(
        p_workspace      => 'ORASSUIT_DEV1',
        p_primary_schema => 'ORASSUIT_DEV1',
        p_additional_schemas => 'ORASSADM'
    );
    
    -- Creer l'utilisateur APEX pour Dev 1
    APEX_UTIL.SET_WORKSPACE('ORASSUIT_DEV1');
    APEX_UTIL.CREATE_USER(
        p_user_name    => 'AHMED',
        p_web_password => 'Ahmed_2026',
        p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'
    );
END;
/

BEGIN
    -- Workspace pour Dev 2
    APEX_INSTANCE_ADMIN.ADD_WORKSPACE(
        p_workspace      => 'ORASSUIT_DEV2',
        p_primary_schema => 'ORASSUIT_DEV2',
        p_additional_schemas => 'ORASSADM'
    );
    
    -- Creer l'utilisateur APEX pour Dev 2
    APEX_UTIL.SET_WORKSPACE('ORASSUIT_DEV2');
    APEX_UTIL.CREATE_USER(
        p_user_name    => 'SARA',
        p_web_password => 'Sara_2026',
        p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'
    );
END;
/

-- =============================================
-- RESUME DES ACCES
-- =============================================
-- Dev 1 (Ahmed) : http://192.168.108.134:8080/ords/orassuit_dev1
--   Login APEX : AHMED / Ahmed_2026
--   Schema DB  : ORASSUIT_DEV1 / Dev1_2026
--
-- Dev 2 (Sara)  : http://192.168.108.134:8080/ords/orassuit_dev2
--   Login APEX : SARA / Sara_2026
--   Schema DB  : ORASSUIT_DEV2 / Dev2_2026
--
-- Production   : http://192.168.108.134:8080/ords/orassuit
--   Login APEX : ADMIN / P@ssw0rd
--   Schema DB  : ORASSUIT
-- =============================================
