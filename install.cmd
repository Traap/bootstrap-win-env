@echo off
echo ========================================
echo 🚀 Setting up Windows 11 Dev Environment
echo ========================================

:: Enable UTF-8
chcp 65001

:: Global winget install flags
set WINGET_INSTALL=winget install -e --accept-package-agreements --accept-source-agreements --id

:: Update Winget Sources
echo 🔄 Updating winget sources...
winget source update
echo.

:: Install Git
echo 🧬 Installing Git...
call :install_with_prompt Git.Git

:: Install Ruby
echo 💎 Installing Ruby...
call :install_with_prompt RubyInstallerTeam.RubyWithDevKit.3.2

:: Install LaTeX (MiKTeX)
echo 📄 Installing LaTeX (MiKTeX)...
call :install_with_prompt MiKTeX.MiKTeX

:: Install Neovim
echo 🧠 Installing Neovim...
call :install_with_prompt Neovim.Neovim

:: Install SumatraPDF
echo 📘 Installing SumatraPDF...
call :install_with_prompt SumatraPDF.SumatraPDF

:: Install developer command line and graphical tools
echo 🖥️ Installingbat...
call :install_with_prompt sharkdp.bat

echo 🖥️ Installing Clink...
call :install_with_prompt chrisant996.Clink

echo 🖥️ Installg Flameshot...
call :install_with_prompt Flameshot.Flameshot

echo 🖥️ Installg fastfetch...
call :install_with_prompt Fastfetch-cli.Fastfetch

echo 🖥️ Installg fd...
call :install_with_prompt sharkdp.fd

echo 🖥️ Installing fzf...
call :install_with_prompt junegunn.fzf

echo 🖥️ Installing LazyGit...
call :install_with_prompt JesseDuffield.lazygit

echo 🖥️ Installing Microsoft PowerToys...
call :install_with_prompt Microsoft.PowerToys

echo 🖥️ Installing ripgrep...
call :install_with_prompt BurntSushi.ripgrep.MSVC

echo 🖥️ Inslalling StrawberryPerl...
call :install_with_prompt StrawberryPerl.StrawberryPerl

echo 🖥️ Installing Yazi...
call :install_with_prompt sxyazi.yazi

:: Install Visual Studio Code
echo 🖥️ Installing VS Code...
call :install_with_prompt Microsoft.VisualStudioCode

:: Optional: Install rbenv via Git clone (manual path setup needed)
:: Git clone will require user to add rbenv to PATH manually via system settings
:: echo Cloning optional; manual PATH setup required)
:: git clone https://github.com/rbenv/rbenv.git %USERPROFILE%\.rbenv

:: Install VS Code Extensions
:: VS Code CLI path may vary; ensure it's in PATH or use full path
echo 🧩 Installing VS Code extensions...
call :guarded "VS.Code.Extensions" || goto :SKIP_VS_Code_Extensions
call code --install-extension "rebornix.Ruby"
call code --install-extension "wingrunr21.vscode-ruby"
call code --install-extension "james-yu.latex-workshop"
call code --install-extension "GitHub.vscode-pull-request-github"
call code --install-extension "Neovim.vim"
echo ✅ VS Code extensions installed.
:SKIP_VS_Code_Extensions

:: Install Python 3
echo 🐍 Installing Python 3...
call :guarded "Python.3" || goto :SKIP_Python_3
call :install_with_prompt Python.Python.3
:SKIP_Python_3

:: Optional: Install Ruby gems (e.g., rake)
echo 🔧 Installing Ruby rake gem...
call :guarded "Gem.Rake" || goto :SKIP_Gem_Rake
gem install rake
:SKIP_Gem_Rake

:: Clone gits CLI
echo 🧭 Cloning gits CLI...
call :guarded "Gits.CLI" || goto :SKIP_GITS_CLI
git clone https://github.com/Traap/gits.git %USERPROFILE%\gits
:SKIP_GITS_CLI

:: Set up Python virtual environment
echo 🛠️ Setting up virtual environment...
call :guarded "Python.virtual.environment" || goto :SKIP_Python_virtual_environment
cd %USERPROFILE%\gits
python -m venv .venv
call .venv\Scripts\activate.bat
:SKIP_Python_virtual_environment

:: Install gits dependencies
echo 📦 Installing Python pip...
call :guarded "Python.Pip" || goto :SKIP_Python_pip
python -m pip install --upgrade pip
pip install .
:SKIP_Python_pip

:: Copy repository_locations.yml if it doesn't already exist
echo 📁 Checking for repository_locations.yml...
call :guarded "Repository.locations" || goto :SKIP_Repository_locations
set "SRC_FILE=%~dp0repository_locations.yml"
set "DEST_DIR=%USERPROFILE%\.config\gits"
set "DEST_FILE=%DEST_DIR%\repository_locations.yml"

if exist "%DEST_FILE%" (
  echo ⚠️  File already exists: "%DEST_FILE%"
  set /p ANSWER=Do you want to overwrite it? [y/N]:
  if /I "%ANSWER%"=="N" (
    echo ❌ Skipping copy.
  ) else (
    echo 📄 Copying file to "%DEST_FILE%"
    copy /Y "%SRC_FILE%" "%DEST_FILE%"
  )
) else (
  if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
  )
  echo 📄 Copying file to "%DEST_FILE%"
  copy /Y "%SRC_FILE%" "%DEST_FILE%"
)
:SKIP_Repository_locations

echo ========================================
echo ✅ All steps complete.
echo Please reboot and configure PATH if needed.
echo ========================================
pause
goto :EOF

:: ----------------------------------------
:: Subroutine: install_with_prompt
:install_with_prompt
:: %1 = winget package ID (e.g., Git.Git)
set "PKG=%~1"
set /p ANSWER=Install "%PKG%?" [y/N]:
if /I "%ANSWER%"=="N" (
  echo ❌ Skipped %PKG%
  echo.
  exit /b
)

echo 🛠 Installing %PKG%...
%WINGET_INSTALL% %PKG%
echo.
exit /b

:: ----------------------------------------
:: Subroutine: guarded
:: Usage: call :guarded "Label"
:: Returns 0 to proceed, 1 to skip
:guarded
set "GUARD_LABEL=%~1"

set /p ANSWER=Install "%GUARD_LABEL%"? [y/N]:
if /I "%ANSWER%"=="N" (
  echo ❌ Skipped %GUARD_LABEL%
  echo.
  exit /b 1
)

echo ✅ Installing %GUARD_LABEL%...
echo.
exit /b 0
