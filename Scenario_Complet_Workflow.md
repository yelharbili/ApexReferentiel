# Scenario Complet : Workflow Collaboratif APEX de A a Z
# ========================================================
# Deux developpeurs (Ahmed et Sara) travaillent en parallele
# sur la meme application d'Assurance.
# Ce document montre CHAQUE etape, CHAQUE commande.
# ========================================================


## Les Acteurs

| Role | Nom | Workspace APEX | Schema DB | Travail assigne |
|------|------|----------------|-----------|-----------------|
| Admin (vous) | Yassine | ORASSUIT (PROD) | ORASSADM | Boite noire (API PL/SQL) |
| Dev Front 1 | Ahmed | ORASSUIT_DEV1 | ORASSUIT_DEV1 | Page 10 : Liste des Clients |
| Dev Front 2 | Sara | ORASSUIT_DEV2 | ORASSUIT_DEV2 | Page 20 : Liste des Contrats |


---


## JOUR 0 : L'Admin (Yassine) prepare tout


### 0.1 Executer le script de creation des Workspaces

```sql
-- Sur le serveur 192.168.108.134, en tant que SYS ou ADMIN APEX
-- Executer le fichier : scripts/0_setup_workspaces_devs.sql
-- Cela cree les schemas ORASSUIT_DEV1 et ORASSUIT_DEV2
-- et leur donne acces en lecture aux API de ORASSADM
```

### 0.2 Chaque dev clone le depot Git sur son PC

**Sur le PC d'Ahmed :**
```bash
cd C:\Projets
git clone https://github.com/yelharbili/ApexReferentiel.git
cd ApexReferentiel
```

**Sur le PC de Sara :**
```bash
cd C:\Projets
git clone https://github.com/yelharbili/ApexReferentiel.git
cd ApexReferentiel
```

> A ce stade, Ahmed et Sara ont **exactement le meme contenu** sur leur PC.


---


## JOUR 1 : Ahmed cree la Page "Liste des Clients"


### 1.1 Ahmed ouvre son navigateur et se connecte a APEX

```
URL      : http://192.168.108.134:8080/ords/orassuit_dev1
Workspace: ORASSUIT_DEV1
Login    : AHMED
Password : Ahmed_2026
```

### 1.2 Ahmed cree une nouvelle Application APEX

- Nom : **Assurance ORASSUIT**
- Application ID : **100** (important : tout le monde utilise le meme ID)

### 1.3 Ahmed cree la Page 10 : Liste des Clients

Dans APEX App Builder :
1. Creer Page > **Interactive Report**
2. Nom : "Liste des Clients"
3. Numero de page : **10**
4. Source Type : **REST Data Source** (Option A - ORDS)
5. URL Endpoint : `http://192.168.108.134:8080/ords/assurances_api/contrats/get_contrats_json`
6. Ahmed personnalise les colonnes, ajoute un bouton "Ajouter Client", etc.
7. **Save & Run** -> L'ecran fonctionne !

### 1.4 Ahmed exporte son travail en fichiers texte

Ahmed ouvre un terminal (CMD) sur son PC :

```bash
cd C:\Projets\ApexReferentiel

# Exporter l'application APEX en mode "split" (decoupe)
sql ORASSUIT_DEV1/Dev1_2026@192.168.108.134:1521/ORASSUITPDB

# Dans SQLcl :
cd apex
apex export -applicationid 100 -split -expOriginalIds
exit
```

**Resultat :** Un dossier `apex/f100/` est cree avec plein de fichiers :
```
apex/
  f100/
    install.sql            <- Le fichier maitre
    application/
      pages/
        page_00010.sql     <- La page d'Ahmed (Liste Clients)
      shared_components/
        navigation/
        security/
        ...
```

### 1.5 Ahmed enregistre dans Git et partage

```bash
cd C:\Projets\ApexReferentiel

git add .
git commit -m "feat(ahmed): Page 10 - Liste des Clients avec REST ORDS"
git push origin main
```

> **A ce moment sur GitHub :** Le depot contient la Page 10 d'Ahmed.
> Sara n'a pas encore commence.


---


