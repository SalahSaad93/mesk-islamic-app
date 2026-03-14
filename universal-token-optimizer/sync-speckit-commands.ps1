#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Syncs optimized speckit command files and universal-token-optimizer folder
    to all matching projects under a search root.

.DESCRIPTION
    Does two things:
      1. Finds all instances of speckit.specify.md, speckit.plan.md, and
         speckit.tasks.md recursively and overwrites them with the optimized versions.
      2. Finds all directories named "universal-token-optimizer" recursively and
         syncs their contents from the source (file-by-file, skipping identical files).

.PARAMETER SearchRoot
    The root directory to search recursively.
    Defaults to the current directory.

.PARAMETER SourceCommandsDir
    Directory containing the optimized speckit command source files.
    Defaults to D:\Development\FlutterProjectsMain\dabrni_app_release\.claude\commands

.PARAMETER SourceOptimizerDir
    The source universal-token-optimizer directory to sync from.
    Defaults to D:\Development\FlutterProjectsMain\dabrni_app_release\universal-token-optimizer

.PARAMETER DryRun
    If specified, shows what would be changed without making any writes.

.EXAMPLE
    # Preview all changes across D:\Development
    .\sync-speckit-commands.ps1 -SearchRoot "D:\Development" -DryRun

.EXAMPLE
    # Apply to all projects under D:\Development
    .\sync-speckit-commands.ps1 -SearchRoot "D:\Development"

.EXAMPLE
    # Use custom source directories
    .\sync-speckit-commands.ps1 -SearchRoot "D:\Dev" `
        -SourceCommandsDir "C:\MyProject\.claude\commands" `
        -SourceOptimizerDir "C:\MyProject\universal-token-optimizer"
#>

param(
    [string]$SearchRoot         = (Get-Location).Path,
    [string]$SourceCommandsDir  = "D:\Development\FlutterProjectsMain\dabrni_app_release\.claude\commands",
    [string]$SourceOptimizerDir = "D:\Development\FlutterProjectsMain\dabrni_app_release\universal-token-optimizer",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# ── Speckit command files to sync ─────────────────────────────────────────────
$CommandFiles = @(
    "speckit.specify.md",
    "speckit.plan.md",
    "speckit.tasks.md"
)

# ── Helpers ───────────────────────────────────────────────────────────────────
function Get-MD5 ([string]$path) {
    (Get-FileHash $path -Algorithm MD5).Hash
}

function Sync-File ([string]$src, [string]$dest, [ref]$updated, [ref]$skipped) {
    if ((Test-Path $dest) -and (Get-MD5 $src) -eq (Get-MD5 $dest)) {
        Write-Host "    = SKIP    $dest" -ForegroundColor DarkGray
        $skipped.Value++
    } elseif ($DryRun) {
        $label = if (Test-Path $dest) { "~ UPDATE" } else { "+ NEW   " }
        Write-Host "    $label  $dest" -ForegroundColor Yellow
        $updated.Value++
    } else {
        $label = if (Test-Path $dest) { "+ UPDATED" } else { "+ CREATED" }
        $dir = Split-Path $dest
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        Copy-Item -Path $src -Destination $dest -Force
        Write-Host "    $label $dest" -ForegroundColor Green
        $updated.Value++
    }
}

# ── Validate sources ──────────────────────────────────────────────────────────
foreach ($file in $CommandFiles) {
    $src = Join-Path $SourceCommandsDir $file
    if (-not (Test-Path $src)) { Write-Error "Source file not found: $src"; exit 1 }
}
if (-not (Test-Path $SourceOptimizerDir)) {
    Write-Error "Source optimizer dir not found: $SourceOptimizerDir"; exit 1
}

# ── Banner ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Speckit + Token Optimizer Sync" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Commands src : $SourceCommandsDir" -ForegroundColor DarkGray
Write-Host "  Optimizer src: $SourceOptimizerDir" -ForegroundColor DarkGray
Write-Host "  Search root  : $SearchRoot" -ForegroundColor DarkGray
Write-Host "  Mode         : $(if ($DryRun) { 'DRY RUN (no files will be changed)' } else { 'LIVE' })" -ForegroundColor $(if ($DryRun) { 'Yellow' } else { 'Green' })
Write-Host ""

$totalFound   = 0
$totalUpdated = 0
$totalSkipped = 0

# ═══════════════════════════════════════════════════════════════════════════════
# PART 1 — Speckit command files
# ═══════════════════════════════════════════════════════════════════════════════
Write-Host "  [1/2] Speckit Command Files" -ForegroundColor Cyan
Write-Host ""

foreach ($file in $CommandFiles) {
    $src = Join-Path $SourceCommandsDir $file
    Write-Host "  [$file]" -ForegroundColor White

    $hits = Get-ChildItem -Path $SearchRoot -Recurse -Filter $file -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notlike "*$SourceCommandsDir*" }

    if (-not $hits) {
        Write-Host "    No matches found." -ForegroundColor DarkGray
        Write-Host ""
        continue
    }

    foreach ($hit in $hits) {
        $totalFound++
        Sync-File $src $hit.FullName ([ref]$totalUpdated) ([ref]$totalSkipped)
    }
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# PART 2 — universal-token-optimizer folders
# ═══════════════════════════════════════════════════════════════════════════════
Write-Host "  [2/2] universal-token-optimizer Folders" -ForegroundColor Cyan
Write-Host ""

# Collect all files inside the source optimizer (relative paths)
$srcFiles = Get-ChildItem -Path $SourceOptimizerDir -Recurse -File -ErrorAction SilentlyContinue

# Find all destination universal-token-optimizer directories
$destDirs = Get-ChildItem -Path $SearchRoot -Recurse -Filter "universal-token-optimizer" -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -ne $SourceOptimizerDir }

if (-not $destDirs) {
    Write-Host "  No universal-token-optimizer directories found." -ForegroundColor DarkGray
    Write-Host ""
} else {
    foreach ($destDir in $destDirs) {
        Write-Host "  [$($destDir.FullName)]" -ForegroundColor White

        foreach ($srcFile in $srcFiles) {
            # Compute relative path inside the optimizer folder
            $relative = $srcFile.FullName.Substring($SourceOptimizerDir.Length).TrimStart('\','/')
            $dest     = Join-Path $destDir.FullName $relative
            $totalFound++
            Sync-File $srcFile.FullName $dest ([ref]$totalUpdated) ([ref]$totalSkipped)
        }
        Write-Host ""
    }
}

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Host "  ─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Files found   : $totalFound" -ForegroundColor White
Write-Host "  $(if ($DryRun) { 'Would update' } else { 'Updated     ' })  : $totalUpdated" -ForegroundColor $(if ($DryRun) { 'Yellow' } else { 'Green' })
Write-Host "  Skipped       : $totalSkipped (already up to date)" -ForegroundColor DarkGray
Write-Host ""
