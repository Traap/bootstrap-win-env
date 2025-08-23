@echo off
echo ========================================
echo 🚀 Setting up Windows 11 Dev Environment
echo ========================================

:: Enable UTF-8
chcp 65001

:: Update Winget Sources
echo 🔄 Updating winget sources...
winget source update

:: Install Git
echo 🧬 Installing Git...
winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements

:: Install Ruby
echo 💎 Installing Ruby...
winget install --id RubyInstallerTeam.RubyWithDevKit.3.2 -e --accept-package-agreements --accept-source-agreements

:: Install LaTeX (MiKTeX)
echo 📄 Installing LaTeX (MiKTeX)...
winget install --id MiKTeX.MiKTeX -e --accept-package-agreements --accept-source-agreements

:: Install Neovim
echo 🧠 Installing Neovim...
winget install --id Neovim.Neovim -e --accept-package-agreements --accept-source-agreements

:: Install SumatraPDF
echo 📘 Installing SumatraPDF...
winget install --id SumatraPDF.SumatraPDF -e --accept-package-agreements --accept-source-agreements

:: Install Visual Studio Code
echo 🖥️ Installing VS Code...
winget install --id Microsoft.VisualStudioCode -e --accept-package-agreements --accept-source-agreements

:: Optional: Install rbenv via Git clone (manual path setup needed)
:: Git clone will require user to add rbenv to PATH manually via system settings
REM echo 🔁 Cloning rbenv (optional; manual PATH setup required)
REM git clone https://github.com/rbenv/rbenv.git %USERPROFILE%\.rbenv

echo ========================================
echo ✅ Base software installations complete.
echo ========================================

:: Instructions for VS Code Extensions (manual script-based install below)
echo 🧩 Installing VS Code extensions...

:: VS Code CLI path may vary; ensure it's in PATH or use full path
call code --install-extension rebornix.Ruby
call code --install-extension wingrunr21.vscode-ruby
call code --install-extension james-yu.latex-workshop
call code --install-extension GitHub.vscode-pull-request-github
call code --install-extension Neovim.vim

echo ✅ VS Code extensions installed.

:: Optional: Install Ruby gems (e.g., rake)
echo 🔧 Installing Ruby rake gem...
gem install rake

echo ========================================
echo 🏁 All steps complete.
echo Please reboot and configure PATH if needed.
echo ========================================
pause

