-- =========================================================================
-- SCHÉMA APEX ORASSUIT : L'INTERFACE (Vues, Synonymes, Appels REST)
-- =========================================================================

-- IMPORTANT : Le schéma APEX ne possède AUCUNE table d'assurance.

-- 1. Création de synonymes (Si APEX veut attaquer les vues/tables directement)
-- APEX doit avoir reçu les GRANT SELECT de la part de ORASSADM.
CREATE SYNONYM orassuit.ass_clients FOR orassadm.ass_clients;
CREATE SYNONYM orassuit.ass_contrats FOR orassadm.ass_contrats;

-- 2. WORKFLOW APEX (OPTION A: REST ORDS)
/* 
Dans le créateur d'application APEX (Environnement de DEV) :

Étape 1 : Créer une REST Data Source
- Nom : API_CONTRATS
- Endpoint URL : http://192.168.108.134:8080/ords/assurances_api/contrats/get_contrats_json
- HTTP Method : GET

Étape 2 : Créer un Report Interactif APEX
- Type : Interactive Report
- Source Type : REST Data Source
- Source : API_CONTRATS

APEX va automatiquement parser le JSON généré par `pkg_api_contrats.get_contrats_json`
et l'afficher sous forme de tableau filtrable, triable, exportable.

Étape 3 : Créer un Formulaire APEX lié à la procédure
- Type : Page de traitement (Bouton Submit)
- Action : Invoquer Endpoint REST : http://192.168.108.134:8080/ords/assurances_api/contrats/creer_contrat
- Mapping : Mapper P2_ID_CLIENT vers `p_id_client` et P2_TYPE vers `p_type`.
*/

-- 3. WORKFLOW APEX (OPTION B : Traitement PL/SQL avec APEX_JSON / APEX_COLLECTION)
-- Si l'option ORDS (REST) n'est pas possible, le développeur APEX fait ceci en PL/SQL :

CREATE OR REPLACE PROCEDURE orassuit.charger_contrats_apex IS
    l_json_clob CLOB;
    l_count NUMBER;
BEGIN
    -- 1. Appel du package du schéma ORASSADM (Nécessite GRANT EXECUTE)
    l_json_clob := orassadm.pkg_api_contrats.get_contrats_json();
    
    -- 2. Parsing du JSON reçu dans APEX
    APEX_JSON.parse(l_json_clob);
    l_count := APEX_JSON.get_count(p_path => '.');
    
    -- 3. Vidage de la collection (Tableau en mémoire UI)
    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION('CONTRATS_COLLECTION');
    
    -- 4. Injection dans la session APEX
    FOR i IN 1..l_count LOOP
        APEX_COLLECTION.ADD_MEMBER(
            p_collection_name => 'CONTRATS_COLLECTION',
            p_c001            => APEX_JSON.get_varchar2(p_path => '[%d].id_contrat', p0 => i),
            p_c002            => APEX_JSON.get_varchar2(p_path => '[%d].type_assurance', p0 => i),
            p_c003            => APEX_JSON.get_varchar2(p_path => '[%d].statut', p0 => i)
        );
    END LOOP;
    
    -- 5. L'écran APEX fera juste : SELECT c001 as ID, c002 as TYPE, c003 as STATUT FROM apex_collections WHERE collection_name = 'CONTRATS_COLLECTION';
END charger_contrats_apex;
/
