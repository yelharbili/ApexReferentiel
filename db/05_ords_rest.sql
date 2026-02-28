-- =========================================================================
-- ORASSADM - EXPOSITION DES API REST VIA ORDS
-- =========================================================================
-- Ce script active ORDS sur le schema ORASSADM et cree des modules REST
-- pour que les developpeurs APEX puissent consommer les API JSON en HTTP.
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\ords_result.txt

-- =============================================
-- ETAPE 1 : Activer ORDS sur le schema ORASSADM
-- =============================================
BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => 'ORASSADM',
        p_url_mapping_type    => 'BASE_PATH',
        p_url_mapping_pattern => 'api-assurance',
        p_auto_rest_auth      => FALSE
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ORDS SCHEMA: Active avec succes (base_path = api-assurance)');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ORDS SCHEMA ERREUR: ' || SQLERRM);
END;
/

-- =============================================
-- ETAPE 2 : Module REST - CLIENTS
-- URL de base: /ords/api-assurance/clients/
-- =============================================
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'module.clients',
        p_base_path      => '/clients/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'API REST pour la gestion des clients assurance'
    );
    DBMS_OUTPUT.PUT_LINE('MODULE CLIENTS: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('MODULE CLIENTS ERREUR: ' || SQLERRM);
END;
/

-- GET /clients/ -> Liste tous les clients (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.clients',
        p_pattern        => '.',
        p_comments       => 'Liste de tous les clients'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.clients',
        p_pattern        => '.',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_clients.get_clients_json(:ville, :type_client); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.clients',
        p_pattern            => '.',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /clients/: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /clients/ ERREUR: ' || SQLERRM);
END;
/

-- GET /clients/:id -> Detail d'un client (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.clients',
        p_pattern        => ':id',
        p_comments       => 'Detail d un client par ID'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.clients',
        p_pattern        => ':id',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_clients.get_client_by_id_json(:id); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.clients',
        p_pattern            => ':id',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /clients/:id: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /clients/:id ERREUR: ' || SQLERRM);
END;
/

-- =============================================
-- ETAPE 3 : Module REST - CONTRATS
-- URL de base: /ords/api-assurance/contrats/
-- =============================================
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'module.contrats',
        p_base_path      => '/contrats/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'API REST pour la gestion des contrats/polices assurance'
    );
    DBMS_OUTPUT.PUT_LINE('MODULE CONTRATS: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('MODULE CONTRATS ERREUR: ' || SQLERRM);
END;
/

-- GET /contrats/ -> Liste tous les contrats (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.contrats',
        p_pattern        => '.',
        p_comments       => 'Liste de tous les contrats'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.contrats',
        p_pattern        => '.',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_contrats.get_contrats_json(NULL, :statut); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.contrats',
        p_pattern            => '.',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /contrats/: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /contrats/ ERREUR: ' || SQLERRM);
END;
/

-- GET /contrats/:id -> Detail d'un contrat (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.contrats',
        p_pattern        => ':id',
        p_comments       => 'Detail d un contrat par ID'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.contrats',
        p_pattern        => ':id',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_contrats.get_contrat_detail_json(:id); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.contrats',
        p_pattern            => ':id',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /contrats/:id: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /contrats/:id ERREUR: ' || SQLERRM);
END;
/

-- =============================================
-- ETAPE 4 : Module REST - SINISTRES
-- URL de base: /ords/api-assurance/sinistres/
-- =============================================
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'module.sinistres',
        p_base_path      => '/sinistres/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'API REST pour la gestion des sinistres'
    );
    DBMS_OUTPUT.PUT_LINE('MODULE SINISTRES: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('MODULE SINISTRES ERREUR: ' || SQLERRM);
END;
/

-- GET /sinistres/ -> Liste tous les sinistres (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.sinistres',
        p_pattern        => '.',
        p_comments       => 'Liste de tous les sinistres'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.sinistres',
        p_pattern        => '.',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_sinistres.get_sinistres_json(:statut); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.sinistres',
        p_pattern            => '.',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /sinistres/: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /sinistres/ ERREUR: ' || SQLERRM);
END;
/

-- GET /sinistres/:id -> Detail d'un sinistre (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.sinistres',
        p_pattern        => ':id',
        p_comments       => 'Detail d un sinistre par ID'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.sinistres',
        p_pattern        => ':id',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_sinistres.get_sinistre_detail_json(:id); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.sinistres',
        p_pattern            => ':id',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /sinistres/:id: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /sinistres/:id ERREUR: ' || SQLERRM);
END;
/

-- =============================================
-- ETAPE 5 : Module REST - DASHBOARD
-- URL de base: /ords/api-assurance/dashboard/
-- =============================================
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'module.dashboard',
        p_base_path      => '/dashboard/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'API REST pour le tableau de bord KPI'
    );
    DBMS_OUTPUT.PUT_LINE('MODULE DASHBOARD: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('MODULE DASHBOARD ERREUR: ' || SQLERRM);
END;
/

-- GET /dashboard/kpi -> KPI globaux (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'kpi',
        p_comments       => 'Indicateurs KPI globaux'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'kpi',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_dashboard.get_kpi_json; END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.dashboard',
        p_pattern            => 'kpi',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/kpi: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/kpi ERREUR: ' || SQLERRM);
END;
/

-- GET /dashboard/primes-par-branche -> Ventilation primes (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'primes-par-branche',
        p_comments       => 'Ventilation des primes par branche assurance'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'primes-par-branche',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_dashboard.get_primes_par_branche_json; END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.dashboard',
        p_pattern            => 'primes-par-branche',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/primes-par-branche: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/primes-par-branche ERREUR: ' || SQLERRM);
END;
/

-- GET /dashboard/sinistres-par-mois -> Evolution sinistres (JSON)
BEGIN
    ORDS.DEFINE_TEMPLATE(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'sinistres-par-mois',
        p_comments       => 'Evolution mensuelle des sinistres'
    );
    ORDS.DEFINE_HANDLER(
        p_module_name    => 'module.dashboard',
        p_pattern        => 'sinistres-par-mois',
        p_method         => 'GET',
        p_source_type    => 'plsql/block',
        p_source         => 'BEGIN :result := pkg_api_dashboard.get_sinistres_par_mois_json(:annee); END;',
        p_items_per_page => 0
    );
    ORDS.DEFINE_PARAMETER(
        p_module_name        => 'module.dashboard',
        p_pattern            => 'sinistres-par-mois',
        p_method             => 'GET',
        p_name               => 'result',
        p_bind_variable_name => 'result',
        p_source_type        => 'RESPONSE',
        p_param_type         => 'STRING',
        p_access_method      => 'OUT'
    );
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/sinistres-par-mois: Cree');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GET /dashboard/sinistres-par-mois ERREUR: ' || SQLERRM);
END;
/

COMMIT;

DBMS_OUTPUT.PUT_LINE('=== ORDS FINALISE ===');
DBMS_OUTPUT.PUT_LINE('Base URL: http://192.168.108.134:8080/ords/api-assurance/');
DBMS_OUTPUT.PUT_LINE('Endpoints:');
DBMS_OUTPUT.PUT_LINE('  GET /clients/');
DBMS_OUTPUT.PUT_LINE('  GET /clients/:id');
DBMS_OUTPUT.PUT_LINE('  GET /contrats/');
DBMS_OUTPUT.PUT_LINE('  GET /contrats/:id');
DBMS_OUTPUT.PUT_LINE('  GET /sinistres/');
DBMS_OUTPUT.PUT_LINE('  GET /sinistres/:id');
DBMS_OUTPUT.PUT_LINE('  GET /dashboard/kpi');
DBMS_OUTPUT.PUT_LINE('  GET /dashboard/primes-par-branche');
DBMS_OUTPUT.PUT_LINE('  GET /dashboard/sinistres-par-mois');

SPOOL OFF
EXIT;
