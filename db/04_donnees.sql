-- =========================================================================
-- ORASSADM - MODELE METIER ASSURANCE
-- Partie 4 : SEQUENCES + JEU DE DONNEES REALISTE
-- =========================================================================
SET SERVEROUTPUT ON SIZE 1000000
SPOOL d:\ProjetApexOrassuit\metier_result.txt

-- =============================================
-- SEQUENCES (pour les numeros automatiques)
-- =============================================
CREATE SEQUENCE seq_client_num START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_contrat_num START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sinistre_num START WITH 1 INCREMENT BY 1;

-- =============================================
-- DONNEES DE REFERENCE : AGENCES
-- =============================================
INSERT INTO agences (code_agence, nom_agence, adresse, ville, pays, telephone, email) VALUES
('AG-CASA', 'Agence Casablanca Centre', '125 Boulevard Zerktouni', 'Casablanca', 'Maroc', '+212522334455', 'casa.centre@orassuit.ma');
INSERT INTO agences (code_agence, nom_agence, adresse, ville, pays, telephone, email) VALUES
('AG-RABAT', 'Agence Rabat Agdal', '45 Avenue Hassan II', 'Rabat', 'Maroc', '+212537112233', 'rabat.agdal@orassuit.ma');
INSERT INTO agences (code_agence, nom_agence, adresse, ville, pays, telephone, email) VALUES
('AG-TANGER', 'Agence Tanger Medina', '78 Rue de la Liberte', 'Tanger', 'Maroc', '+212539667788', 'tanger@orassuit.ma');
INSERT INTO agences (code_agence, nom_agence, adresse, ville, pays, telephone, email) VALUES
('AG-TUNIS', 'Agence Tunis Lac', '10 Rue du Lac Biwa', 'Tunis', 'Tunisie', '+21671234567', 'tunis.lac@orassuit.tn');
INSERT INTO agences (code_agence, nom_agence, adresse, ville, pays, telephone, email) VALUES
('AG-PARIS', 'Agence Paris Opera', '22 Boulevard des Capucines', 'Paris', 'France', '+33142334455', 'paris.opera@orassuit.fr');

-- =============================================
-- DONNEES DE REFERENCE : AGENTS
-- =============================================
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(1, 'AGT-001', 'Benali', 'Karim', 'k.benali@orassuit.ma', '+212661223344');
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(1, 'AGT-002', 'Fassi', 'Nadia', 'n.fassi@orassuit.ma', '+212662334455');
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(2, 'AGT-003', 'Cherkaoui', 'Amine', 'a.cherkaoui@orassuit.ma', '+212663445566');
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(3, 'AGT-004', 'Tazi', 'Samira', 's.tazi@orassuit.ma', '+212664556677');
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(4, 'AGT-005', 'Hammami', 'Mehdi', 'm.hammami@orassuit.tn', '+21652334455');
INSERT INTO agents (id_agence, matricule, nom, prenom, email, telephone) VALUES
(5, 'AGT-006', 'Dupont', 'Marie', 'm.dupont@orassuit.fr', '+33612334455');

-- =============================================
-- DONNEES DE REFERENCE : BRANCHES
-- =============================================
INSERT INTO branches (code_branche, libelle, description) VALUES
('AUTO', 'Assurance Automobile', 'Couverture vehicules : responsabilite civile, tous risques, bris de glace');
INSERT INTO branches (code_branche, libelle, description) VALUES
('SANTE', 'Assurance Sante', 'Couverture frais medicaux, hospitalisation, dentaire, optique');
INSERT INTO branches (code_branche, libelle, description) VALUES
('HABIT', 'Assurance Habitation', 'Couverture multirisque habitation : incendie, vol, degats des eaux');
INSERT INTO branches (code_branche, libelle, description) VALUES
('VIE', 'Assurance Vie', 'Epargne et prevoyance : deces, invalidite, retraite');
INSERT INTO branches (code_branche, libelle, description) VALUES
('RC_PRO', 'Responsabilite Civile Professionnelle', 'Protection des entreprises contre les reclamations de tiers');

