@echo off
cd /d "%~dp0"
echo Staging new evidence + report updates...
git add -A
git -c user.name=Henoch -c user.email=okumagbeenoch4@gmail.com commit -m "Evidence update: live balances + supplement" 2>nul
if %errorlevel% neq 0 (
  echo Nothing new to commit.
) else (
  echo Committed. Pushing to origin main...
  git push origin main
)
echo.
echo Done. Press any key to close.
pause >nul
