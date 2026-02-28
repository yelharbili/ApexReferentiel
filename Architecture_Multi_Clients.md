# Architecture Editeur de Logiciel (ISV) - Deploiement Multi-Clients
# ===================================================================
# Ce document decrit la "gymnastique" complete :
# 1. Les devs travaillent sur APEX avec des schemas separes
# 2. Ils mergent vers un schema APEX principal (PROD)
# 3. On deploie chez les clients distants SANS toucher leurs donnees
# ===================================================================

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    VOTRE SERVEUR CENTRAL (192.168.108.134)             │
│                                                                       │
│  ┌──────────────────────────────────────────────────────────────┐     │
│  │          ORASSADM (Boite Noire - 1 seul Admin)               │     │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────────────────┐         │     │
│  │  │ Tables   │ │ Vues     │ │ Packages PL/SQL      │         │     │
│  │  │ Metier   │ │          │ │ (API JSON via ORDS)   │         │     │
│  │  └──────────┘ └──────────┘ └──────────────────────┘         │     │
│  │  GRANT EXECUTE sur les packages --> vers ORASSUIT_DEV1, etc. │     │
│  └──────────────────────────────────────────────────────────────┘     │
│        │ API REST (ORDS)     │ API REST      │ API REST              │
│        ▼                     ▼               ▼                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐               │
│  │ORASSUIT  │  │ORASSUIT  │  │ ORASSUIT             │               │
│  │_DEV1     │  │_DEV2     │  │ (MAIN = PRODUCTION)  │               │
│  │(Ahmed)   │  │(Sara)    │  │ (Version officielle) │               │
│  │Page 10   │  │Page 20   │  │ Toutes les pages     │               │
│  └────┬─────┘  └────┬─────┘  └──────────┬───────────┘               │
│       │              │                   │                           │
│       └──── Git ─────┘                   │                           │
│              │                           │                           │
│              ▼                           │                           │
│     ┌──────────────┐                     │                           │
│     │   GitHub     │ ◄──────────────────┘                           │
│     │  (main)      │     git push (version validee)                  │
│     └──────┬───────┘                                                 │
└────────────┼─────────────────────────────────────────────────────────┘
             │
             │  git pull + scripts de deploiement
             │
   ┌─────────┼──────────────────────────────────────────────┐
   │         ▼                                              │
   │  ┌─────────────────────────────────────────────────┐   │
   │  │       CLIENT A (Maroc)                          │   │
   │  │  ORASSADM : Ses propres donnees (450 contrats)  │   │
   │  │  ORASSUIT : Ancienne version APEX V1            │   │
   │  │                                                 │   │
   │  │  => On deploie :                                │   │
   │  │     1. Liquibase : ALTER TABLE (pas de DROP !)  │   │
   │  │     2. Import APEX : Nouvel ecran V2            │   │
   │  │  => Resultat : 450 contrats intacts + ecran V2  │   │
   │  └─────────────────────────────────────────────────┘   │
   │                                                        │
   │  ┌─────────────────────────────────────────────────┐   │
   │  │       CLIENT B (France)                         │   │
   │  │  ORASSADM : Ses propres donnees (12000 polices) │   │
   │  │  ORASSUIT : Ancienne version APEX V1            │   │
   │  │                                                 │   │
   │  │  => Meme deploiement, meme resultat             │   │
   │  │  => 12000 polices intactes + ecran V2           │   │
   │  └─────────────────────────────────────────────────┘   │
   │                                                        │
   │  ┌─────────────────────────────────────────────────┐   │
   │  │       CLIENT C (Tunisie)                        │   │
   │  │  ORASSADM : Ses propres donnees (800 sinistres) │   │
   │  │  ORASSUIT : Ancienne version APEX V1            │   │
   │  │                                                 │   │
   │  │  => Meme deploiement, meme resultat             │   │
   │  │  => 800 sinistres intacts + ecran V2            │   │
   │  └─────────────────────────────────────────────────┘   │
   └────────────────────────────────────────────────────────┘
```