## JOUR 2 : Sara commence son travail (et recupere celui d'Ahmed)


### 2.1 Sara recupere les dernieres modifications

**AVANT de commencer a travailler, Sara fait TOUJOURS :**

```bash
cd C:\Projets\ApexReferentiel
git pull origin main
```

> Sara a maintenant sur son PC le dossier `apex/f100/` avec la Page 10 d'Ahmed.

### 2.2 Sara importe l'application dans SON workspace

Sara doit d'abord avoir l'application dans son propre environnement APEX :

```bash
sql ORASSUIT_DEV2/Dev2_2026@192.168.108.134:1521/ORASSUITPDB

# Dans SQLcl :
cd apex/f100
@install.sql
exit
```

> L'application 100 est maintenant installee dans le workspace de Sara.
> Elle peut voir la Page 10 d'Ahmed qui est deja la.

### 2.3 Sara ouvre APEX et cree la Page 20

```
URL      : http://192.168.108.134:8080/ords/orassuit_dev2
Workspace: ORASSUIT_DEV2
Login    : SARA
Password : Sara_2026
```

Sara ouvre l'Application 100 > App Builder :
1. Creer Page > **Interactive Report**
2. Nom : "Liste des Contrats"
3. Numero de page : **20**
4. Source Type : **REST Data Source**
5. URL Endpoint : `http://192.168.108.134:8080/ords/assurances_api/contrats/get_contrats_json`
6. Sara ajoute des filtres par type d'assurance (AUTO, SANTE, HABITATION)
7. **Save & Run** -> L'ecran fonctionne !

### 2.4 Sara exporte et partage

```bash
cd C:\Projets\ApexReferentiel

# Exporter depuis SON workspace
sql ORASSUIT_DEV2/Dev2_2026@192.168.108.134:1521/ORASSUITPDB

# Dans SQLcl :
cd apex
apex export -applicationid 100 -split -expOriginalIds
exit
```

**Resultat :** Le dossier `apex/f100/` contient maintenant :
```
apex/f100/application/pages/
    page_00010.sql     <- Page d'Ahmed (pas touchee)
    page_00020.sql     <- NOUVELLE page de Sara
```

```bash
git add .
git commit -m "feat(sara): Page 20 - Liste des Contrats avec filtres"
git push origin main
```

> **A ce moment sur GitHub :** Le depot contient la Page 10 (Ahmed) + Page 20 (Sara).


---


## JOUR 3 : Ahmed recupere le travail de Sara et continue


### 3.1 Ahmed recupere les modifications de Sara

```bash
cd C:\Projets\ApexReferentiel
git pull origin main
```

> Ahmed voit dans le log Git : "feat(sara): Page 20 - Liste des Contrats avec filtres"
> Le fichier `page_00020.sql` est apparu dans son dossier.

### 3.2 Ahmed reimporte l'application (qui inclut maintenant la Page 20)

```bash
sql ORASSUIT_DEV1/Dev1_2026@192.168.108.134:1521/ORASSUITPDB

cd apex/f100
@install.sql
exit
```

> Ahmed ouvre APEX dans son navigateur :
> - Page 10 (Liste Clients) : SA page, toujours la !
> - Page 20 (Liste Contrats) : La page de Sara est apparue !
> Tout fonctionne ensemble.

### 3.3 Ahmed ameliore sa Page 10

Ahmed ajoute un bouton "Voir Contrats" sur la Page 10 qui redirige vers la Page 20 de Sara.

Il re-exporte :

```bash
sql ORASSUIT_DEV1/Dev1_2026@192.168.108.134:1521/ORASSUITPDB
cd apex
apex export -applicationid 100 -split -expOriginalIds
exit

git add .
git commit -m "feat(ahmed): Page 10 - Ajout bouton navigation vers Page 20"
git push origin main
```


---


## JOUR 4 : L'Admin valide et installe sur le Workspace PRODUCTION


### 4.1 Yassine (Admin) recupere la version finale

```bash
cd C:\Projets\ApexReferentiel
git pull origin main
```

### 4.2 Yassine installe dans le Workspace de PRODUCTION

