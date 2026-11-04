[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("OverclockContextTest-" + [guid]::NewGuid())

try {
    git clone --quiet $projectRoot $testRoot
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'check-context.ps1') -Destination (Join-Path $testRoot 'scripts/check-context.ps1') -Force

    Push-Location $testRoot
    try {
        Set-Content -LiteralPath 'src/shared/ContextCheckProbe.luau' -Value '-- temporary context-check regression probe'
        Add-Content -LiteralPath 'PROJECT_CONTEXT/MAP.md' -Value '| `src/shared/ContextCheckProbe.luau` | Regression-test source path. | `ReplicatedStorage.Shared.ContextCheckProbe` |'
        Add-Content -LiteralPath 'PROJECT_CONTEXT/STATE.md' -Value "`n- Context-check regression test staged a governed source path."

        $entry = @'
## 2026-11-04 — accept newest work log entry

- **Commit:** `test: accept newest work log entry`
- **Task:** Verify a governed source change uses the newest Work Log entry.
- **Files changed:** `src/shared/ContextCheckProbe.luau`, `PROJECT_CONTEXT/MAP.md`, `PROJECT_CONTEXT/STATE.md`, `PROJECT_CONTEXT/WORKLOG.md`.
- **Map updates:** Added the regression-test source mapping.
- **Studio objects changed:** None.
- **Checks performed:** `scripts/check-context.ps1 -Staged -CommitMessageFile`.
- **Ponytail review:** Not run; isolated regression fixture.
- **Evidence:** The staged validator accepted this entry instead of the older baseline entry.
- **Not verified:** Studio behavior.
- **Next step:** Remove the temporary fixture.

'@
        $workLog = Get-Content -LiteralPath 'PROJECT_CONTEXT/WORKLOG.md' -Raw
        $header = [regex]::Match($workLog, '(?s)^# Work log\r?\n\r?\nThis file is append-only\.[^\r\n]*\r?\n').Value
        if (-not $header) { throw 'Regression fixture could not find the Work Log header.' }
        Set-Content -LiteralPath 'PROJECT_CONTEXT/WORKLOG.md' -Value ($header + "`r`n" + $entry + $workLog.Substring($header.Length))

        git add -- src/shared/ContextCheckProbe.luau PROJECT_CONTEXT/MAP.md PROJECT_CONTEXT/STATE.md PROJECT_CONTEXT/WORKLOG.md
        $messagePath = Join-Path $testRoot 'commit-message.txt'
        Set-Content -LiteralPath $messagePath -Value 'test: accept newest work log entry'
        & (Join-Path $testRoot 'scripts/check-context.ps1') -Staged -CommitMessageFile $messagePath
        if ($LASTEXITCODE -ne 0) { throw 'Context-check regression test failed.' }
    } finally {
        Pop-Location
    }
} finally {
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Output 'Context-check newest-entry regression test passed.'
