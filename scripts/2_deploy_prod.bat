@echo off
echo ===================================================
echo [PROD] Deploiement Incrementale chez le Client
echo ===================================================

echo 1. Synchronisation Git (Recuperation de la derniere version)
echo ---------------------------------------------------
git pull origin main
echo.

echo 2. Mise a jour structure base de donnees (LIQUIBASE) sans perte de donnees
echo ---------------------------------------------------
REM Liquibase est appele via SQLcl (la commande 'lb update')
sql schema_client/pass_client@ip_client:1521/XEPDB1 ^
  -c "cd ../db" ^
  -c "lb update -changelog changelog.xml" ^
  -c "exit"
echo.

echo 3. Mise a jour de l'application APEX (Ecrans)
echo ---------------------------------------------------
REM On importe l'application depuis le dossier split d'Apex
sql schema_client/pass_client@ip_client:1521/XEPDB1 ^
  -c "cd ../apex/f100" ^
  -c "@install.sql" ^
  -c "exit"

echo.
echo ===================================================
echo Deploiement termine avec succes chez le client !
echo ===================================================
pause
