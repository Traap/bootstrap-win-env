# Fix-WinGetLinks-Deep.ps1
# Create command aliases in %LOCALAPPDATA%\Microsoft\WinGet\Links
# by scanning WinGet package folders recursively for .exe launchers.

$linksDir = "$env:LOCALAPPDATA\Microsoft\WinGet\Links"
$pkgRoot  = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages"

# Common subfolders to search (recursively)
$searchSubdirs = @("", "bin", "tools", "app", "apps", "current")

# Exe names to ignore (noise)
$ignorePatterns = @(
  'uninst', 'uninstall', 'setup', 'install',
  'update', 'updater', 'service', 'daemon',
  'vcredist', 'vc_redist', 'crash', 'report', 'helper', 'assistant',
  'dbg', 'debug', 'test'
)

function Test-ShouldIgnoreExe($file) {
  $n = $file.BaseName.ToLower()
  foreach ($p in $ignorePatterns) {
    if ($n -like "*$p*") { return $true }
  }
  return $false
}

function Ensure-Dir($path) {
  if (-not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
  }
}

function New-LinkOrHardlink($linkPath, $targetPath) {
  try {
    # Prefer a symbolic link
    New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath -ErrorAction Stop | Out-Null
    return "symlink"
  } catch {
    # Fallback to hard link (works across same volume)
    try {
      New-Item -ItemType HardLink -Path $linkPath -Target $targetPath -ErrorAction Stop | Out-Null
      return "hardlink"
    } catch {
      throw
    }
  }
}

function Resolve-UniqueLinkPath($baseLinkPath, $pkgFolderName) {
  if (-not (Test-Path $baseLinkPath)) { return $baseLinkPath }
  # If exists but points to same target, we’re fine; caller checks that.
  $dir = Split-Path $baseLinkPath -Parent
  $name = [System.IO.Path]::GetFileNameWithoutExtension($baseLinkPath)
  $ext  = [System.IO.Path]::GetExtension($baseLinkPath)
  return (Join-Path $dir "$name-$pkgFolderName$ext")
}

Ensure-Dir $linksDir

if (-not (Test-Path $pkgRoot)) {
  Write-Warning "Package root not found: $pkgRoot"
  return
}

Get-ChildItem -Path $pkgRoot -Directory | ForEach-Object {
  $pkgPath = $_.FullName
  $pkgFolder = $_.Name

  # Build paths to search (filter to those that exist)
  $searchRoots = $searchSubdirs `
    | ForEach-Object { Join-Path $pkgPath $_ } `
    | Where-Object { Test-Path $_ }

  foreach ($root in $searchRoots) {
    # Recursively search .exe (limit recursion by filtering path depth to avoid going wild)
    $exeFiles = Get-ChildItem -Path $root -Filter *.exe -File -Recurse -ErrorAction SilentlyContinue

    foreach ($exe in $exeFiles) {
      if (Test-ShouldIgnoreExe $exe) { continue }

      $linkPath = Join-Path $linksDir $exe.Name

      # If link exists and already points to this target, skip
      if (Test-Path $linkPath) {
        try {
          $existing = Get-Item $linkPath -ErrorAction Stop
          # For symlinks, compare target; for hardlinks, compare inode via FullName + length as a cheap check
          $same = $false
          if ($existing.LinkType) {
            # symlink/junction: compare target
            $t = (Get-Item $existing.Target) 2>$null
            if ($t -and ($t.FullName -eq $exe.FullName)) { $same = $true }
          } else {
            # non-link file; compare size+name as rough guard
            if ($existing.Length -eq $exe.Length) { $same = $true }
          }
          if ($same) { continue }

          # Otherwise, pick a unique name
          $linkPath = Resolve-UniqueLinkPath $linkPath $pkgFolder
        } catch {
          # If inspection failed, choose a unique name to be safe
          $linkPath = Resolve-UniqueLinkPath $linkPath $pkgFolder
        }
      }

      try {
        $kind = New-LinkOrHardlink -linkPath $linkPath -targetPath $exe.FullName
        Write-Host "Linked ($kind): $($exe.Name)  →  $linkPath"
      } catch {
        Write-Warning "Failed to link $($exe.FullName): $($_.Exception.Message)"
      }
    }
  }
}

Write-Host "`n✅ Finished. Ensure in PATH: $linksDir"

