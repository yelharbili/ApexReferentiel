-- =========================================================================
-- ORASSADM - MODELE METIER ASSURANCE
-- Partie 2 : TYPES ORACLE + VUES
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\metier_result.txt

-- =============================================
-- TYPES ORACLE POUR STRUCTURER LES REPONSES JSON
-- =============================================

-- Type pour un element client
CREATE OR REPLACE TYPE t_client_rec AS OBJECT (
    id_client      NUMBER,
    numero_client  VARCHAR2(20),
    nom            VARCHAR2(100),
    prenom         VARCHAR2(100),
    ville          VARCHAR2(100),
    telephone      VARCHAR2(20)
);
/

-- Type table de clients
CREATE OR REPLACE TYPE t_client_tab AS TABLE OF t_client_rec;
/

-- Type pour un element contrat
CREATE OR REPLACE TYPE t_contrat_rec AS OBJECT (
    id_contrat      NUMBER,
    numero_police   VARCHAR2(30),
    nom_client      VARCHAR2(200),
    nom_produit     VARCHAR2(200),
    date_effet      DATE,
    date_expiration DATE,
    prime_annuelle  NUMBER,
    statut          VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE t_contrat_tab AS TABLE OF t_contrat_rec;
/

-- Type pour un element sinistre
CREATE OR REPLACE TYPE t_sinistre_rec AS OBJECT (
    id_sinistre      NUMBER,
    numero_sinistre  VARCHAR2(30),
    numero_police    VARCHAR2(30),
    nom_client       VARCHAR2(200),
    date_survenance  DATE,
    montant_estime   NUMBER,
    statut           VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE t_sinistre_tab AS TABLE OF t_sinistre_rec;
/

-- =============================================
-- VUES METIER
-- =============================================

-- Vue 1 : Synthese des contrats
CREATE OR REPLACE VIEW v_contrats_synthese AS
SELECT 
    c.id_contrat,
    c.numero_police,
    cl.numero_client,
    cl.nom || ' ' || NVL(cl.prenom, '') AS nom_complet_client,
    cl.type_client,
    p.nom_produit,
    b.libelle AS branche,
    c.date_effet,
    c.date_expiration,
    c.prime_annuelle,
    c.capital_assure,
    c.statut,
    c.mode_paiement,
    a.nom || ' ' || a.prenom AS nom_agent,
    ag.nom_agence
FROM contrats c
JOIN clients cl ON c.id_client = cl.id_client
JOIN produits p ON c.id_produit = p.id_produit
JOIN branches b ON p.id_branche = b.id_branche
LEFT JOIN agents a ON c.id_agent = a.id_agent
LEFT JOIN agences ag ON a.id_agence = ag.id_agence;

-- Vue 2 : Synthese des sinistres
CREATE OR REPLACE VIEW v_sinistres_synthese AS
SELECT 
    s.id_sinistre,
    s.numero_sinistre,
    c.numero_police,
    cl.nom || ' ' || NVL(cl.prenom, '') AS nom_complet_client,
    p.nom_produit,
    b.libelle AS branche,
    s.date_survenance,
    s.date_declaration,
    s.type_sinistre,
    s.description,
    s.lieu_sinistre,
    s.montant_estime,
    s.montant_indemnise,
    s.statut,
    s.date_cloture
FROM sinistres s
JOIN contrats c ON s.id_contrat = c.id_contrat
JOIN clients cl ON c.id_client = cl.id_client
JOIN produits p ON c.id_produit = p.id_produit
JOIN branches b ON p.id_branche = b.id_branche;

-- Vue 3 : Tableau de bord des quittances
CREATE OR REPLACE VIEW v_quittances_synthese AS
SELECT 
    q.id_quittance,
    q.numero_quittance,
    c.numero_police,
    cl.nom || ' ' || NVL(cl.prenom, '') AS nom_complet_client,
    q.date_emission,
    q.date_echeance,
    q.montant,
    q.montant_paye,
    q.montant - NVL(q.montant_paye, 0) AS reste_a_payer,
    q.statut,
    q.date_paiement
FROM quittances q
JOIN contrats c ON q.id_contrat = c.id_contrat
JOIN clients cl ON c.id_client = cl.id_client;

-- Vue 4 : Dashboard KPI
CREATE OR REPLACE VIEW v_dashboard_kpi AS
SELECT
    (SELECT COUNT(*) FROM clients WHERE actif = 'O') AS nb_clients_actifs,
    (SELECT COUNT(*) FROM contrats WHERE statut = 'ACTIF') AS nb_contrats_actifs,
    (SELECT NVL(SUM(prime_annuelle), 0) FROM contrats WHERE statut = 'ACTIF') AS total_primes,
    (SELECT COUNT(*) FROM sinistres WHERE statut IN ('OUVERT','EN_COURS','EXPERTISE')) AS nb_sinistres_ouverts,
    (SELECT NVL(SUM(montant_estime), 0) FROM sinistres WHERE statut IN ('OUVERT','EN_COURS','EXPERTISE')) AS total_sinistres_estimes,
    (SELECT NVL(SUM(montant - NVL(montant_paye,0)), 0) FROM quittances WHERE statut IN ('EMISE','IMPAYEE')) AS total_impayes
FROM dual;

DBMS_OUTPUT.PUT_LINE('TYPES ET VUES: Crees avec succes');

SPOOL OFF
EXIT;
