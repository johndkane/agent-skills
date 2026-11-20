<#
.SYNOPSIS
    Creates the per-agent links that expose .agents/skills to hosts that do not
    read that location natively.

.DESCRIPTION
    .agents/skills is the canonical source of truth. Claude Code only reads
    .claude/skills and GitHub Copilot prefers .github/skills, so both are links
    to the canonical tree.

    The script is idempotent: an existing correct link is left alone, a real
    directory is never deleted unless -Force is supplied, and symbolic links
    fall back to directory junctions when Windows refuses them.

.PARAMETER Force
    Replace a real directory or an incorrect link at a target path.

.EXAMPLE
    pwsh ./scripts/link-skills.ps1

.EXAMPLE
    pwsh ./scripts/link-skills.ps1 -Force
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path (Join-Path $repoRoot '.agents') 'skills'

if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Canonical skills directory not found: $source"
}

$links = @(
    [pscustomobject]@{ RelativePath = '.claude\skills'; RelativeTarget = '..\.agents\skills'; Agent = 'Claude Code' }
    [pscustomobject]@{ RelativePath = '.github\skills'; RelativeTarget = '..\.agents\skills'; Agent = 'GitHub Copilot' }
)

foreach ($link in $links) {
    $linkPath = Join-Path $repoRoot $link.RelativePath
    $parent = Split-Path -Parent $linkPath
    $resolvedTarget = [System.IO.Path]::GetFullPath((Join-Path $parent $link.RelativeTarget))

    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if (Test-Path -LiteralPath $linkPath) {
        $item = Get-Item -LiteralPath $linkPath -Force

        if ($item.LinkType) {
            $rawTarget = @($item.Target)[0]
            $currentTarget = if ([System.IO.Path]::IsPathRooted([string]$rawTarget)) {
                [System.IO.Path]::GetFullPath([string]$rawTarget)
            } else {
                [System.IO.Path]::GetFullPath((Join-Path $parent ([string]$rawTarget)))
            }
            if ($currentTarget -eq $resolvedTarget) {
                Write-Host ("ok      {0} -> {1}" -f $link.RelativePath, $link.RelativeTarget)
                continue
            }

            if (-not $Force) {
                Write-Warning ("{0} points at {1}; expected {2}. Re-run with -Force to replace it." -f $link.RelativePath, $currentTarget, $resolvedTarget)
                continue
            }

            Remove-Item -LiteralPath $linkPath -Force
        }
        else {
            if (-not $Force) {
                Write-Warning ("{0} is a real directory, not a link. Re-run with -Force to replace it." -f $link.RelativePath)
                continue
            }

            Remove-Item -LiteralPath $linkPath -Recurse -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $link.RelativeTarget -ErrorAction Stop | Out-Null
        Write-Host ("linked  {0} -> {1}  [{2}]" -f $link.RelativePath, $link.RelativeTarget, $link.Agent)
    }
    catch {
        # Windows without Developer Mode refuses symlinks; a junction to the
        # absolute target has the same effect for directory reads.
        New-Item -ItemType Junction -Path $linkPath -Target $resolvedTarget -ErrorAction Stop | Out-Null
        Write-Host ("linked  {0} -> {1}  [{2}, junction]" -f $link.RelativePath, $resolvedTarget, $link.Agent)
    }

    $linkCount = @(Get-ChildItem -LiteralPath $linkPath -Force).Count
    $sourceCount = @(Get-ChildItem -LiteralPath $source -Force).Count
    if ($linkCount -ne $sourceCount) {
        Write-Warning ("{0} exposes {1} entries but the canonical tree has {2}; verify the target." -f $link.RelativePath, $linkCount, $sourceCount)
    }
}

Write-Host ("Canonical source: {0}" -f $source)
