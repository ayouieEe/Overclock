[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

git config core.hooksPath scripts/hooks
$configuredPath = git config --get core.hooksPath

if ($configuredPath -ne 'scripts/hooks') {
    throw "Git hooks path was not configured. Found: $configuredPath"
}

if (-not (Test-Path -LiteralPath 'scripts/hooks/pre-commit')) {
    throw 'Missing scripts/hooks/pre-commit.'
}

if (-not (Test-Path -LiteralPath 'scripts/hooks/commit-msg')) {
    throw 'Missing scripts/hooks/commit-msg.'
}

Write-Output 'Git hooks configured: scripts/hooks'
