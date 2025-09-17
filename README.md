# 🚀 Windows 11 Dev Environment Installer

This repository provides a reproducible Windows 11 development environment using
a single `install.cmd` script. It installs all tools using `winget` and runs
under **Command Prompt with administrative privileges**.
---
## ⚠️ TL;DR

Quick steps:
  1. Start a Git Bash shell and clone this repository
```cmd
git clone http://github.com/Traap/bootstrap-win-env
cd your-repo
```
  2. Change USERROOT in ```user-environment-variabvles.cfg```
  3. Start a command shell and run these commands
```command
set-user-environment-variables.cmd
set-user-path.cmd replace_userj
install.cmd
```
  4. Logout; your system is ready.  FYI:  Check for a valid .bashrc
  5. Start a Git Bash Shell to clone respositories and build documentation
```
  gits clone -v
  cd $AUTODOCPATH
  docbld list_files
  docbld
`
---

## 🔧 Requirements

- ✅ Windows 11 (with `winget` v1.4+ or newer)
- ✅ Run from **Command Prompt as Administrator**
- ❌ Does *not* use PowerShell
- ✅ Git and system PATH correctly configured
- ✅ UTF-8/CRLF line endings enforced via `.gitattributes`

---

## 📦 Tools Installed

The script installs:

- Git
- Ruby (with DevKit)
- MiKTeX LaTeX
- Neovim
- SumatraPDF
- Visual Studio Code
- Python 3
- Traap/gits CLI

---

## ▶️ How to Use

1. Open **Command Prompt as Administrator**
2. Clone this repo:
   ```cmd
   git clone https://github.com/your-user/your-repo.git
   cd your-repo
   ```
3. Run the installer:
   ```cmd
   install.cmd
   ```

---

## ⚙️ Post-Install Notes

- Ruby includes `rake` via `gem install`
- Python is installed with virtual environment support
- `gits` CLI is cloned into `%USERPROFILE%\gits` and installed into a virtualenv
- Visual Studio Code installs several extensions (e.g., Ruby, LaTeX, Neovim)

---

## 🪓 Uninstall

To uninstall everything, use the included `uninstall.cmd`:
```cmd
uninstall.cmd
```

- Supports `/dry-run` and logs to `uninstall.log`
- Prompts for confirmation before proceeding

---

## 🧪 Troubleshooting

- Ensure script line endings are **CRLF**
- Run:
  ```cmd
  where winget
  ```
  If not found in admin shell, add this to system PATH:
  ```
  %LocalAppData%\Microsoft\WindowsApps
  ```

---

## 📄 License
BSD 3-Clause License
