[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$sourceDir = Join-Path $root 'PROJECT_CONTEXT/SOURCES'
$wikiDir = Join-Path $root 'PROJECT_CONTEXT/WIKI'
$indexPath = Join-Path $root 'PROJECT_CONTEXT/INDEX.md'

function Get-RelativeLinks {
    param([string]$Path)
    $text = Get-Content -LiteralPath $Path -Raw
    [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)') | ForEach-Object { $_.Groups[1].Value.Split('#')[0] } |
        Where-Object { $_ -and $_ -notmatch '^(https?://|mailto:)' }
}

$sourceFiles = @(Get-ChildItem -LiteralPath $sourceDir -Filter '*.md' -File)
$sourceIds = @{}
$indexLinks = @(Get-RelativeLinks $indexPath)
foreach ($file in $sourceFiles) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    if ($text -notmatch '(?s)^---\r?\n.+?\r?\n---\r?\n') { throw "Wiki lint: source record lacks closed YAML front matter: $($file.Name)" }
    foreach ($field in @('id', 'title', 'author', 'url', 'date', 'source_type', 'rights_safety')) {
        if ($text -notmatch "(?m)^${field}:\s*\S+") { throw "Wiki lint: $($file.Name) lacks metadata field '$field'." }
    }
    $id = ([regex]::Match($text, '(?m)^id:\s*(\S+)')).Groups[1].Value
    if ($sourceIds.ContainsKey($id)) { throw "Wiki lint: duplicate source ID '$id'." }
    $sourceIds[$id] = $file.FullName
    $expectedLink = "SOURCES/$($file.Name)"
    if ($expectedLink -notin $indexLinks) { throw "Wiki lint: unindexed source record PROJECT_CONTEXT/$expectedLink." }
}

$wikiFiles = @(Get-ChildItem -LiteralPath $wikiDir -Filter '*.md' -File)
if ($wikiFiles.Count -eq 0) { throw 'Wiki lint: no wiki pages exist.' }
$indexWikiLinks = @($indexLinks | Where-Object { $_ -like 'WIKI/*.md' } | ForEach-Object { $_.Replace('/', '\') })
foreach ($file in $wikiFiles) {
    $relative = "WIKI\$($file.Name)"
    if ($relative -notin $indexWikiLinks) { throw "Wiki lint: unindexed wiki page PROJECT_CONTEXT/$relative." }
}
foreach ($link in $indexWikiLinks) {
    if (-not (Test-Path -LiteralPath (Join-Path (Split-Path $indexPath) $link))) { throw "Wiki lint: INDEX.md links to missing page '$link'." }
}
$topicTitles = @{}
foreach ($file in $wikiFiles) {
    $title = ([regex]::Match((Get-Content -LiteralPath $file.FullName -Raw), '(?m)^#\s+(.+)$')).Groups[1].Value
    $normalizedTitle = ($title -replace '[^A-Za-z0-9]+', '').ToLowerInvariant()
    if ($topicTitles.ContainsKey($normalizedTitle)) {
        throw "Wiki lint: duplicate topic candidates '$($topicTitles[$normalizedTitle])' and '$($file.Name)'."
    }
    $topicTitles[$normalizedTitle] = $file.Name
}

$allPages = @($wikiFiles.FullName) + $indexPath
foreach ($page in $allPages) {
    foreach ($link in Get-RelativeLinks $page) {
        $target = Join-Path (Split-Path $page) $link.Replace('/', '\')
        if (-not (Test-Path -LiteralPath $target)) { throw "Wiki lint: broken relative link '$link' in $([IO.Path]::GetFileName($page))." }
    }
}
foreach ($file in $wikiFiles) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    foreach ($match in [regex]::Matches($text, '\bSRC-[A-Z0-9-]+\b')) {
        if (-not $sourceIds.ContainsKey($match.Value)) { throw "Wiki lint: unknown source ID '$($match.Value)' in $($file.Name)." }
    }
}

$log = Get-Content -LiteralPath 'PROJECT_CONTEXT/LOG.md' -Raw
$headers = [regex]::Matches($log, '(?m)^## .+$')
foreach ($header in $headers) {
    if ($header.Value -notmatch '^## \[\d{4}-\d{2}-\d{2}\] (ingest|query|lint|audit) \| .+$') {
        throw "Wiki lint: LOG.md entry is not parseable: $($header.Value)"
    }
}

Write-Output "Wiki lint passed: $($sourceFiles.Count) source records, $($wikiFiles.Count) wiki pages."
