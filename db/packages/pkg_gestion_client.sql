CREATE OR REPLACE PACKAGE pkg_gestion_client AS
    PROCEDURE desactiver_client(p_id_client IN NUMBER);
    -- D'autres fonctions consommées par APEX...
END pkg_gestion_client;
/

CREATE OR REPLACE PACKAGE BODY pkg_gestion_client AS
    PROCEDURE desactiver_client(p_id_client IN NUMBER) IS
    BEGIN
        -- Mise à jour simple
        UPDATE clients 
        SET statut = 'INACTIF' 
        WHERE id_client = p_id_client;
        
        COMMIT;
    END desactiver_client;
END pkg_gestion_client;
/
