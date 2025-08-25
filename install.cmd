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

:: Install Git
echo 🧬 Installing Git...
%WINGET_INSTALL% Git.Git

:: Install Ruby
echo 💎 Installing Ruby...
%WINGET_INSTALL% RubyInstallerTeam.RubyWithDevKit.3.2

:: Install LaTeX (MiKTeX)
echo 📄 Installing LaTeX (MiKTeX)...
%WINGET_INSTALL% MiKTeX.MiKTeX

:: Install Neovim
echo 🧠 Installing Neovim...
%WINGET_INSTALL% Neovim.Neovim

:: Install SumatraPDF
echo 📘 Installing SumatraPDF...
%WINGET_INSTALL% SumatraPDF.SumatraPDF

:: Install developer command line and graphical tools
echo 🖥️ Installingbat...
%WINGET_INSTALL% sharkdp.bat

echo 🖥️ Installing Clink...
%WINGET_INSTALL% chrisant996.Clink

echo Installing
%WINGET_INSTALL% Flameshot.Flameshot

echo 🖥️ Installg fd...
%WINGET_INSTALL% sharkdp.fd

echo 🖥️ Installing fzf...
%WINGET_INSTALL% junegunn.fzf

echo 🖥️ Installing LazyGit...
%WINGET_INSTALL% JesseDuffield.lazygit

echo 🖥️ Installing Microsoft PowerToys...
%WINGET_INSTALL% Microsoft.PowerToys

echo 🖥️ Installing ripgrep...
%WINGET_INSTALL% BurntSushi.ripgrep.MSVC

echo 🖥️ Installing Yazi...
%WINGET_INSTALL% sxyazi.yazi

:: Install Visual Studio Code
echo 🖥️ Installing VS Code...
%WINGET_INSTALL% Microsoft.VisualStudioCode

:: Optional: Install rbenv via Git clone (manual path setup needed)
:: Git clone will require user to add rbenv to PATH manually via system settings
REM echo Cloning optional; manual PATH setup required)
REM git clone https://github.com/rbenv/rbenv.git %USERPROFILE%\.rbenv

:: Instructions for VS Code Extensions (manual script-based install below)
echo 🧩 Installing VS Code extensions...

:: VS Code CLI path may vary; ensure it's in PATH or use full path
call code --install-extension rebornix.Ruby
call code --install-extension wingrunr21.vscode-ruby
call code --install-extension james-yu.latex-workshop
call code --install-extension GitHub.vscode-pull-request-github
call code --install-extension Neovim.vim

echo ✅ VS Code extensions installed.

:: Install Python 3
echo 🐍 Installing Python 3...
%WINGET_INSTALL% Python.Python.3

:: Optional: Install Ruby gems (e.g., rake)
echo 🔧 Installing Ruby rake gem...
gem install rake

:: Clone gits CLI
echo 🧭 Cloning gits CLI...
git clone https://github.com/Traap/gits.git %USERPROFILE%\gits

:: Set up Python virtual environment
echo 🛠️ Setting up virtual environment...
cd %USERPROFILE%\gits
python -m venv .venv
call .venv\Scripts\activate.bat

:: Install gits dependencies
echo 📦 Installing gits dependencies...
pythone -m pip install --upgrade pip
pip install .

echo ========================================
echo ✅ All steps complete.
echo Please reboot and configure PATH if needed.
echo ========================================
pause