-- =============================================
-- DONNEES DE REFERENCE : PRODUITS
-- =============================================
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(1, 'AUTO-RC', 'Auto Responsabilite Civile', 'Couverture obligatoire RC automobile', 1500, 5000, 12);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(1, 'AUTO-TR', 'Auto Tous Risques', 'Couverture complete vehicule + RC + bris de glace', 3000, 15000, 12);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(2, 'SANTE-IND', 'Sante Individuelle', 'Couverture sante individuelle complete', 2000, 8000, 12);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(2, 'SANTE-FAM', 'Sante Famille', 'Couverture sante pour toute la famille', 5000, 20000, 12);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(3, 'HABIT-MRH', 'Multirisque Habitation', 'Protection multirisque pour votre logement', 800, 5000, 12);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(4, 'VIE-EP', 'Vie Epargne', 'Produit epargne long terme avec garantie deces', 3000, 50000, 120);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(4, 'VIE-RET', 'Vie Retraite', 'Plan retraite complementaire', 5000, 100000, 240);
INSERT INTO produits (id_branche, code_produit, nom_produit, description, prime_min, prime_max, duree_mois) VALUES
(5, 'RCPRO-PME', 'RC Pro PME', 'Responsabilite civile pour petites et moyennes entreprises', 2000, 30000, 12);

-- =============================================
-- DONNEES : CLIENTS (20 clients)
-- =============================================
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0001', 'El Amrani', 'Youssef', DATE '1985-03-15', 'BK123456', '34 Rue Moulay Ismail', 'Casablanca', '20000', 'Maroc', '+212661001122', 'y.elamrani@email.com', 1);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0002', 'Bouazza', 'Fatima', DATE '1990-07-22', 'BK789012', '12 Avenue des FAR', 'Casablanca', '20100', 'Maroc', '+212662112233', 'f.bouazza@email.com', 1);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0003', 'Idrissi', 'Mohamed', DATE '1978-11-05', 'PA334455', '67 Rue Oqba', 'Rabat', '10000', 'Maroc', '+212663223344', 'm.idrissi@email.com', 3);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('ENTREPRISE', 'CLI-2501-0004', 'SARL TechMaroc', NULL, NULL, NULL, '15 Zone Industrielle Ain Sebaa', 'Casablanca', '20580', 'Maroc', '+212522556677', 'contact@techmaroc.ma', 2);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0005', 'Zerhouni', 'Asmaa', DATE '1995-01-30', 'T667788', '23 Boulevard Mohammed V', 'Tanger', '90000', 'Maroc', '+212664334455', 'a.zerhouni@email.com', 4);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0006', 'Benjelloun', 'Rachid', DATE '1982-06-10', 'BK556677', '8 Rue Ibn Toumert', 'Casablanca', '20000', 'Maroc', '+212665445566', 'r.benjelloun@email.com', 1);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0007', 'Lahlou', 'Kenza', DATE '1988-09-18', 'PA112233', '56 Avenue Allal Ben Abdellah', 'Rabat', '10020', 'Maroc', '+212666556677', 'k.lahlou@email.com', 3);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('ENTREPRISE', 'CLI-2501-0008', 'SA MediServices', NULL, NULL, NULL, '120 Rue de Marseille', 'Rabat', '10030', 'Maroc', '+212537889900', 'info@mediservices.ma', 3);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0009', 'Bouzidi', 'Hamza', DATE '1992-04-25', 'BK998877', '90 Rue Abdelmoumen', 'Casablanca', '20050', 'Maroc', '+212667667788', 'h.bouzidi@email.com', 2);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0010', 'Hammami', 'Leila', DATE '1987-12-03', 'TN334455', '45 Rue de Carthage', 'Tunis', '1000', 'Tunisie', '+21620112233', 'l.hammami@email.tn', 5);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0011', 'Trabelsi', 'Ahmed', DATE '1975-08-14', 'TN556677', '12 Avenue Habib Bourguiba', 'Tunis', '1001', 'Tunisie', '+21621223344', 'a.trabelsi@email.tn', 5);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0012', 'Martin', 'Sophie', DATE '1993-02-28', NULL, '15 Rue de Rivoli', 'Paris', '75001', 'France', '+33611223344', 's.martin@email.fr', 6);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('ENTREPRISE', 'CLI-2501-0013', 'SARL Batiment Plus', NULL, NULL, NULL, '88 Rue Ghandi', 'Casablanca', '20200', 'Maroc', '+212522778899', 'contact@batimentplus.ma', 2);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0014', 'Filali', 'Omar', DATE '1980-05-20', 'BK445566', '23 Rue Berkane', 'Casablanca', '20300', 'Maroc', '+212668778899', 'o.filali@email.com', 1);
INSERT INTO clients (type_client, numero_client, nom, prenom, date_naissance, cin, adresse, ville, code_postal, pays, telephone, email, id_agent) VALUES
('PERSONNE', 'CLI-2501-0015', 'Alaoui', 'Zineb', DATE '1991-10-12', 'PA667788', '40 Avenue Hassan II', 'Rabat', '10000', 'Maroc', '+212669889900', 'z.alaoui@email.com', 3);