```bash
sql ORASSUIT/P@ssw0rd@192.168.108.134:1521/ORASSUITPDB

cd apex/f100
@install.sql
exit
```

> Le workspace ORASSUIT (PRODUCTION) contient maintenant :
>   - Page 10 (Ahmed) + Page 20 (Sara)
>   - Tout est connecte aux API REST de ORASSADM

### 4.3 Yassine teste la version dans le Workspace PRODUCTION

```
URL      : http://192.168.108.134:8080/ords/orassuit
Workspace: ORASSUIT
Login    : ADMIN
Password : P@ssw0rd
```

> Tout fonctionne ! La version est validee pour les clients.


---


## JOUR 5 : Deploiement chez les Clients (SANS toucher leurs donnees)


### 5.1 Client A - Maroc (Premiere installation)

L'Admin se connecte au serveur du Client A et execute :

```bash
# 1. Cloner le depot (premiere fois)
git clone https://github.com/yelharbili/ApexReferentiel.git
cd ApexReferentiel

# 2. Installer la structure de la base (Liquibase)
sql ORASSADM_CLIENT/pass@ip_client_maroc:1521/ORASSUITPDB
cd db
lb update -changelog changelog.xml
exit

# 3. Installer l'application APEX
sql ORASSUIT_CLIENT/pass@ip_client_maroc:1521/ORASSUITPDB
cd apex/f100
@install.sql
exit
```

> Le Client A au Maroc a maintenant l'application complete V1.
> Il commence a saisir ses donnees (clients, contrats, sinistres).


### 5.2 Trois mois plus tard : Mise a jour V2 chez le Client A

Pendant ces 3 mois, Ahmed et Sara ont ajoute :
- Page 30 : Ecran des Sinistres
- Une nouvelle colonne `numero_police` dans la table `ass_contrats`

L'Admin se reconnecte au serveur du Client A :

```bash
cd ApexReferentiel

# 1. Recuperer la V2
git pull origin main

# 2. Liquibase met a jour la base
sql ORASSADM_CLIENT/pass@ip_client_maroc:1521/ORASSUITPDB
cd db
lb update -changelog changelog.xml
exit
# -> Liquibase voit que les tables V1 existent deja => il les IGNORE
# -> Liquibase voit le nouveau "ALTER TABLE ADD numero_police" => il l'EXECUTE
# -> Les 450 contrats existants du client sont INTACTS
# -> La colonne numero_police est ajoutee (vide pour les anciens contrats)

# 3. Installer la nouvelle application APEX
sql ORASSUIT_CLIENT/pass@ip_client_maroc:1521/ORASSUITPDB
cd apex/f100
@install.sql
exit
# -> Les anciens ecrans sont remplaces par les nouveaux
# -> Page 30 (Sinistres) apparait automatiquement
# -> AUCUNE donnee n'est effacee
```

> **Resultat chez le Client A :**
> - 450 contrats du client : TOUS LA, intacts !
> - Nouvelle colonne `numero_police` : ajoutee, vide pour les anciens
> - Nouvel ecran Sinistres (Page 30) : disponible immediatement
> - Le client ne voit AUCUNE interruption de service


### 5.3 Meme operation pour le Client B (France) et Client C (Tunisie)

Exactement les memes 3 commandes (git pull + lb update + @install.sql).
Chaque client garde ses propres donnees. La gymnastique est identique.


---


## Resume : La Regle d'Or

```
           AHMED                    SARA
         (Dev Front 1)           (Dev Front 2)
              |                       |
    Modifie Page 10          Modifie Page 20
              |                       |
         git push                git push
              |                       |
              +----> GITHUB <---------+
                       |
                  git pull (Admin)
                       |
              Installe sur PROD (ORASSUIT)
                       |
                  Teste et Valide
                       |
          +------------+------------+
          |            |            |
     Client A    Client B    Client C
     (Maroc)     (France)    (Tunisie)
          |            |            |
    git pull      git pull     git pull
    lb update     lb update    lb update
    @install      @install     @install
          |            |            |
    Donnees       Donnees      Donnees
    INTACTES      INTACTES     INTACTES
```
