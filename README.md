# 🚀 Windows 11 Developer Environment Setup (`setup.cmd`)

This repository provides a fully automated script to configure a complete developer environment on **Windows 11** using only **Command Prompt with Admin privileges** and `winget`.

---

## 🔒 Constraints

- ✅ Runs from **Command Prompt as Administrator**
- ❌ **No PowerShell**
- ✅ Uses `winget` for all package installations
- ✅ Avoids GUI/manual installers where possible

---

## 🧰 Programs Installed

| Tool                | Description                          |
|---------------------|--------------------------------------|
| **Ruby**            | For scripting, automation, and Rake  |
| **Ruby Rake**       | Task runner via `gem install rake`   |
| **Git**             | Version control                      |
| **LaTeX (MiKTeX)**  | PDF generation and TeX processing    |
| **Neovim**          | Modern terminal-based code editor    |
| **SumatraPDF**      | Lightweight PDF viewer               |
| **Visual Studio Code** | GUI code editor                  |
| **VS Code Extensions** | Support for Ruby, LaTeX, Git, Neovim |

---

## 📂 File: `setup.cmd`

This batch file automates installation using `winget`. You must **run it as Administrator**:

### ✔️ How to Run

```cmd
:: Open Command Prompt as Administrator
cd path\to\this\repo
setup.cmd
```

---

## 📦 What the Script Does

1. Ensures UTF-8 encoding with `chcp 65001`
2. Updates winget sources
3. Installs:
   - Ruby (via RubyInstaller with DevKit)
   - Rake (via `gem install`)
   - Git
   - Neovim
   - LaTeX (MiKTeX)
   - SumatraPDF
   - Visual Studio Code
4. Installs VS Code Extensions:
   - `rebornix.Ruby`
   - `wingrunr21.vscode-ruby`
   - `james-yu.latex-workshop`
   - `GitHub.vscode-pull-request-github`
   - `Neovim.vim`

---

## 🛠️ After Script Finishes

### ✅ Post-install Checklist

| Task                           | Command / Instruction                                                                 |
|--------------------------------|----------------------------------------------------------------------------------------|
| Confirm `code` is in PATH      | VS Code → `Ctrl+Shift+P` → `Shell Command: Install 'code' command in PATH`            |
| Test Ruby                      | `ruby -v`, `gem list`, `rake -T`                                                      |
| Test Neovim                    | `nvim` (ensure config opens)                                                         |
| Verify LaTeX                   | `pdflatex --version`                                                                  |
| Test Git                       | `git --version`                                                                       |
| Check SumatraPDF               | Should appear in Start Menu or run: `start SumatraPDF`                                |

---

## 📦 Additional Notes

- Ruby version managers like `rbenv` are Unix-focused. RubyInstaller is recommended for Windows.
- To customize Neovim:
  - `%LOCALAPPDATA%\nvim\init.lua` or `~\AppData\Local\nvim`
- To add more LaTeX packages:
  - Use MiKTeX GUI or `mpm` CLI
- Make sure `winget` is updated before re-running the script

---

## 🧪 Example Validation

```cmd
ruby -v
rake -V
git --version
nvim --version
pdflatex --version
code --list-extensions
```

---

## 📁 Suggested Directories

| Folder                             | Purpose                      |
|------------------------------------|------------------------------|
| `%USERPROFILE%\projects`          | Store your code projects     |
| `%USERPROFILE%\.rbenv`            | If using rbenv manually      |
| `%USERPROFILE%\AppData\Local\nvim` | Neovim config             |
| `%USERPROFILE%\.vscode\extensions` | VS Code extensions cache  |

---

## 📄 License
BSD 3-Clause License

