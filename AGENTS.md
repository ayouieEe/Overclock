# Overclock Simulator agent instructions

This repository builds **Overclock Simulator**, a simple, fair Roblox CPU-growth game.

## Read before any task

1. Read `PROJECT_CONTEXT/README.md`, then `PROJECT_CONTEXT/INDEX.md`.
2. Read `PROJECT_CONTEXT/CHARTER.md`, `PROJECT_CONTEXT/STATE.md`, `PROJECT_CONTEXT/DESIGN.md`, and `PROJECT_CONTEXT/MAP.md`.
3. Read any relevant entry in `PROJECT_CONTEXT/DECISIONS.md`, `PROJECT_CONTEXT/WORKLOG.md`, `PROJECT_CONTEXT/RESEARCH.md`, or `PROJECT_CONTEXT/TOOLING.md`.
4. Inspect the actual files and `git status` before making claims or edits.
5. If runtime behavior matters, inspect the connected Roblox Studio session and playtest it. If Studio is unavailable, say so.

## Required behavior

- Treat source files and the live Studio place as evidence; documentation is guidance, not proof that code ran.
- Keep Compute, upgrades, timers, saves, and monetization server-authoritative.
- Preserve the non-pay-to-win charter. Functional progression must remain free.
- Do not invent Roblox APIs, object paths, game behavior, test outcomes, or tool-installation status.
- Make the smallest change that satisfies the task. Do not add systems outside `PROJECT_CONTEXT/DESIGN.md` without a recorded decision.
- Work on a feature branch. For a meaningful implementation change: update `PROJECT_CONTEXT/WORKLOG.md`, `STATE.md`, and `MAP.md` before staging; use one Work Log entry for one commit; then open a pull request to `master`. Do not push directly to `master`.
- List every governed changed path exactly in the newest Work Log entry’s **Files changed** field. New `src/`, `place/`, or test files must be mapped in `MAP.md` in the same commit.
- Run `powershell -ExecutionPolicy Bypass -File scripts/audit-project.ps1` before committing. `pre-commit` and `commit-msg` hooks enforce staged context and Work Log commit-subject requirements after `scripts/setup-git-hooks.ps1` has been run in the checkout.
- Record anything not tested as **Not verified**.
- When Ponytail is installed, use its review guidance for meaningful code changes. Ponytail is a guardrail, not a replacement for this context system.

## Compounding wiki behavior

- Before researching or answering a durable project question, read `PROJECT_CONTEXT/INDEX.md` and search `PROJECT_CONTEXT/WIKI/` with `rg`.
- Follow `PROJECT_CONTEXT/SCHEMA.md` for source ingestion, durable query results, claim labels, disagreements, and wiki lint.
- Add only safe public source metadata, links, brief quotations, and synthesis. Never commit raw private chats, credentials, or copied full third-party articles.
- Treat source records as append-only. Add a successor record for a correction; do not silently rewrite evidence.
- Stage `INDEX.md` and a parseable `LOG.md` entry with every new wiki page or source record.
- Keep `STATE.md` as current status and `WORKLOG.md` as implementation-commit history. Use `LOG.md` only for knowledge ingestion, durable queries, and lint/audit results.

## Context integrity

If the docs conflict with code or Studio, stop treating the docs as current, investigate the difference, and record the resolution. Do not silently rewrite history.
