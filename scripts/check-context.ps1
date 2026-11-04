[CmdletBinding()]
param(
    [switch]$Staged,
    [string]$CommitMessageFile
)

$ErrorActionPreference = 'Stop'

$requiredFiles = @(
    'AGENTS.md',
    'PROJECT_CONTEXT/README.md',
    'PROJECT_CONTEXT/CHARTER.md',
    'PROJECT_CONTEXT/DESIGN.md',
    'PROJECT_CONTEXT/STATE.md',
    'PROJECT_CONTEXT/MAP.md',
    'PROJECT_CONTEXT/DECISIONS.md',
    'PROJECT_CONTEXT/WORKLOG.md',
    'PROJECT_CONTEXT/RESEARCH.md',
    'PROJECT_CONTEXT/TOOLING.md',
    'PROJECT_CONTEXT/SCHEMA.md',
    'PROJECT_CONTEXT/INDEX.md',
    'PROJECT_CONTEXT/LOG.md',
    'default.project.json',
    'rokit.toml'
)

$requiredDirectories = @('PROJECT_CONTEXT/SOURCES', 'PROJECT_CONTEXT/WIKI')

$missing = $requiredFiles | Where-Object { -not (Test-Path -LiteralPath $_) }
if ($missing) {
    throw "Missing required project-context files: $($missing -join ', ')"
}

$missingDirectories = $requiredDirectories | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Container) }
if ($missingDirectories) {
    throw "Missing required project-context directories: $($missingDirectories -join ', ')"
}

Get-Content -LiteralPath 'default.project.json' -Raw | ConvertFrom-Json | Out-Null

$governedPattern = '^(src/|place/|tests/|scripts/|\.github/|default\.project\.json$|rokit\.toml$|\.gitignore$|\.gitattributes$)'
$mapRequiredPattern = '^(src/|place/|tests/|scripts/|\.github/|default\.project\.json$|rokit\.toml$|\.gitattributes$)'

function Get-LatestWorkLogEntry {
    $workLog = Get-Content -LiteralPath 'PROJECT_CONTEXT/WORKLOG.md' -Raw
    $entries = [regex]::Matches($workLog, '(?ms)^## \d{4}-\d{2}-\d{2} — .+?(?=^## \d{4}-\d{2}-\d{2} — |\z)')
    if ($entries.Count -eq 0) {
        throw 'WORKLOG.md has no dated entries.'
    }
    return $entries[0].Value
}

function Get-WorkLogFieldValue {
    param(
        [string]$Entry,
        [string]$Field
    )

    $match = [regex]::Match($Entry, "(?m)^- \*\*$([regex]::Escape($Field)):\*\*\s*(.+)$")
    if (-not $match.Success) {
        throw "Newest WORKLOG.md entry is missing **${Field}:**"
    }
    return $match.Groups[1].Value.Trim()
}

function Get-LatestKnowledgeLogEntry {
    $log = Get-Content -LiteralPath 'PROJECT_CONTEXT/LOG.md' -Raw
    $entries = [regex]::Matches($log, '(?m)^## \[\d{4}-\d{2}-\d{2}\] (ingest|query|lint|audit) \| .+$')
    if ($entries.Count -eq 0) {
        throw 'LOG.md needs a parseable entry: ## [YYYY-MM-DD] operation | title'
    }
    return $entries[0].Value
}

