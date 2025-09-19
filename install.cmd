@echo off
:: {{{ Initial greeting.

echo ========================================
echo 🚀 Setting up Windows 11 Dev Environment
echo ========================================

:: Enable UTF-8
chcp 65001

:: --------------------------------------------------------------------------}}}
:: {{{ Global winget install flags

set WINGET_INSTALL=winget install -e --accept-package-agreements --accept-source-agreements --id

:: --------------------------------------------------------------------------}}}
:: {{{ Update Winget Sources


echo 🔄 Updating winget sources...
winget source update
echo.

:: --------------------------------------------------------------------------}}}
:: {{{ Install programs using winget

:: Install Git
echo 🧬 Install in Git...
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
echo 🖥️ Installing bat...
call :install_with_prompt sharkdp.bat

echo 🖥️ Installing Clink...
call :install_with_prompt chrisant996.Clink

echo 🖥️ Installing Flameshot...
call :install_with_prompt Flameshot.Flameshot

echo 🖥️ Installing fastfetch...
call :install_with_prompt Fastfetch-cli.Fastfetch

echo 🖥️ Installing fd...
call :install_with_prompt sharkdp.fd

echo 🖥️ Installing fzf...
call :install_with_prompt junegunn.fzf

echo 🖥️ Installing LazyGit...
call :install_with_prompt JesseDuffield.lazygit

echo 🖥️ Installing Microsoft PowerToys...
call :install_with_prompt Microsoft.PowerToys

echo 🖥️ Installing ripgrep...
call :install_with_prompt BurntSushi.ripgrep.MSVC

echo 🖥️ Installing StrawberryPerl...
call :install_with_prompt StrawberryPerl.StrawberryPerl

echo 🖥️ Installing Yazi...
call :install_with_prompt sxyazi.yazi

:: Install Visual Studio Code
echo 🖥️ Installing VS Code...
call :install_with_prompt Microsoft.VisualStudioCode

:: --------------------------------------------------------------------------}}}
:: {{{ Install VS Code Extensions

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

:: --------------------------------------------------------------------------}}}
:: {{{ Install Python 3

echo 🐍 Installing Python 3...
call :guarded "Python.3" || goto :SKIP_Python_3
call :install_with_prompt Python.Python.3.13
:SKIP_Python_3

:: --------------------------------------------------------------------------}}}
:: {{{ Optional: Install Ruby gems (e.g., rake)

echo 🔧 Installing Ruby rake gem...
call :guarded "Gem.Rake" || goto :SKIP_Gem_Rake
gem install rake
:SKIP_Gem_Rake

:: --------------------------------------------------------------------------}}}
:: {{{ Clone gits CLI

echo 🧭 Cloning gits CLI...
call :guarded "Gits.CLI" || goto :SKIP_GITS_CLI
git clone https://github.com/Traap/gits.git %USERPROFILE%\gits
:SKIP_GITS_CLI

:: --------------------------------------------------------------------------}}}
:: {{{ Set up Python virtual environment

echo 🛠️ Setting up virtual environment...
call :guarded "Python.virtual.environment" || goto :SKIP_Python_virtual_environment
cd %USERPROFILE%\gits
python -m venv .venv
call .venv\Scripts\activate.bat
:SKIP_Python_virtual_environment

:: --------------------------------------------------------------------------}}}
:: {{{ Install gits dependencies

echo 📦 Installing Python pip...
call :guarded "Python.Pip" || goto :SKIP_Python_pip
python -m pip install --upgrade pip
pip install .
:SKIP_Python_pip

:: --------------------------------------------------------------------------}}}
:: {{{ Copy repository_locations.yml if it doesn't already exist

echo 📁 Checking for repository_locations.yml...
call :guarded "Repository.locations" || goto :SKIP_Repository_locations
set "SRC_FILE=%~dp0repository_locations.yml"
set "DEST_DIR=%USERPROFILE%\.config\gits"
set "DEST_FILE=%DEST_DIR%\repository_locations.yml"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"
:SKIP_Repository_locations

:: --------------------------------------------------------------------------}}}
:: {{{ Copy .bashrc it doesn't already exist

echo 📁 Checking for .bashrc
call :guarded ".bashrc" || goto :SKIP_bashrc
set "DEST_DIR=%USERPROFILE%"

set "SRC_FILE=%~dp0.bash_profile"
set "DEST_FILE=%DEST_DIR%\.bash_profile"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"

set "SRC_FILE=%~dp0.bashrc"
set "DEST_FILE=%DEST_DIR%\.bashrc"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"

set "SRC_FILE=%~dp0.bashrc_personal"
set "DEST_FILE=%DEST_DIR%\.bashrc_personal"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"

set "SRC_FILE=%~dp0.bash_logout"
set "DEST_FILE=%DEST_DIR%\.bash_logout"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"

:SKIP_bashrc

:: --------------------------------------------------------------------------}}}
:: {{{ Copy .inputrc it doesn't already exist

echo 📁 Checking for .inputrc
call :guarded ".inputrc" || goto :SKIP_inputrc
set "SRC_FILE=%~dp0.inputrc"
set "DEST_DIR=%USERPROFILE%"
set "DEST_FILE=%DEST_DIR%\.inputrc"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"
:SKIP_inputrc

:: --------------------------------------------------------------------------}}}
:: {{{ Copy newdoc it doesn't already exist

echo 📁 Checking for newdoc
call :guarded "docbld" || goto :SKIP_docbld
set "SRC_FILE=%~dp0docbld"
set "DEST_DIR=%USERPROFILE%\.local\bin"
set "DEST_FILE=%DEST_DIR%\docbld"
call :copy_with_prompt "%SRC_FILE%" "%DEST_DIR%"
:SKIP_docbld

:: --------------------------------------------------------------------------}}}
:: {{{ Final message.

echo ========================================
echo ✅ All steps complete.
echo Please reboot and configure PATH if needed.
echo ========================================
pause
goto :EOF

:: --------------------------------------------------------------------------}}}
:: {{{ Subroutine: install_with_prompt

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

:: --------------------------------------------------------------------------}}}
:: {{{ Subroutine: guarded
::     Usage: call :guarded "Label"
::     Returns 0 to proceed, 1 to skip

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

:: --------------------------------------------------------------------------}}}
:: {{{ Subroutine: copy_with_prompt
::     Usage: call copy_with_prompt "src_file", "dest_file", "dest_dir"
::     Returns 0 to proceed, 1 to skip

:copy_with_prompt
setlocal

set "SRC=%~1"
set "DST=%~2"

rem Extract filename only from source path
for %%F in ("%SRC%") do set "FILENAME=%%~nxF"

rem Ensure destination path points to full file, not just directory
if exist "%DST%\" (
  set "DST=%DST%\%FILENAME%"
)

if exist "%DST%" (
  echo ❗ %DST% already exists.
  set /p ANSWER=Overwrite with %SRC%? [y/N]:
  if /I "%ANSWER%"=="N" (
    echo ❌ Skipped %FILENAME%
    echo.
    endlocal & exit /b 1
  )
)

echo 📝 Copying %SRC% → %DST%
copy /Y "%SRC%" "%DST%" >nul
echo.
endlocal & exit /b 0

:: --------------------------------------------------------------------------}}}
