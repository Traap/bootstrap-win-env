@echo off
chcp 65001

echo ========================================
echo ⚠️  WARNING: This will uninstall all developer tools
echo installed by install.cmd, including your gits CLI.
echo.
set /p CONFIRM=Do you want to proceed? (Y/N): 
if /I NOT "%CONFIRM%"=="Y" (
    echo ❌ Uninstall cancelled.
    exit /b
)
:: ----------------------------------------
:: Enable dry-run and logging
set DRY_RUN=0
set LOGFILE=%USERPROFILE%\uninstall.log

:: Check for /dry-run argument
for %%x in (%*) do (
  if "%%x"=="/dry-run" (
    set DRY_RUN=1
    echo 💡 Running in DRY-RUN mode >> "%LOGFILE%"
  )
)

:: Logging helper macro
setlocal EnableDelayedExpansion
set EXECUTE=call :log_and_run

:: ----------------------------------------
:: Function to echo, log, and optionally run a command
:log_and_run
echo ➤ %* >> "%LOGFILE%"
if %DRY_RUN%==0 (
  %*
) else (
  echo (DRY-RUN) %*
)
exit /b

@echo off
echo ========================================
echo 🧹 Uninstalling Developer Tools
echo ========================================

chcp 65001

:: ----------------------------------------
:: Uninstall applications via winget
echo 🔽 Uninstalling programs installed by setup.cmd...

%EXECUTE% winget uninstall --id RubyInstallerTeam.RubyWithDevKit.3.2 -e
%EXECUTE% winget uninstall --id Git.Git -e
%EXECUTE% winget uninstall --id Neovim.Neovim -e
%EXECUTE% winget uninstall --id MiKTeX.MiKTeX -e
%EXECUTE% winget uninstall --id SumatraPDF.SumatraPDF -e
%EXECUTE% winget uninstall --id Microsoft.VisualStudioCode -e
%EXECUTE% winget uninstall --id Python.Python.3 -e

:: ----------------------------------------
:: Remove gits CLI directory
echo 🗑️ Removing gits CLI folder...
%EXECUTE% rmdir /s /q %USERPROFILE%\gits

:: ----------------------------------------
:: Optional config cleanup
echo 🗑️ Cleaning up config folders...
%EXECUTE% rmdir /s /q %USERPROFILE%\.vscode
%EXECUTE% rmdir /s /q %USERPROFILE%\AppData\Local\nvim

echo ✅ Uninstall complete. You may wish to reboot.
pause
