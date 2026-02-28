@echo off
echo ===================================================
echo [DEV] Export de la Base de Donnees et de l'App APEX
echo ===================================================

echo 1. Connexion a l'environnement de DEV avec SQLcl
echo ---------------------------------------------------
REM Remplacez hr/hr@dev_db par vos identifiants de DEV
REM Cette commande va generer un export complet et decoupe (split) de l'application APEX 100

sql orassuser/orsys2026@192.168.1.13:1521/XEPDB1 ^
  -c "cd ../apex" ^
  -c "apex export -applicationid 100 -split -expOriginalIds" ^
  -c "exit"

echo.
echo 2. Export termine avec succes au format Split dans le dossier /apex !
echo.
echo 3. Prochaine etape :
echo git add .
echo git commit -m "Export V2 avec la nouvelle table et l'ecran client"
echo git push origin main
echo ===================================================
pause
