@echo off
echo ==========================================================
echo [APEX DEV] Export de l'Application APEX (Interface FR/EN)
echo ==========================================================

echo.
echo 1. Connexion a la base via SQLcl (Schema APEX : ORASSUIT)
echo ----------------------------------------------------------
REM Connexion securisee uniquement pour exporter l'application Front-End
REM (Le schema metier ORASSADM n'est pas exporte d'ici)

sql ORASSUIT/P@ssw0rd@192.168.108.134:1521/ORASSUITPDB ^
  -c "cd ../apex" ^
  -c "apex export -workspaceid ORASSUIT -applicationid 100 -split -expOriginalIds" ^
  -c "exit"

echo.
echo 2. Export termine ! L'application est decoupee dans /apex
echo.
echo 3. Prochaine etape (Partage via GitHub) :
echo git add .
echo git commit -m "Mise a jour interface APEX"
echo git push origin main
echo ==========================================================
pause
