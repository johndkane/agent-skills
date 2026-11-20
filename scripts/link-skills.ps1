<#
.SYNOPSIS
    Wires the skill catalog into the directories each agent host reads.

.DESCRIPTION
    Every link points at the canonical .agents/skills tree, so there is still
    only one real copy.

    With no -Environment, claude and copilot are wired: the two hosts that cannot
    rely on .agents/skills alone. -All wires every supported host.

    The script is idempotent: an existing correct link is left alone, a real
    directory is never deleted unless -Force is supplied, and symbolic links
    fall back to directory junctions when Windows refuses them.

.PARAMETER Environment
    One or more hosts to wire: claude, copilot, opencode, cursor, gemini, codex.

.PARAMETER All
    Wire every supported host, including the hosts that already read
    .agents/skills.

.PARAMETER Force
    Replace a real directory or a link that points somewhere else.

.EXAMPLE
    ./scripts/link-skills.ps1

.EXAMPLE
    ./scripts/link-skills.ps1 cursor

.EXAMPLE
    ./scripts/link-skills.ps1 claude copilot cursor -Force

.EXAMPLE
    ./scripts/link-skills.ps1 -All
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Environment,

    [switch]$All,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path (Join-Path $repoRoot '.agents') 'skills'

if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Canonical skills directory not found: $source"
}

$hosts = @(
    [pscustomobject]@{ Key = 'claude'; Path = '.claude\skills'; Label = 'Claude Code'; Default = $true }
    [pscustomobject]@{ Key = 'copilot'; Path = '.github\skills'; Label = 'GitHub Copilot'; Default = $true }
    [pscustomobject]@{ Key = 'opencode'; Path = '.opencode\skills'; Label = 'OpenCode'; Default = $false }
    [pscustomobject]@{ Key = 'cursor'; Path = '.cursor\skills'; Label = 'Cursor'; Default = $false }
    [pscustomobject]@{ Key = 'gemini'; Path = '.gemini\skills'; Label = 'Gemini CLI'; Default = $false }
    [pscustomobject]@{ Key = 'codex'; Path = $null; Label = 'Codex'; Default = $false }
)

$aliases = @{
    'claude'          = 'claude'
    'claude-code'     = 'claude'
    'claudecode'      = 'claude'
    'copilot'         = 'copilot'
    'github'          = 'copilot'
    'github-copilot'  = 'copilot'
    'opencode'        = 'opencode'
    'open-code'       = 'opencode'
    'cursor'          = 'cursor'
    'gemini'          = 'gemini'
    'gemini-cli'      = 'gemini'
    'codex'           = 'codex'
    'openai-codex'    = 'codex'
}

function Resolve-HostKey {
    param([string]$Name)

    $key = $aliases[$Name.ToLowerInvariant()]
    if (-not $key) {
        [Console]::Error.WriteLine("error: unknown environment: $Name")
        [Console]::Error.WriteLine("valid: claude copilot opencode cursor gemini codex")
        exit 2
    }

    return $key
}

$requested = @()
foreach ($name in @($Environment)) {
    if ([string]::IsNullOrWhiteSpace($name)) { continue }
    $requested += Resolve-HostKey $name.Trim()
}

$selected = @()
foreach ($host_ in $hosts) {
    if ($All) {
        $selected += $host_
        continue
    }

    if ($requested.Count -eq 0) {
        if ($host_.Default) { $selected += $host_ }
        continue
    }

    if ($requested -contains $host_.Key) { $selected += $host_ }
}

if ($selected.Count -eq 0) {
    [Console]::Error.WriteLine('error: nothing to wire; see -All or pass an environment')
    exit 2
}

$relativeTarget = '..\.agents\skills'
$wired = 0

foreach ($host_ in $selected) {
    if (-not $host_.Path) {
        Write-Host ("native  {0} -> .agents/skills (no link needed)  [{1}]" -f $host_.Key, $host_.Label)
        $wired++
        continue
    }

    $linkPath = Join-Path $repoRoot $host_.Path
    $parent = Split-Path -Parent $linkPath
    $resolvedTarget = [System.IO.Path]::GetFullPath((Join-Path $parent $relativeTarget))

    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if (Test-Path -LiteralPath $linkPath) {
        $item = Get-Item -LiteralPath $linkPath -Force

        if ($item.LinkType) {
            $rawTarget = @($item.Target)[0]
            $currentTarget = if ([System.IO.Path]::IsPathRooted([string]$rawTarget)) {
                [System.IO.Path]::GetFullPath([string]$rawTarget)
            }
            else {
                [System.IO.Path]::GetFullPath((Join-Path $parent ([string]$rawTarget)))
            }

            if ($currentTarget -eq $resolvedTarget) {
                Write-Host ("ok      {0} -> {1}  [{2}]" -f $host_.Path, $relativeTarget, $host_.Label)
                $wired++
                continue
            }

            if (-not $Force) {
                Write-Warning ("{0} points at {1}; expected {2}. Re-run with -Force to replace it." -f $host_.Path, $currentTarget, $resolvedTarget)
                continue
            }

            Remove-Item -LiteralPath $linkPath -Force
        }
        else {
            # A checkout with core.symlinks=false writes the target as a plain file.
            $placeholder = $null
            if (-not $item.PSIsContainer) {
                $placeholder = (Get-Content -LiteralPath $linkPath -Raw -ErrorAction SilentlyContinue)
                if ($placeholder) { $placeholder = ($placeholder -replace '\\', '/').Trim() }
            }

            $expectedText = $relativeTarget -replace '\\', '/'
            if (-not $Force -and $placeholder -ne $expectedText) {
                Write-Warning ("{0} exists and is not a link. Re-run with -Force to replace it." -f $host_.Path)
                continue
            }

            Remove-Item -LiteralPath $linkPath -Recurse -Force
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $relativeTarget -ErrorAction Stop | Out-Null
        Write-Host ("linked  {0} -> {1}  [{2}]" -f $host_.Path, $relativeTarget, $host_.Label)
    }
    catch {
        New-Item -ItemType Junction -Path $linkPath -Target $resolvedTarget -ErrorAction Stop | Out-Null
        Write-Host ("linked  {0} -> {1}  [{2}, junction]" -f $host_.Path, $resolvedTarget, $host_.Label)
    }
    $wired++

    $linkCount = @(Get-ChildItem -LiteralPath $linkPath -Force).Count
    $sourceCount = @(Get-ChildItem -LiteralPath $source -Force).Count
    if ($linkCount -ne $sourceCount) {
        Write-Warning ("{0} exposes {1} entries but the canonical tree has {2}; verify the target." -f $host_.Path, $linkCount, $sourceCount)
    }
}

Write-Host ("Canonical source: {0}" -f $source)