-- =============================================
-- DONNEES : CONTRATS (25 contrats)
-- =============================================
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00001', 1, 2, 1, DATE '2025-01-15', DATE '2026-01-15', 4500, 250000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00002', 1, 3, 1, DATE '2025-02-01', DATE '2026-02-01', 3200, 150000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00003', 2, 1, 1, DATE '2025-03-10', DATE '2026-03-10', 2100, 100000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00004', 2, 5, 1, DATE '2025-01-20', DATE '2026-01-20', 1200, 500000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00005', 3, 2, 3, DATE '2025-04-05', DATE '2026-04-05', 5800, 300000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00006', 3, 4, 3, DATE '2025-02-15', DATE '2026-02-15', 7500, 200000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00007', 4, 8, 2, DATE '2025-05-01', DATE '2026-05-01', 12000, 1000000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00008', 5, 1, 4, DATE '2025-06-01', DATE '2026-06-01', 1800, 80000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00009', 5, 5, 4, DATE '2025-03-15', DATE '2026-03-15', 950, 400000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00010', 6, 2, 1, DATE '2025-07-01', DATE '2026-07-01', 6200, 350000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00011', 6, 6, 1, DATE '2025-01-01', DATE '2035-01-01', 8000, 500000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00012', 7, 3, 3, DATE '2025-08-01', DATE '2026-08-01', 2800, 120000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00013', 8, 8, 3, DATE '2025-04-15', DATE '2026-04-15', 18000, 2000000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00014', 9, 2, 2, DATE '2025-09-01', DATE '2026-09-01', 4800, 220000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00015', 10, 1, 5, DATE '2025-05-20', DATE '2026-05-20', 2500, 100000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00016', 10, 3, 5, DATE '2025-06-10', DATE '2026-06-10', 3500, 180000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00017', 11, 7, 5, DATE '2025-01-01', DATE '2045-01-01', 15000, 800000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00018', 12, 2, 6, DATE '2025-10-01', DATE '2026-10-01', 7200, 400000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00019', 12, 4, 6, DATE '2025-03-01', DATE '2026-03-01', 9500, 250000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00020', 13, 8, 2, DATE '2024-11-01', DATE '2025-11-01', 25000, 3000000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00021', 14, 1, 1, DATE '2024-06-01', DATE '2025-06-01', 1900, 90000, 'EXPIRE');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00022', 14, 5, 1, DATE '2025-01-15', DATE '2026-01-15', 1100, 450000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00023', 15, 2, 3, DATE '2025-11-01', DATE '2026-11-01', 5100, 280000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00024', 15, 6, 3, DATE '2025-02-01', DATE '2035-02-01', 10000, 600000, 'ACTIF');
INSERT INTO contrats (numero_police, id_client, id_produit, id_agent, date_effet, date_expiration, prime_annuelle, capital_assure, statut) VALUES
('POL-2501-00025', 9, 5, 2, DATE '2024-09-01', DATE '2025-09-01', 1500, 500000, 'SUSPENDU');

