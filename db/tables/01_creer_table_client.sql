-- liquibase formatted sql
-- changeset dev1:01_creer_table_client

CREATE TABLE clients (
    id_client NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    prenom VARCHAR2(100) NOT NULL,
    email VARCHAR2(255),
    date_creation DATE DEFAULT SYSDATE
);

-- rollback DROP TABLE clients;
