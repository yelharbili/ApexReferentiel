-- liquibase formatted sql
-- changeset dev2:02_ajouter_colonne_statut

-- Ajout d'une colonne statut pour l'application V2
-- Ne détruit aucune donnée existante dans la table clients !
ALTER TABLE clients ADD statut VARCHAR2(20) DEFAULT 'ACTIF';

-- rollback ALTER TABLE clients DROP COLUMN statut;
