# Knowledge wiki schema

The wiki is a public, Git-backed knowledge layer. It explains and connects the project; it does not override verified Studio behavior, current source, or `STATE.md`.

## Precedence

1. Verified Studio playtests and current source code govern runtime behavior.
2. Immutable `SOURCES/` records govern external factual claims.
3. `WIKI/` pages are maintained synthesis.
4. `STATE.md` is the sole current-status record.
5. `WORKLOG.md` records implementation commits; `LOG.md` records knowledge maintenance.

## Claims and pages

Use one of these labels before a material claim: **Verified**, **Observed**, **Decision**, **Inference**, **Proposal**, **Open question**, **Disagreement**, or **Superseded**. Link factual claims to source IDs such as `SRC-ROBLOX-INFRA-2025`. Record disagreements with both claims and their sources; do not silently select a winner.

Search `INDEX.md` and `rg` before creating a page. Extend the closest existing page rather than creating a near-duplicate. Keep page names uppercase with underscores and use relative Markdown links.

## Source records

Each `SOURCES/*.md` file is immutable after ingestion. It begins with YAML front matter containing `id`, `title`, `author`, `url`, `date`, `source_type`, and `rights_safety`. To correct evidence metadata, add a successor record and mark the old one superseded in synthesis rather than rewriting history. Store only public metadata, a link, short quotations where needed, and agent notes. Never store full copied articles, private chats, credentials, or personal data.

`LOG.md` is append-only and parseable: `## [YYYY-MM-DD] operation | title`, where `operation` is `ingest`, `query`, `lint`, or `audit`.
When a source needs recurring factual verification, set `time_sensitive: true` in its initial record; historical evidence is not stale merely because it is old.

## Operations

### Ingest

1. Add a source record.
2. Search the index and relevant wiki pages.
3. Update affected pages with labeled, linked synthesis; flag conflicts or uncertainty.
4. Update `INDEX.md` if coverage changes.
5. Append `LOG.md` with source ID, pages changed, and unresolved questions.

### Query

1. Read `INDEX.md`, then search with `rg`.
2. Answer from linked wiki pages and source records, distinguishing evidence from inference.
3. File a durable new analysis back into the relevant existing wiki page, index, and log when it will matter again.

### Lint

Run `scripts/lint-wiki.ps1` for structural checks. Run `scripts/audit-wiki.ps1` before milestones, large design changes, economy balancing, and release preparation; it reports issues for human review rather than pretending to resolve them.
