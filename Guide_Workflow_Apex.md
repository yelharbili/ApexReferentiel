# Le Guide Pratique CI/CD pour APEX avec REST ORDS

## Le Workflow Collaboratif (Dev $\rightarrow$ Git)

Puisque tous les développeurs travaillent sur le même Workspace **ORASSUIT**, le risque est d'écraser le travail de l'autre ("Écrasement d'export"). Pour éviter ça :

1.  **Répartition du Travail** : Dans le chef de projet, on n'affecte **jamais** la même page APEX à deux développeurs différents en même temps.
    *   *Exemple :* Le dev A fait l'écran Contrats (Page 10). Le dev B fait l'écran Sinistres (Page 20).
2.  **Gestion des API REST (ORDS)** : Comme défini dans `03_orassadm_assurance.sql`, les vrais développements métiers (ajout de table, logique) se font en PL/SQL dans le schéma `ORASSADM`. Les développeurs versionnent ce code SQL dans Git (`/db/tables`, `/db/packages`).
3.  **L'Export Découpé (`-split`)** : C'est la commande la plus importante. Au lieu d'exporter un fichier monstrueux de 100 000 lignes (`f100.sql`), le script `1_export_dev.bat` utilise l'option `-split` de `sqlcl`.
    *   *Ce qui se passe :* L'application est découpée en des centaines de fichiers dans des dossiers (`/pages/page_0010.sql`, `/pages/page_0020.sql`).
    *   *L'avantage :* Quand les dev A et B vont "Pusher" sur Git, Git va voir que le dev A a modifié `page_0010.sql` et le dev B le fichier `page_0020.sql`. **Il n'y aura aucun conflit**, la fusion (Merge) se fera automatiquement.

## Le Déploiement Incrémentiel chez le Client (Git $\rightarrow$ Prod)

C'est ici que la magie opère pour **protéger les données existantes du client** :

1.  **Récupération du Code** : Sur le serveur du client, on récupère la branche principale via Git.
2.  **L'outil Liquibase (Intégré à SQLcl)** : C'est lui qui gère le schéma "Back-End" (ORASSADM).
    *   Liquibase lit le fichier `db/changelog.xml` et compare avec ce qui est déjà installé chez le client.
    *   S'il voit un nouveau fichier `02_ajouter_colonne_statut.sql` (qui contient un `ALTER TABLE`), **il exécute cet ALTER TABLE.** Les données (les 10 000 contrats historiques du client) sont conservées.
    *   S'il voit que le package `pkg_api_contrats` a été modifié, il fait un `CREATE OR REPLACE PACKAGE` pour mettre à jour la logique métier sans toucher à la table.
3.  **Installation de la nouvelle Application APEX (Front-End)** :
    *   Le script réimporte alors l'application APEX mise à jour chez le client (le dossier reconstitué de la version).
    *   **Pourquoi ça n'écrase pas les données ?** L'import APEX 1234.sql **ne contient que du metadata d'interface** (des boutons, des couleurs, des requêtes URL REST), **aucune data métier**. Le schéma APEX `ORASSUIT` ne sert qu'à l'affichage. L'ancienne application APEX est remplacée par la nouvelle, qui va pointer vers les mêmes API REST connectées à la base de données client.

## Les Prochaines Étapes pour votre Projet

1.  **Démarrer avec "SQLcl"** : C'est l'outil en ligne de commande (gratuit) d'Oracle. L'avez-vous déjà téléchargé sur votre machine Windows pour exécuter les fichiers `.bat` joints ?
2.  **Configurer Git** : Avez-vous déjà un **Repository (GitLab, GitHub, Bitbucket)** configuré pour ce projet d'Assurance sur lequel on pourrait faire le premier "Commit" (initialisation du projet) ?

Ce workflow séparant le "Front" HTTP (APEX-ORDS) du "Back" Data (ORASSADM) via Git et Liquibase est l'architecture la plus robuste disponible.
