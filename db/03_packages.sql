-- =========================================================================
-- ORASSADM - MODELE METIER ASSURANCE
-- Partie 3 : PACKAGES, FONCTIONS ET PROCEDURES (API JSON)
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\metier_result.txt

-- =============================================
-- PACKAGE 1 : PKG_API_CLIENTS
-- API JSON pour la gestion des clients
-- =============================================
CREATE OR REPLACE PACKAGE pkg_api_clients AS
    -- Lister tous les clients (JSON)
    FUNCTION get_clients_json(p_ville IN VARCHAR2 DEFAULT NULL, p_type IN VARCHAR2 DEFAULT NULL) RETURN CLOB;
    -- Obtenir un client par ID (JSON)
    FUNCTION get_client_by_id_json(p_id_client IN NUMBER) RETURN CLOB;
    -- Creer un client
    PROCEDURE creer_client(
        p_type_client    IN VARCHAR2,
        p_nom            IN VARCHAR2,
        p_prenom         IN VARCHAR2,
        p_cin            IN VARCHAR2,
        p_adresse        IN VARCHAR2,
        p_ville          IN VARCHAR2,
        p_telephone      IN VARCHAR2,
        p_email          IN VARCHAR2,
        p_id_agent       IN NUMBER DEFAULT NULL,
        p_retour_json    OUT CLOB
    );
    -- Modifier un client
    PROCEDURE modifier_client(
        p_id_client      IN NUMBER,
        p_nom            IN VARCHAR2,
        p_prenom         IN VARCHAR2,
        p_telephone      IN VARCHAR2,
        p_email          IN VARCHAR2,
        p_retour_json    OUT CLOB
    );
END pkg_api_clients;
/

CREATE OR REPLACE PACKAGE BODY pkg_api_clients AS

    FUNCTION get_clients_json(p_ville IN VARCHAR2 DEFAULT NULL, p_type IN VARCHAR2 DEFAULT NULL) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id_client'      VALUE c.id_client,
                'type_client'    VALUE c.type_client,
                'numero_client'  VALUE c.numero_client,
                'nom'            VALUE c.nom,
                'prenom'         VALUE c.prenom,
                'cin'            VALUE c.cin,
                'ville'          VALUE c.ville,
                'telephone'      VALUE c.telephone,
                'email'          VALUE c.email,
                'agent'          VALUE (SELECT a.nom || ' ' || a.prenom FROM agents a WHERE a.id_agent = c.id_agent),
                'nb_contrats'    VALUE (SELECT COUNT(*) FROM contrats ct WHERE ct.id_client = c.id_client),
                'date_creation'  VALUE TO_CHAR(c.date_creation, 'YYYY-MM-DD')
            ) RETURNING CLOB
        ) INTO l_json
        FROM clients c
        WHERE c.actif = 'O'
          AND (p_ville IS NULL OR UPPER(c.ville) = UPPER(p_ville))
          AND (p_type IS NULL OR c.type_client = p_type);
        
        RETURN NVL(l_json, '[]');
    END get_clients_json;

    FUNCTION get_client_by_id_json(p_id_client IN NUMBER) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'id_client'       VALUE c.id_client,
            'type_client'     VALUE c.type_client,
            'numero_client'   VALUE c.numero_client,
            'nom'             VALUE c.nom,
            'prenom'          VALUE c.prenom,
            'cin'             VALUE c.cin,
            'adresse'         VALUE c.adresse,
            'ville'           VALUE c.ville,
            'code_postal'     VALUE c.code_postal,
            'pays'            VALUE c.pays,
            'telephone'       VALUE c.telephone,
            'email'           VALUE c.email,
            'date_creation'   VALUE TO_CHAR(c.date_creation, 'YYYY-MM-DD'),
            'contrats'        VALUE (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'id_contrat'     VALUE ct.id_contrat,
                        'numero_police'  VALUE ct.numero_police,
                        'produit'        VALUE p.nom_produit,
                        'date_effet'     VALUE TO_CHAR(ct.date_effet, 'YYYY-MM-DD'),
                        'prime_annuelle' VALUE ct.prime_annuelle,
                        'statut'         VALUE ct.statut
                    )
                )
                FROM contrats ct
                JOIN produits p ON ct.id_produit = p.id_produit
                WHERE ct.id_client = c.id_client
            )
            RETURNING CLOB
        ) INTO l_json
        FROM clients c
        WHERE c.id_client = p_id_client;
        
        RETURN l_json;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN '{"error": "Client non trouve"}';
    END get_client_by_id_json;

    PROCEDURE creer_client(
        p_type_client IN VARCHAR2, p_nom IN VARCHAR2, p_prenom IN VARCHAR2,
        p_cin IN VARCHAR2, p_adresse IN VARCHAR2, p_ville IN VARCHAR2,
        p_telephone IN VARCHAR2, p_email IN VARCHAR2, p_id_agent IN NUMBER DEFAULT NULL,
        p_retour_json OUT CLOB
    ) IS
        l_id NUMBER;
        l_num VARCHAR2(20);
    BEGIN
        l_num := 'CLI-' || TO_CHAR(SYSDATE, 'YYMM') || '-' || LPAD(seq_client_num.NEXTVAL, 4, '0');
        
        INSERT INTO clients (type_client, numero_client, nom, prenom, cin, adresse, ville, telephone, email, id_agent)
        VALUES (p_type_client, l_num, p_nom, p_prenom, p_cin, p_adresse, p_ville, p_telephone, p_email, p_id_agent)
        RETURNING id_client INTO l_id;
        
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","id_client":' || l_id || ',"numero_client":"' || l_num || '"}';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_retour_json := '{"status":"ERROR","message":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END creer_client;

    PROCEDURE modifier_client(
        p_id_client IN NUMBER, p_nom IN VARCHAR2, p_prenom IN VARCHAR2,
        p_telephone IN VARCHAR2, p_email IN VARCHAR2, p_retour_json OUT CLOB
    ) IS
    BEGIN
        UPDATE clients SET nom = p_nom, prenom = p_prenom, telephone = p_telephone, email = p_email
        WHERE id_client = p_id_client;
        
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","message":"Client mis a jour"}';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_retour_json := '{"status":"ERROR","message":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END modifier_client;