-- =============================================
-- DONNEES : GARANTIES
-- =============================================
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (1, 'RC', 'Responsabilite Civile', 250000, 500);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (1, 'VOL', 'Vol et Tentative', 150000, 2000);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (1, 'BDG', 'Bris de Glace', 30000, 0);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (1, 'INC', 'Incendie', 200000, 1000);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (2, 'HOSP', 'Hospitalisation', 100000, 500);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (2, 'CONS', 'Consultations', 20000, 0);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (2, 'DENT', 'Soins Dentaires', 15000, 200);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (5, 'RC', 'Responsabilite Civile', 300000, 500);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (5, 'DAGT', 'Dommages Tous Accidents', 250000, 3000);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (7, 'RCPRO', 'RC Professionnelle', 1000000, 5000);
INSERT INTO garanties (id_contrat, code_garantie, libelle, montant_couvert, franchise) VALUES (7, 'EXPLOIT', 'RC Exploitation', 500000, 2000);

-- =============================================
-- DONNEES : SINISTRES (10 sinistres)
-- =============================================
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00001', 1, DATE '2025-04-12', 'Accident', 'Collision arriere sur autoroute A7', 'Autoroute Casablanca-Rabat Km 45', 35000, 28000, 'INDEMNISE');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00002', 1, DATE '2025-09-05', 'Vol', 'Vol de vehicule sur parking', 'Parking Anfa Place Casablanca', 180000, NULL, 'EN_COURS');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00003', 2, DATE '2025-06-18', 'Hospitalisation', 'Hospitalisation urgente chirurgie', 'Clinique Dar Salam Casablanca', 45000, 40000, 'INDEMNISE');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00004', 5, DATE '2025-07-22', 'Accident', 'Accrochage lateral en ville', 'Boulevard Ghandi Rabat', 12000, NULL, 'EXPERTISE');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00005', 4, DATE '2025-08-14', 'Degat des eaux', 'Fuite canalisation cuisine', '12 Avenue des FAR Casablanca', 8500, NULL, 'OUVERT');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00006', 8, DATE '2025-10-03', 'Accident', 'Collision avec obstacle fixe', 'Route nationale N1 Tanger', 22000, NULL, 'OUVERT');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00007', 10, DATE '2025-11-20', 'Bris de glace', 'Pare-brise casse par projection de gravier', 'Peripherique Casablanca', 3500, 3500, 'CLOS');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00008', 13, DATE '2025-05-30', 'RC Professionnelle', 'Erreur de conseil client - reclamation', 'Siege MediServices Rabat', 95000, NULL, 'EN_COURS');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00009', 18, DATE '2025-12-01', 'Accident', 'Carambolage sur A6 Paris', 'Autoroute A6 Km 30 Paris', 42000, NULL, 'OUVERT');
INSERT INTO sinistres (numero_sinistre, id_contrat, date_survenance, type_sinistre, description, lieu_sinistre, montant_estime, montant_indemnise, statut) VALUES
('SIN-2501-00010', 15, DATE '2025-07-10', 'Accident', 'Collision frontale route secondaire', 'Route regionale R413 Tunis', 55000, 48000, 'INDEMNISE');

-- =============================================
-- DONNEES : QUITTANCES (Paiements)
-- =============================================
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-001', 1, DATE '2025-01-15', 4500, 4500, 'PAYEE', DATE '2025-01-10');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-002', 2, DATE '2025-02-01', 3200, 3200, 'PAYEE', DATE '2025-01-28');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-003', 3, DATE '2025-03-10', 2100, 2100, 'PAYEE', DATE '2025-03-08');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-004', 5, DATE '2025-04-05', 5800, 5800, 'PAYEE', DATE '2025-04-01');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-005', 7, DATE '2025-05-01', 12000, 6000, 'PARTIELLEMENT_PAYEE', DATE '2025-05-05');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-006', 10, DATE '2025-07-01', 6200, 0, 'IMPAYEE', NULL);
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-007', 14, DATE '2025-09-01', 4800, 4800, 'PAYEE', DATE '2025-08-29');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-008', 18, DATE '2025-10-01', 7200, 0, 'EMISE', NULL);
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-009', 20, DATE '2024-11-01', 25000, 25000, 'PAYEE', DATE '2024-10-28');
INSERT INTO quittances (numero_quittance, id_contrat, date_echeance, montant, montant_paye, statut, date_paiement) VALUES
('QUI-2501-010', 23, DATE '2025-11-01', 5100, 5100, 'PAYEE', DATE '2025-10-30');

COMMIT;

DBMS_OUTPUT.PUT_LINE('DONNEES: Jeu de donnees insere avec succes');

SPOOL OFF
EXIT;
