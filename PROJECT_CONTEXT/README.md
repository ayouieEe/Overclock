# Project context index

`PROJECT_CONTEXT` is the canonical second-brain folder for this project. It exists so a new model can recover the project without relying on chat history.

## Mandatory reading order

For every task, read:

1. `PROJECT_CONTEXT/INDEX.md` — navigate the maintained knowledge pages and sources.
2. `PROJECT_CONTEXT/CHARTER.md` — permanent purpose and non-negotiables.
3. `PROJECT_CONTEXT/STATE.md` — current milestone, verified state, blocker, and next task.
4. `PROJECT_CONTEXT/DESIGN.md` — current gameplay scope.
5. `PROJECT_CONTEXT/MAP.md` — workspace and Roblox service mapping.

Then read the relevant supporting record:

- `PROJECT_CONTEXT/DECISIONS.md` before changing product or architecture direction.
- `PROJECT_CONTEXT/WORKLOG.md` before continuing, debugging, or claiming prior work.
- `PROJECT_CONTEXT/RESEARCH.md` before making retention, monetization, or product-strategy decisions.
- `PROJECT_CONTEXT/TOOLING.md` before using Studio MCP, Rojo, Rokit, or Ponytail.
- `PROJECT_CONTEXT/SCHEMA.md` before researching, ingesting evidence, answering a durable project question, or maintaining wiki pages.

## Source-of-truth precedence

1. Verified live Roblox Studio state and playtest evidence for runtime behavior.
2. Current local source files and Git history for intended source-controlled behavior.
3. `STATE.md` for current status.
4. Other context documents for design intent and history.
5. Wiki synthesis pages for connected, evidence-linked explanation.

If these conflict, investigate; do not guess. Record the outcome in `WORKLOG.md`, update `STATE.md`, and update `MAP.md` or `DECISIONS.md` when appropriate.

## Working protocol

### Before editing

- Read the mandatory files above.
- Run `git status --short` and inventory relevant files.
- Identify the smallest expected change and the evidence needed to verify it.
- Inspect Studio/MCP when the task depends on the live place.

### During editing

- Keep game authority on the server for player data, currency, timers, upgrades, and purchases.
- Do not introduce a new system without updating `DESIGN.md` and recording a decision.
- Update `MAP.md` whenever files, module ownership, or Studio mappings change.
- For knowledge work, use the Ingest, Query, and Lint procedures in `SCHEMA.md`; append the result to `LOG.md`.

### After editing

- Run the relevant checks and playtest when possible.
- For each meaningful implementation commit, append one `WORKLOG.md` entry before staging using its required template. Its **Commit** value must exactly match the commit subject.
- Update `STATE.md` to the next truthful state.
- Update `MAP.md` for every new or changed source, place snapshot, test, Rojo mapping, toolchain, or workflow file. Record durable choices in `DECISIONS.md`.
- Run `powershell -ExecutionPolicy Bypass -File scripts/audit-project.ps1`. Then stage explicit paths, commit on a feature branch, push it, and open a pull request to `master`. Do not directly push to `master`.
- Mark any skipped verification as **Not verified**.

## Commit and handoff contract

`WORKLOG.md` is the permanent record of meaningful completed work. The newest entry for a governed commit must contain exactly these fields:

```md
## YYYY-MM-DD — <commit subject>

- **Commit:** `<type>: <exact subject>`
- **Task:** What changed and why.
- **Files changed:** Exact repository-relative paths; no globs.
- **Map updates:** Exact source-to-Roblox mapping changes, or `None`.
- **Studio objects changed:** Full Explorer paths, or `None`.
- **Checks performed:** Commands, playtests, and review results.
- **Ponytail review:** Result or `Not run`, with reason.
- **Evidence:** Observable outputs, screenshots, commit-independent facts.
- **Not verified:** Explicit remaining gaps.
- **Next step:** One concrete continuation task.
```

The strict checker gates `src/`, `place/`, `tests/`, `scripts/`, `.github/`, Rojo mapping, toolchain, and Git-attribute changes. Documentation-only spelling corrections may omit a Work Log entry and Map update. Use `scripts/setup-git-hooks.ps1` once after cloning to activate the versioned hooks.

## File roles

| File | Use |
| --- | --- |
| `CHARTER.md` | Permanent project purpose and boundaries. |
| `DESIGN.md` | Current gameplay specification. |
| `STATE.md` | Short current status; the only current-status source. |
| `MAP.md` | File tree and Roblox DataModel mapping. |
| `DECISIONS.md` | Durable, numbered decisions. |
| `WORKLOG.md` | Append-only work and verification history. |
| `RESEARCH.md` | Product research and implications. |
| `TOOLING.md` | Tool versions, commands, and verified setup status. |
| `SCHEMA.md` | Wiki data contract and maintenance operations. |
| `INDEX.md` | Content-oriented wiki and source navigation. |
| `SOURCES/` | Immutable public evidence records. |
| `WIKI/` | Derived, interlinked project knowledge pages. |
| `LOG.md` | Append-only knowledge-maintenance timeline. |

Do not create another competing project-memory folder. Add a focused document here only when one of these files cannot hold the information clearly.