END pkg_api_clients;
/

-- =============================================
-- PACKAGE 2 : PKG_API_CONTRATS
-- API JSON pour la gestion des contrats/polices
-- =============================================
CREATE OR REPLACE PACKAGE pkg_api_contrats AS
    FUNCTION get_contrats_json(p_id_client IN NUMBER DEFAULT NULL, p_statut IN VARCHAR2 DEFAULT NULL) RETURN CLOB;
    FUNCTION get_contrat_detail_json(p_id_contrat IN NUMBER) RETURN CLOB;
    PROCEDURE souscrire_contrat(
        p_id_client    IN NUMBER,
        p_id_produit   IN NUMBER,
        p_id_agent     IN NUMBER,
        p_date_effet   IN DATE,
        p_duree_mois   IN NUMBER,
        p_prime        IN NUMBER,
        p_capital      IN NUMBER,
        p_retour_json  OUT CLOB
    );
    PROCEDURE resilier_contrat(p_id_contrat IN NUMBER, p_retour_json OUT CLOB);
END pkg_api_contrats;
/

CREATE OR REPLACE PACKAGE BODY pkg_api_contrats AS

    FUNCTION get_contrats_json(p_id_client IN NUMBER DEFAULT NULL, p_statut IN VARCHAR2 DEFAULT NULL) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id_contrat'      VALUE v.id_contrat,
                'numero_police'   VALUE v.numero_police,
                'client'          VALUE v.nom_complet_client,
                'produit'         VALUE v.nom_produit,
                'branche'         VALUE v.branche,
                'date_effet'      VALUE TO_CHAR(v.date_effet, 'YYYY-MM-DD'),
                'date_expiration' VALUE TO_CHAR(v.date_expiration, 'YYYY-MM-DD'),
                'prime_annuelle'  VALUE v.prime_annuelle,
                'capital_assure'  VALUE v.capital_assure,
                'statut'          VALUE v.statut,
                'agent'           VALUE v.nom_agent,
                'agence'          VALUE v.nom_agence
            ) RETURNING CLOB
        ) INTO l_json
        FROM v_contrats_synthese v
        WHERE (p_id_client IS NULL OR v.numero_client IN (SELECT numero_client FROM clients WHERE id_client = p_id_client))
          AND (p_statut IS NULL OR v.statut = p_statut);
        
        RETURN NVL(l_json, '[]');
    END get_contrats_json;

    FUNCTION get_contrat_detail_json(p_id_contrat IN NUMBER) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'contrat' VALUE JSON_OBJECT(
                'id_contrat'      VALUE v.id_contrat,
                'numero_police'   VALUE v.numero_police,
                'client'          VALUE v.nom_complet_client,
                'produit'         VALUE v.nom_produit,
                'branche'         VALUE v.branche,
                'date_effet'      VALUE TO_CHAR(v.date_effet, 'YYYY-MM-DD'),
                'date_expiration' VALUE TO_CHAR(v.date_expiration, 'YYYY-MM-DD'),
                'prime_annuelle'  VALUE v.prime_annuelle,
                'capital_assure'  VALUE v.capital_assure,
                'statut'          VALUE v.statut
            ),
            'garanties' VALUE (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'code_garantie'   VALUE g.code_garantie,
                        'libelle'         VALUE g.libelle,
                        'montant_couvert' VALUE g.montant_couvert,
                        'franchise'       VALUE g.franchise
                    )
                )
                FROM garanties g WHERE g.id_contrat = p_id_contrat AND g.actif = 'O'
            ),
            'sinistres' VALUE (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'numero_sinistre' VALUE s.numero_sinistre,
                        'date_survenance' VALUE TO_CHAR(s.date_survenance, 'YYYY-MM-DD'),
                        'montant_estime'  VALUE s.montant_estime,
                        'statut'          VALUE s.statut
                    )
                )
                FROM sinistres s WHERE s.id_contrat = p_id_contrat
            ),
            'quittances' VALUE (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'numero_quittance' VALUE q.numero_quittance,
                        'date_echeance'    VALUE TO_CHAR(q.date_echeance, 'YYYY-MM-DD'),
                        'montant'          VALUE q.montant,
                        'statut'           VALUE q.statut
                    )
                )
                FROM quittances q WHERE q.id_contrat = p_id_contrat
            )
            RETURNING CLOB
        ) INTO l_json
        FROM v_contrats_synthese v
        WHERE v.id_contrat = p_id_contrat;
        
        RETURN l_json;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN '{"error":"Contrat non trouve"}';
    END get_contrat_detail_json;

    PROCEDURE souscrire_contrat(
        p_id_client IN NUMBER, p_id_produit IN NUMBER, p_id_agent IN NUMBER,
        p_date_effet IN DATE, p_duree_mois IN NUMBER, p_prime IN NUMBER,
        p_capital IN NUMBER, p_retour_json OUT CLOB
    ) IS
        l_id NUMBER;
        l_num VARCHAR2(30);
    BEGIN
        l_num := 'POL-' || TO_CHAR(SYSDATE, 'YYMM') || '-' || LPAD(seq_contrat_num.NEXTVAL, 5, '0');
        
        INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure)
        VALUES (l_num, p_id_client, p_id_produit, p_id_agent, p_date_effet, ADD_MONTHS(p_date_effet, p_duree_mois), p_prime, p_capital)
        RETURNING id_contrat INTO l_id;
        
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","id_contrat":' || l_id || ',"numero_police":"' || l_num || '"}';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_retour_json := '{"status":"ERROR","message":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END souscrire_contrat;

    PROCEDURE resilier_contrat(p_id_contrat IN NUMBER, p_retour_json OUT CLOB) IS
    BEGIN
        UPDATE contrats SET statut = 'RESILIE' WHERE id_contrat = p_id_contrat;
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","message":"Contrat resilie"}';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_retour_json := '{"status":"ERROR","message":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END resilier_contrat;

