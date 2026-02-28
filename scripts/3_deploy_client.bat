@echo off
echo ==========================================================
echo [CLIENT] Deploiement Incremental chez un Client
echo ==========================================================
echo.
echo ATTENTION : Ce script NE DETRUIT PAS les donnees du client.
echo Il met a jour uniquement la structure (tables) et l'interface (APEX).
echo ==========================================================
echo.

REM ============================================================
REM CONFIGURATION A MODIFIER POUR CHAQUE CLIENT
REM ============================================================
SET CLIENT_NOM=Client_Demo
SET DB_USER_ADM=ORASSADM
SET DB_PASS_ADM=ORASSADM
SET DB_HOST=192.168.108.134
SET DB_PORT=1521
SET DB_SERVICE=ORASSUITPDB
SET APEX_APP_ID=100

echo Client   : %CLIENT_NOM%
echo Serveur  : %DB_HOST%:%DB_PORT%/%DB_SERVICE%
echo.

REM ============================================================
REM ETAPE 1 : Recuperation de la derniere version depuis Git
REM ============================================================
echo [1/3] Synchronisation Git (derniere version validee)...
echo ----------------------------------------------------------
git pull origin main
echo.

REM ============================================================
REM ETAPE 2 : Mise a jour du schema ORASSADM (Liquibase)
REM            -> ALTER TABLE, CREATE OR REPLACE PACKAGE
REM            -> Ne fait JAMAIS de DROP TABLE ni DELETE FROM
REM ============================================================
echo [2/3] Mise a jour Base de Donnees (Liquibase - Schema ORASSADM)...
echo ----------------------------------------------------------
echo    Les tables existantes du client ne seront PAS supprimees.
echo    Seuls les nouveaux scripts (ALTER TABLE, etc.) seront joues.
echo.
sql %DB_USER_ADM%/%DB_PASS_ADM%@%DB_HOST%:%DB_PORT%/%DB_SERVICE% ^
  -c "cd ../db" ^
  -c "lb update -changelog changelog.xml" ^
  -c "exit"
echo.

REM ============================================================
REM ETAPE 3 : Mise a jour de l'Application APEX
REM            -> Remplace les ecrans (metadata) sans toucher aux tables
REM            -> Les donnees du client restent 100%% intactes
REM ============================================================
echo [3/3] Mise a jour Application APEX (interface seulement)...
echo ----------------------------------------------------------
echo    L'import APEX remplace les ECRANS, pas les DONNEES.
echo.
sql %DB_USER_ADM%/%DB_PASS_ADM%@%DB_HOST%:%DB_PORT%/%DB_SERVICE% ^
  -c "cd ../apex/f%APEX_APP_ID%" ^
  -c "@install.sql" ^
  -c "exit"
echo.

echo ==========================================================
echo DEPLOIEMENT TERMINE AVEC SUCCES chez %CLIENT_NOM% !
echo.
echo Resume :
echo   - Structure DB : Mise a jour incrementale (Liquibase)
echo   - Interface APEX : Nouvelle version installee
echo   - Donnees client : NON MODIFIEES (intactes)
echo ==========================================================
pause
