[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent

function Assert-LintFails {
    param([string]$Name, [scriptblock]$Mutate)
    $testRoot = Join-Path ([IO.Path]::GetTempPath()) ("OverclockWikiTest-" + [guid]::NewGuid())
    try {
        New-Item -ItemType Directory -Force (Join-Path $testRoot 'scripts') | Out-Null
        Copy-Item -LiteralPath (Join-Path $projectRoot 'PROJECT_CONTEXT') -Destination $testRoot -Recurse
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'lint-wiki.ps1') -Destination (Join-Path $testRoot 'scripts/lint-wiki.ps1')
        & $Mutate $testRoot
        Push-Location $testRoot
        try {
            & (Join-Path $testRoot 'scripts/lint-wiki.ps1') *> $null
            throw "Expected wiki lint to fail for $Name."
        } catch {
            if ($_.Exception.Message -eq "Expected wiki lint to fail for $Name.") { throw }
        } finally {
            Pop-Location
        }
    } finally {
        Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Output "Passed expected failure: $Name"
}

Assert-LintFails 'missing metadata' { param($root) Set-Content "$root/PROJECT_CONTEXT/SOURCES/SRC-BAD.md" "---`nid: SRC-BAD`n---" }
Assert-LintFails 'broken link' { param($root) Add-Content "$root/PROJECT_CONTEXT/WIKI/CORE_LOOP.md" "`n[broken](MISSING.md)" }
Assert-LintFails 'unknown source ID' { param($root) Add-Content "$root/PROJECT_CONTEXT/WIKI/CORE_LOOP.md" "`n**Observed:** [SRC-MISSING-0000](../SOURCES/SRC-MISSING-0000.md)." }
Assert-LintFails 'unindexed page' { param($root) Copy-Item "$root/PROJECT_CONTEXT/WIKI/CORE_LOOP.md" "$root/PROJECT_CONTEXT/WIKI/UNINDEXED.md" }
Assert-LintFails 'duplicate topic' { param($root) Copy-Item "$root/PROJECT_CONTEXT/WIKI/CORE_LOOP.md" "$root/PROJECT_CONTEXT/WIKI/CORE_LOOP_COPY.md"; Add-Content "$root/PROJECT_CONTEXT/INDEX.md" "`n- [Core loop copy](WIKI/CORE_LOOP_COPY.md)" }

Write-Output 'Wiki lint negative tests passed.'
