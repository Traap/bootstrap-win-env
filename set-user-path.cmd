@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ============================================================================
REM Update USER Path from user-path-segments.txt
REM   Usage:
REM     set-user-path.cmd               -> append mode (default)
REM     set-user-path.cmd append        -> append mode
REM     set-user-path.cmd replace_user  -> replace USER Path with file entries
REM Notes:
REM   - Input lines are assumed normalized to %VAR% (single percent).
REM   - Ignores blank lines and lines starting with # or ;
REM   - Dedupes case-insensitively against existing USER Path and within file
REM   - Writes REG_EXPAND_SZ to HKCU\Environment\Path (no setx truncation)
REM   - No admin required; affects USER Path only (System Path unchanged)
REM ============================================================================

REM ---- Mode selection
set "PATH_MODE=%~1"
if not defined PATH_MODE set "PATH_MODE=append"

REM ---- Input file (next to this script)
set "LIST=%~dp0user-path-segments.txt"
if not exist "%LIST%" (
  echo ERROR: %LIST% not found.
  exit /b 1
)

REM ---- Get existing USER Path (not combined with System Path)
set "USERPATH_OLD="
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul ^| find /I "Path"') do (
  set "USERPATH_OLD=%%B"
)

if /I "%PATH_MODE%"=="replace_user" (
  set "USERPATH_NEW="
) else (
  set "USERPATH_NEW=%USERPATH_OLD%"
)

REM ---- Helper: add a segment if not already present (case-insensitive)
REM Usage: call :AddSeg <segment>
REM Relies on USERPATH_NEW
goto :AfterFunc

:AddSeg
set "seg=%~1"

REM Trim leading spaces
for /f "tokens=* delims= " %%T in ("%seg%") do set "seg=%%T"

REM Skip if empty after trim
if "%seg%"=="" goto :eof

REM De-duplicate exact literal match (case-insensitive)
set "TMP=;%USERPATH_NEW%;"
if /I not "%TMP:;%seg%;=%"=="%TMP%" goto :eof

if defined USERPATH_NEW (
  set "USERPATH_NEW=%USERPATH_NEW%;%seg%"
) else (
  set "USERPATH_NEW=%seg%"
)
goto :eof

:AfterFunc

REM ---- Read each line from the list
for /f "usebackq tokens=* delims=" %%S in ("%LIST%") do (
  set "line=%%S"
  REM Skip blanks and comments (# or ;)
  if not "!line!"=="" if not "!line:~0,1!"=="#" if not "!line:~0,1!"==";" (
    call :AddSeg "%%S"
  )
)

REM ---- Optional: preview
echo.
echo --- New USER Path will be ---
echo %USERPATH_NEW%
echo -----------------------------
echo.

REM ---- Persist as REG_EXPAND_SZ (preserves %VAR% for expansion in new shells)
reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "%USERPATH_NEW%" /f >nul
if errorlevel 1 (
  echo ERROR: Failed to update HKCU\Environment\Path
  exit /b 1
)

echo ✅ USER Path updated in %PATH_MODE% mode from:
echo     %LIST%
echo    (Open a NEW Command Prompt to pick it up.)
exit /b 0

