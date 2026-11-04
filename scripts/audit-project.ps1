[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

& "$PSScriptRoot/check-context.ps1"
& "$PSScriptRoot/lint-wiki.ps1"
& "$PSScriptRoot/test-check-context.ps1"

$diffCheck = @(git diff --check)
if ($LASTEXITCODE -ne 0) {
    throw "git diff --check failed:`n$($diffCheck -join [Environment]::NewLine)"
}

$mapContent = Get-Content -LiteralPath 'PROJECT_CONTEXT/MAP.md' -Raw
$workspaceSection = [regex]::Match($mapContent, '(?s)## Workspace map\r?\n(.*?)(?=\r?\n## )').Groups[1].Value
$mappedPaths = [regex]::Matches($workspaceSection, '`([^`]+)`') | ForEach-Object { $_.Groups[1].Value }

$trackedAreas = @('src', 'place', 'tests', 'scripts', '.github')
$actualPaths = foreach ($area in $trackedAreas) {
    if (Test-Path -LiteralPath $area) {
        Get-ChildItem -LiteralPath $area -File -Recurse |
            Where-Object { $_.Name -ne '.gitkeep' } |
            ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length + 1).Replace('\', '/') }
    }
}

$unmapped = $actualPaths | Where-Object { $_ -notin $mappedPaths }
if ($unmapped) {
    throw "Files missing from PROJECT_CONTEXT/MAP.md: $($unmapped -join ', ')"
}

$missingMapped = $mappedPaths | Where-Object {
    ($_ -match '^(src/|place/|tests/|scripts/|\.github/)') -and -not (Test-Path -LiteralPath $_)
}
if ($missingMapped) {
    throw "MAP.md lists files that do not exist: $($missingMapped -join ', ')"
}

$branch = git branch --show-current
$branchInfo = @(git status --porcelain=v2 --branch)
$upstreamLine = $branchInfo | Where-Object { $_ -like '# branch.upstream *' } | Select-Object -First 1
if ($upstreamLine) {
    $upstream = $upstreamLine.Substring('# branch.upstream '.Length)
} else {
    $upstream = 'No upstream configured'
}
$status = @(git status --short)

Write-Output "Branch: $branch"
Write-Output "Upstream: $upstream"
if ($status) {
    Write-Output "Working tree changes:`n$($status -join [Environment]::NewLine)"
} else {
    Write-Output 'Working tree: clean'
}

$rojoCommand = $null
$rojo = Get-Command rojo -ErrorAction SilentlyContinue
if ($rojo) {
    $rojoCommand = $rojo.Source
} else {
    $rojoPath = Join-Path $env:USERPROFILE '.rokit/bin/rojo.exe'
    if (Test-Path -LiteralPath $rojoPath) {
        $rojoCommand = $rojoPath
    }
}

if ($rojoCommand) {
    $outputPath = Join-Path $env:TEMP 'OverclockSimulator-context-audit.rbxl'
    & $rojoCommand build default.project.json -o $outputPath
    if ($LASTEXITCODE -ne 0) {
        throw 'Rojo build failed.'
    }
    Remove-Item -LiteralPath $outputPath -Force -ErrorAction SilentlyContinue
    Write-Output 'Rojo build: passed'
} else {
    Write-Output 'Rojo build: skipped (Rojo not available on PATH or in the Rokit bin folder)'
}

Write-Output 'Project audit passed.'