END pkg_api_contrats;
/

-- =============================================
-- PACKAGE 3 : PKG_API_SINISTRES
-- API JSON pour la gestion des sinistres
-- =============================================
CREATE OR REPLACE PACKAGE pkg_api_sinistres AS
    FUNCTION get_sinistres_json(p_statut IN VARCHAR2 DEFAULT NULL) RETURN CLOB;
    FUNCTION get_sinistre_detail_json(p_id_sinistre IN NUMBER) RETURN CLOB;
    PROCEDURE declarer_sinistre(
        p_id_contrat       IN NUMBER,
        p_date_survenance  IN DATE,
        p_type_sinistre    IN VARCHAR2,
        p_description      IN VARCHAR2,
        p_lieu             IN VARCHAR2,
        p_montant_estime   IN NUMBER,
        p_retour_json      OUT CLOB
    );
    PROCEDURE indemniser_sinistre(p_id_sinistre IN NUMBER, p_montant IN NUMBER, p_retour_json OUT CLOB);
    PROCEDURE cloturer_sinistre(p_id_sinistre IN NUMBER, p_retour_json OUT CLOB);
END pkg_api_sinistres;
/

CREATE OR REPLACE PACKAGE BODY pkg_api_sinistres AS

    FUNCTION get_sinistres_json(p_statut IN VARCHAR2 DEFAULT NULL) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'id_sinistre'      VALUE v.id_sinistre,
                'numero_sinistre'  VALUE v.numero_sinistre,
                'numero_police'    VALUE v.numero_police,
                'client'           VALUE v.nom_complet_client,
                'produit'          VALUE v.nom_produit,
                'branche'          VALUE v.branche,
                'date_survenance'  VALUE TO_CHAR(v.date_survenance, 'YYYY-MM-DD'),
                'type_sinistre'    VALUE v.type_sinistre,
                'montant_estime'   VALUE v.montant_estime,
                'montant_indemnise' VALUE v.montant_indemnise,
                'statut'           VALUE v.statut
            ) RETURNING CLOB
        ) INTO l_json
        FROM v_sinistres_synthese v
        WHERE (p_statut IS NULL OR v.statut = p_statut);
        
        RETURN NVL(l_json, '[]');
    END get_sinistres_json;

    FUNCTION get_sinistre_detail_json(p_id_sinistre IN NUMBER) RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'id_sinistre'       VALUE v.id_sinistre,
            'numero_sinistre'   VALUE v.numero_sinistre,
            'numero_police'     VALUE v.numero_police,
            'client'            VALUE v.nom_complet_client,
            'produit'           VALUE v.nom_produit,
            'date_survenance'   VALUE TO_CHAR(v.date_survenance, 'YYYY-MM-DD'),
            'date_declaration'  VALUE TO_CHAR(v.date_declaration, 'YYYY-MM-DD'),
            'type_sinistre'     VALUE v.type_sinistre,
            'description'       VALUE v.description,
            'lieu_sinistre'     VALUE v.lieu_sinistre,
            'montant_estime'    VALUE v.montant_estime,
            'montant_indemnise' VALUE v.montant_indemnise,
            'statut'            VALUE v.statut,
            'date_cloture'      VALUE TO_CHAR(v.date_cloture, 'YYYY-MM-DD')
            RETURNING CLOB
        ) INTO l_json
        FROM v_sinistres_synthese v
        WHERE v.id_sinistre = p_id_sinistre;
        
        RETURN l_json;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN '{"error":"Sinistre non trouve"}';
    END get_sinistre_detail_json;

    PROCEDURE declarer_sinistre(
        p_id_contrat IN NUMBER, p_date_survenance IN DATE, p_type_sinistre IN VARCHAR2,
        p_description IN VARCHAR2, p_lieu IN VARCHAR2, p_montant_estime IN NUMBER,
        p_retour_json OUT CLOB
    ) IS
        l_id NUMBER;
        l_num VARCHAR2(30);
    BEGIN
        l_num := 'SIN-' || TO_CHAR(SYSDATE, 'YYMM') || '-' || LPAD(seq_sinistre_num.NEXTVAL, 5, '0');
        
        INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime)
        VALUES (l_num, p_id_contrat, p_date_survenance, p_type_sinistre, p_description, p_lieu, p_montant_estime)
        RETURNING id_sinistre INTO l_id;
        
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","id_sinistre":' || l_id || ',"numero_sinistre":"' || l_num || '"}';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_retour_json := '{"status":"ERROR","message":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END declarer_sinistre;

    PROCEDURE indemniser_sinistre(p_id_sinistre IN NUMBER, p_montant IN NUMBER, p_retour_json OUT CLOB) IS
    BEGIN
        UPDATE sinistres SET montant_indemnise = p_montant, statut = 'INDEMNISE' WHERE id_sinistre = p_id_sinistre;
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","message":"Sinistre indemnise"}';
    END indemniser_sinistre;

    PROCEDURE cloturer_sinistre(p_id_sinistre IN NUMBER, p_retour_json OUT CLOB) IS
    BEGIN
        UPDATE sinistres SET statut = 'CLOS', date_cloture = SYSDATE WHERE id_sinistre = p_id_sinistre;
        COMMIT;
        p_retour_json := '{"status":"SUCCESS","message":"Sinistre cloture"}';
    END cloturer_sinistre;

