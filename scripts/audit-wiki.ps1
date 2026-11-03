[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/lint-wiki.ps1"

$wikiFiles = @(Get-ChildItem -LiteralPath 'PROJECT_CONTEXT/WIKI' -Filter '*.md' -File)
$openQuestions = @(rg -n '^##? Open question|\*\*Open question:\*\*' PROJECT_CONTEXT/WIKI 2>$null)
$proposals = @(rg -n '\*\*Proposal:\*\*' PROJECT_CONTEXT/WIKI 2>$null)
$superseded = @(rg -n '\*\*Superseded:\*\*' PROJECT_CONTEXT/WIKI 2>$null)
$observed = @(rg -n '\*\*Observed:\*\*' PROJECT_CONTEXT/WIKI 2>$null)
$disagreements = @(rg -n '\*\*Disagreement:\*\*' PROJECT_CONTEXT/WIKI 2>$null)
$reviewSources = @(Get-ChildItem -LiteralPath 'PROJECT_CONTEXT/SOURCES' -Filter '*.md' -File | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match '(?m)^time_sensitive:\s*true' })

Write-Output "Wiki health report: $($wikiFiles.Count) pages reviewed structurally."
Write-Output "Open questions: $($openQuestions.Count); proposals: $($proposals.Count); superseded claims: $($superseded.Count); disagreements: $($disagreements.Count)."
Write-Output "Time-sensitive source review candidates: $($reviewSources.Count). Historical evidence is not stale solely because of its publication date."
if ($reviewSources) { Write-Output ($reviewSources.Name -join [Environment]::NewLine) }
Write-Output 'Contradiction review: recorded disagreements follow; compare related claims before marking either superseded.'
if ($disagreements) { Write-Output ($disagreements -join [Environment]::NewLine) }
Write-Output 'Missing-concept review: required page coverage is enforced by lint; assess whether a new decision lacks a fitting page.'
Write-Output 'Research gaps: resolve or explicitly retain the open questions below.'
if ($openQuestions) { Write-Output ($openQuestions -join [Environment]::NewLine) }
