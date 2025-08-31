@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM =============================================================================
REM Persist USER environment variables from user-environment-variables.cfg
REM  - Format: NAME=VALUE (one per line)
REM  - Ignores blank lines and lines starting with # or ;
REM  - Writes REG_EXPAND_SZ if VALUE contains %...%, else REG_SZ
REM  - Prevents %VAR% from expanding while parsing
REM  - Changes take effect in NEW shells
REM =============================================================================

set "LIST=%~dp0user-environment-variables.cfg"
if not exist "%LIST%" (
  echo ERROR: %LIST% not found.
  exit /b 1
)

REM --- Pass 0: Prevent %VAR% expansion while we parse
REM     We temporarily set each LHS name to the literal string "%NAME%"
REM     so that any %NAME% in RHS expands back to "%NAME%" (not to a path or empty).
for /f "usebackq tokens=1 delims== " %%A in ("%LIST%") do (
  set "raw=%%A"
  if not "!raw!"=="" if not "!raw:~0,1!"=="#" if not "!raw:~0,1!"==";" (
    set "%%A=%%%A%%"
  )
)
REM Also protect common system vars you reference (adjust if needed)
set "USERPROFILE=%%USERPROFILE%%"

REM --- Pass 1: Read and persist
for /f "usebackq tokens=* delims=" %%L in ("%LIST%") do (
  set "line=%%L"
  REM Skip blanks and comments
  if not "!line!"=="" if not "!line:~0,1!"=="#" if not "!line:~0,1!"==";" (
    REM Split NAME=VALUE (first '=' only)
    for /f "tokens=1* delims==" %%N in ("!line!") do (
      set "name=%%N"
      set "val=%%O"

      REM Trim leading spaces from name and value
      for /f "tokens=* delims= " %%X in ("!name!") do set "name=%%X"
      for /f "tokens=* delims= " %%Y in ("!val!")  do set "val=%%Y"

      if not "!name!"=="" (
        REM Decide value type
        set "type=REG_SZ"
        if not "!val:%=%!"=="!val!" set "type=REG_EXPAND_SZ"

        REM Write to HKCU\Environment (User variables)
        REM Using !val! ensures any %...% inside is NOT re-expanded at parse time.
        reg add "HKCU\Environment" /v "!name!" /t !type! /d "!val!" /f >nul
        if errorlevel 1 (
          echo Failed: !name!
        ) else (
          echo Set: !name!  [!type!]
        )
      )
    )
  )
)

echo(
echo Done. Open a NEW Command Prompt to see the new environment variables.
exit /b 0