END pkg_api_sinistres;
/

-- =============================================
-- PACKAGE 4 : PKG_API_DASHBOARD
-- API JSON pour le tableau de bord
-- =============================================
CREATE OR REPLACE PACKAGE pkg_api_dashboard AS
    FUNCTION get_kpi_json RETURN CLOB;
    FUNCTION get_primes_par_branche_json RETURN CLOB;
    FUNCTION get_sinistres_par_mois_json(p_annee IN NUMBER DEFAULT NULL) RETURN CLOB;
END pkg_api_dashboard;
/

CREATE OR REPLACE PACKAGE BODY pkg_api_dashboard AS

    FUNCTION get_kpi_json RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'nb_clients_actifs'      VALUE nb_clients_actifs,
            'nb_contrats_actifs'     VALUE nb_contrats_actifs,
            'total_primes'           VALUE total_primes,
            'nb_sinistres_ouverts'   VALUE nb_sinistres_ouverts,
            'total_sinistres_estimes' VALUE total_sinistres_estimes,
            'total_impayes'          VALUE total_impayes,
            'ratio_sinistralite'     VALUE ROUND(
                CASE WHEN total_primes > 0 
                     THEN total_sinistres_estimes / total_primes * 100 
                     ELSE 0 
                END, 2
            )
            RETURNING CLOB
        ) INTO l_json
        FROM v_dashboard_kpi;
        
        RETURN l_json;
    END get_kpi_json;

    FUNCTION get_primes_par_branche_json RETURN CLOB IS
        l_json CLOB;
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'branche'    VALUE b.libelle,
                'nb_contrats' VALUE COUNT(c.id_contrat),
                'total_prime' VALUE NVL(SUM(c.prime_annuelle), 0)
            )
        ) INTO l_json
        FROM branches b
        LEFT JOIN produits p ON b.id_branche = p.id_branche
        LEFT JOIN contrats c ON p.id_produit = c.id_produit AND c.statut = 'ACTIF'
        GROUP BY b.libelle;
        
        RETURN NVL(l_json, '[]');
    END get_primes_par_branche_json;

    FUNCTION get_sinistres_par_mois_json(p_annee IN NUMBER DEFAULT NULL) RETURN CLOB IS
        l_json CLOB;
        l_annee NUMBER := NVL(p_annee, EXTRACT(YEAR FROM SYSDATE));
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'mois'       VALUE TO_CHAR(s.date_survenance, 'MM'),
                'mois_nom'   VALUE TO_CHAR(s.date_survenance, 'Month', 'NLS_DATE_LANGUAGE=FRENCH'),
                'nb_sinistres' VALUE COUNT(*),
                'montant_total' VALUE NVL(SUM(s.montant_estime), 0)
            ) ORDER BY TO_CHAR(s.date_survenance, 'MM')
        ) INTO l_json
        FROM sinistres s
        WHERE EXTRACT(YEAR FROM s.date_survenance) = l_annee
        GROUP BY TO_CHAR(s.date_survenance, 'MM'), TO_CHAR(s.date_survenance, 'Month', 'NLS_DATE_LANGUAGE=FRENCH');
        
        RETURN NVL(l_json, '[]');
    END get_sinistres_par_mois_json;

END pkg_api_dashboard;
/

DBMS_OUTPUT.PUT_LINE('PACKAGES: Tous les packages crees avec succes');

SPOOL OFF
EXIT;