if ($Staged) {
    $changed = @(git diff --cached --name-only)
    if ($changed.Count -eq 0) {
        exit 0
    }

    $governedChanges = @($changed | Where-Object { $_ -match $governedPattern })
    $isRootBaseline = $true
    if (git rev-parse --quiet --verify HEAD 2>$null) {
        $isRootBaseline = ((git rev-list --parents -n 1 HEAD) -split ' ').Count -eq 1
    }
    $wikiChanges = @($changed | Where-Object { $_ -match '^PROJECT_CONTEXT/(SOURCES/|WIKI/|INDEX\.md$|LOG\.md$|SCHEMA\.md$)' })
    if ($wikiChanges) {
        if ('PROJECT_CONTEXT/LOG.md' -notin $changed) {
            throw 'Stage PROJECT_CONTEXT/LOG.md with wiki or source-record changes.'
        }
        [void](Get-LatestKnowledgeLogEntry)
        if (git rev-parse --quiet --verify HEAD 2>$null) {
            $stagedLog = @(git show ':PROJECT_CONTEXT/LOG.md') -join "`n"
            $headLog = @(git show 'HEAD:PROJECT_CONTEXT/LOG.md') -join "`n"
            $stagedEntries = [regex]::Matches($stagedLog, '(?m)^## \[\d{4}-\d{2}-\d{2}\] (ingest|query|lint|audit) \| .+$').Count
            $headEntries = [regex]::Matches($headLog, '(?m)^## \[\d{4}-\d{2}-\d{2}\] (ingest|query|lint|audit) \| .+$').Count
            if ($stagedEntries -le $headEntries -or (git diff --cached --numstat -- PROJECT_CONTEXT/LOG.md | Select-Object -First 1) -match '^\d+\s+[^0]') {
                throw 'Wiki maintenance must append a new LOG.md entry without rewriting prior entries.'
            }
        }

        $addedKnowledgePaths = @(git diff --cached --name-status | ForEach-Object {
            $parts = $_ -split "`t"
            if ($parts[0] -eq 'A') { $parts[1] }
        } | Where-Object { $_ -match '^PROJECT_CONTEXT/(SOURCES/|WIKI/)' })
        if ($addedKnowledgePaths -and 'PROJECT_CONTEXT/INDEX.md' -notin $changed) {
            throw 'Stage PROJECT_CONTEXT/INDEX.md when adding a source record or wiki page.'
        }

        $changedSourceRecords = @(git diff --cached --name-status | ForEach-Object {
            $parts = $_ -split "`t"
            if ($parts[-1] -match '^PROJECT_CONTEXT/SOURCES/') { $parts[0] + ' ' + $parts[-1] }
        })
        $rewrittenSourceRecords = @($changedSourceRecords | Where-Object { $_ -notmatch '^A ' })
        if ($rewrittenSourceRecords) {
            throw "Source records are immutable after ingestion. Add a successor record instead: $($rewrittenSourceRecords -join ', ')"
        }
    }
    if ($governedChanges) {
        $requiredContextUpdates = @('PROJECT_CONTEXT/STATE.md', 'PROJECT_CONTEXT/WORKLOG.md')
        $missingUpdates = $requiredContextUpdates | Where-Object { $_ -notin $changed }
        if ($missingUpdates -and -not $isRootBaseline) {
            throw "Stage $($missingUpdates -join ' and ') with governed changes."
        }

        $mapRequiredChanges = @($changed | Where-Object { $_ -match $mapRequiredPattern })
        if ($mapRequiredChanges -and 'PROJECT_CONTEXT/MAP.md' -notin $changed -and -not $isRootBaseline) {
            throw 'Stage PROJECT_CONTEXT/MAP.md with source, place, test, mapping, toolchain, or workflow changes.'
        }

        $entry = Get-LatestWorkLogEntry
        $requiredFields = @('Commit', 'Task', 'Files changed', 'Map updates', 'Studio objects changed', 'Checks performed', 'Ponytail review', 'Evidence', 'Not verified', 'Next step')
        foreach ($field in $requiredFields) {
            [void](Get-WorkLogFieldValue -Entry $entry -Field $field)
        }

        $recordedFiles = Get-WorkLogFieldValue -Entry $entry -Field 'Files changed'
        if (-not $isRootBaseline) {
            foreach ($path in $governedChanges) {
                if ($recordedFiles -notmatch "(?<![A-Za-z0-9._/-])$([regex]::Escape($path))(?![A-Za-z0-9._/-])") {
                    throw "Newest WORKLOG.md entry does not list governed changed path: $path"
                }
            }
        }

        $addedPaths = @(git diff --cached --name-status | ForEach-Object {
            $parts = $_ -split "`t"
            if ($parts[0] -eq 'A') { $parts[1] }
        } | Where-Object { $_ -match '^(src/|place/|tests/)' })
        if ($addedPaths) {
            $mapContent = Get-Content -LiteralPath 'PROJECT_CONTEXT/MAP.md' -Raw
            foreach ($path in $addedPaths) {
                if ($mapContent -notmatch [regex]::Escape(('`' + $path + '`'))) {
                    throw "Added file is missing from PROJECT_CONTEXT/MAP.md: $path"
                }
            }
        }

        if ($CommitMessageFile) {
            $subject = Get-Content -LiteralPath $CommitMessageFile | Where-Object { $_ -and $_ -notmatch '^#' } | Select-Object -First 1
            $recordedCommit = Get-WorkLogFieldValue -Entry $entry -Field 'Commit'
            $recordedCommitSubject = $recordedCommit.Trim('`')
            if ($subject -ne $recordedCommitSubject) {
                throw "Newest WORKLOG.md Commit field '$recordedCommit' does not match commit subject '$subject'."
            }
        }
    }
}

Write-Output 'Context check passed.'
