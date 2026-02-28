# Exercice Pratique : Déploiement APEX & Base de données

Ce dossier contient un exemple d'architecture pour gérer les versions de votre base de données et de votre application APEX avec Git et Liquibase (SQLcl).

## Architecture du projet

- `db/` : Contient tout le code de la base de données.
  - `changelog.xml` : Le fichier maître pour Liquibase. Il liste l'ordre d'exécution des scripts.
  - `tables/` : Les scripts d'évolution des tables (ajout de colonne, création de table). Ne détruisent pas les données.
  - `packages/`, `views/`, `functions/` : Le code PL/SQL. Ces fichiers sont écrasés et recompilés à chaque modification (runOnChange).
- `apex/` : Contient l'export de votre application APEX (découpé en multiples fichiers).
- `scripts/` : Contient les commandes `.bat` pour automatiser l'export et le déploiement.

## Le Scénario de l'exercice

Imaginez que vous êtes le développeur :
1. Vous avez créé une table `CLIENTS` (fichier `01_creer_table_client.sql`).
2. Plus tard, on vous demande d'ajouter un "Statut" au client. Vous n'allez PAS modifier le script 01, vous créez le `02_ajouter_colonne_statut.sql`.
3. Vous mettez à jour la logique de votre package `pkg_gestion_client.sql`.
4. Vous lancez `scripts/1_export_dev.bat` pour récupérer la dernière version de votre application APEX en fichiers texte.
5. Vous "Commitez" et "Pushez" sur Git.

Chez le client (Production) :
1. Vous récupérez le code depuis Git (`git pull`).
2. Vous lancez `scripts/2_deploy_prod.bat`.
3. Liquibase va :
   - Voir que `01_creer_table_client.sql` a déjà été exécuté la dernière fois, donc il l'ignore.
   - Voir que `02_ajouter_colonne_statut.sql` est nouveau. Il va exécuter ce script (ALTER TABLE) -> *Les données sont préservées !*
   - Recompiler `pkg_gestion_client.sql` pour mettre à jour la logique.
   - Importer l'application APEX pour mettre à jour les écrans.
