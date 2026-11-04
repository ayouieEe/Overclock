# Decision log

Add a numbered record when a choice changes the project’s durable direction. Keep the corresponding design or map document current.

## D-001 — Rojo plus Git is the project source-of-truth workflow

- **Date:** November 1, 2026
- **Decision:** Manage the Roblox project from local, version-controlled source files with Rojo; use Studio and Studio MCP for visual work, inspection, and playtests.
- **Reason:** The project needs a durable, model-readable file map and must not rely on opaque Studio-only state.
- **Alternatives rejected:** Studio-only development; Studio-first Script Sync.
- **Impact:** Game code belongs under `src/`; Studio-only edits require documentation; a Rojo toolchain must be installed before live sync verification.

## D-002 — The game remains non-pay-to-win

- **Date:** November 1, 2026
- **Decision:** Functional CPU progression must be fully free. Gamepasses may only offer convenience and cosmetics.
- **Reason:** This is a direct project goal and protects the relaxed, welcoming experience.
- **Alternatives rejected:** Premium-exclusive CPU power, paid random rewards, and premium-only resources.
- **Impact:** Every future economy or monetization change must be checked against `CHARTER.md` and `DESIGN.md`.

## D-003 — PROJECT_CONTEXT is the canonical project memory

- **Date:** November 1, 2026
- **Decision:** Use one compact `PROJECT_CONTEXT/` folder plus a short root `AGENTS.md` front door.
- **Reason:** Future models need a predictable way to recover intent, current state, mappings, decisions, work evidence, research, and tooling.
- **Alternatives rejected:** Chat-only knowledge, scattered ad hoc Markdown notes, or duplicated context folders.
- **Impact:** Meaningful work must update the appropriate context records.

## D-004 — The game title is Overclock Simulator

- **Date:** November 1, 2026
- **Decision:** Set the working title to `Overclock Simulator`.
- **Reason:** The name directly communicates the CPU-upgrade simulator fantasy.
- **Alternatives rejected:** Names that do not communicate CPU performance progression.
- **Impact:** Project documentation, Rojo DataModel names, and future Roblox presentation must use `Overclock Simulator`.

## D-005 — Studio milestones must be reproducible

- **Date:** November 1, 2026
- **Decision:** Game-critical Studio work must be represented in Rojo source or committed as `place/OverclockSimulator.rbxlx` at an accepted milestone.
- **Reason:** A work-log description cannot recreate a Studio-only object for another model or checkout.
- **Alternatives rejected:** Ignoring every place file and relying only on documentation.
- **Impact:** Temporary place outputs remain ignored, but the canonical XML milestone snapshot is tracked when created.

## D-006 — Context updates are enforced at commit time

- **Date:** November 1, 2026
- **Decision:** A versioned context-check script and project Git pre-commit hook reject relevant source changes unless the required context documents are staged too.
- **Reason:** `AGENTS.md` is guidance; a deterministic check is needed to prevent stale state, map, and work-log records.
- **Alternatives rejected:** Documentation-only enforcement.
- **Impact:** Source, Rojo-map, toolchain, or Studio-snapshot changes require the appropriate context records in the same commit.

## D-007 — Meaningful implementation commits use a strict documentation contract

- **Date:** November 1, 2026
- **Decision:** Every meaningful implementation commit must have one newest Work Log entry, an updated `STATE.md`, and an updated `MAP.md` when the change affects source, snapshots, tests, mappings, tooling, or workflow files.
- **Reason:** A staged-document check alone cannot prove that the Work Log names the actual files or that the map reflects added game artifacts.
- **Alternatives rejected:** Relying on agent instructions only; documenting several unrelated commits in one Work Log entry.
- **Impact:** Versioned pre-commit and commit-message hooks verify required fields, exact governed file names, map coverage for added game/test files, and the recorded commit subject.

## D-008 — Development reaches master through audited pull requests

- **Date:** November 1, 2026
- **Decision:** Meaningful implementation work is committed to a feature branch, audited locally, reviewed by the `Context Audit` GitHub workflow, and merged through a pull request to `master`.
- **Reason:** The project is solo-maintained but still needs a durable review point and a protected baseline for model handoffs.
- **Alternatives rejected:** Direct pushes to `master`; chat-only approval without repository evidence.
- **Impact:** GitHub branch protection must require pull requests and the `Context Audit` check while allowing zero required approving reviewers.

## D-009 — Protect public master without mandatory peer approval

- **Date:** November 2, 2026
- **Decision:** Keep the repository public so GitHub Free can enforce `master` branch protection. Require pull requests and prevent administrator bypass, while requiring zero approving reviewers for this solo project.
- **Reason:** GitHub reported that branch rules for the previous private personal repository would not be enforced. The public repository can enforce this core protection without moving the project to a paid organization.
- **Alternatives rejected:** Unenforced private-repository rules; mandatory approving reviewers with no second maintainer; moving the repository to a paid organization now.
- **Impact:** Repository source, history, and Actions logs are public. `context-audit` is a required status check on `master`; pull requests are required, administrator bypass is disabled, and zero approving reviewers are required.
- **Verification:** November 3, 2026 — the clean baseline Context Audit run passed, and authenticated GitHub inspection confirmed the protected-branch settings.

## D-010 — Project knowledge compounds through a Git-backed wiki

- **Date:** November 3, 2026
- **Decision:** Keep public source records immutable in `SOURCES/`, maintain connected project synthesis in `WIKI/`, navigate it from `INDEX.md`, and record knowledge maintenance in `LOG.md`.
- **Reason:** Models need durable, evidence-linked project knowledge that grows without replacing implementation truth or the existing control-plane documents.
- **Alternatives rejected:** Chat-only research, a hosted RAG/vector service, copied third-party archives, and a second competing context folder.
- **Impact:** Agents must follow `SCHEMA.md`; structural wiki lint runs in Context Audit, while deeper health review runs before milestones, economy changes, and release preparation.

## D-011 — Wiki evidence and maintenance are enforced

- **Date:** November 3, 2026
- **Decision:** Source records are append-only, wiki/source changes require a parseable knowledge-log entry, and source/page additions require index coverage. The wiki linter has isolated negative tests.
- **Reason:** The wiki must remain a trustworthy, compounding record rather than a collection of optional notes.
- **Alternatives rejected:** Allowing silent source rewrites, relying on agent memory for log updates, and testing only a passing wiki.
- **Impact:** Evidence corrections use successor records; agents run the negative test script after changing wiki-lint behavior.

## D-012 — Prove the economy with a two-upgrade playable slice

- **Date:** November 4, 2026
- **Decision:** Implement and test Compute, Cores, Cache, visible Core feedback, save/load, and a mobile HUD before the remaining upgrade categories or any live-service system.
- **Reason:** The smallest loop can validate the game promise, server authority, and persistence without locking in untested complexity.
- **Alternatives rejected:** Building all five upgrade categories before playtesting; postponing persistence until after the economy UI exists.
- **Impact:** The first implementation follows `WIKI/FIRST_PLAYABLE_SLICE.md`; its values are test inputs and require free-player playtest evidence before production balancing.
