# Project map

## Authority map

| Area | Authoritative record | Notes |
| --- | --- | --- |
| Game source | `src/` and Git history | Local source is the durable code record. |
| Runtime behavior | Verified Studio playtest evidence | Record in `WORKLOG.md`. |
| Current work state | `STATE.md` | Keep short and current. |
| Product and architecture decisions | `DECISIONS.md` + reflected design docs | Do not hide decisions only in chat. |
| Research | `SOURCES/` records plus `WIKI/` synthesis | Sources support external facts; wiki pages connect them. |

## Workspace map

| Path | Role | Roblox destination |
| --- | --- | --- |
| `AGENTS.md` | Mandatory agent operating rules. | Not synced to Studio. |
| `PROJECT_CONTEXT/` | Canonical second-brain documentation. | Not synced to Studio. |
| `src/server/` | Server-only Luau systems. | `ServerScriptService.OverclockSimulatorServer` |
| `src/client/` | Client-side UI/input Luau systems. | `StarterPlayer.StarterPlayerScripts.OverclockSimulatorClient` |
| `src/shared/` | Shared configs and ModuleScripts. | `ReplicatedStorage.Shared` |
| `src/assets/` | Source-controlled reusable assets where practical. | `ReplicatedStorage.Assets` |
| `default.project.json` | Rojo-to-DataModel mapping. | Defines the mapping above. |
| `rokit.toml` | Pinned development-tool manifest. | Not synced to Studio. |
| `.gitattributes` | Cross-platform line-ending policy for committed project and hook files. | Not synced to Studio. |
| `PROJECT_CONTEXT/SCHEMA.md` | Wiki contract: claims, source records, ingest/query/lint. | Not synced to Studio. |
| `PROJECT_CONTEXT/INDEX.md` | Wiki navigation and concise page summaries. | Not synced to Studio. |
| `PROJECT_CONTEXT/SOURCES/` | Optional immutable public evidence records for future external factual claims. | Not synced to Studio. |
| `PROJECT_CONTEXT/WIKI/` | Derived, interlinked game and project knowledge. | Not synced to Studio. |
| `PROJECT_CONTEXT/WIKI/FIRST_PLAYABLE_SLICE.md` | Initial vertical-slice implementation contract and acceptance criteria. | Not synced to Studio. |
| `PROJECT_CONTEXT/LOG.md` | Append-only knowledge-maintenance record. | Not synced to Studio. |
| `place/` | Versioned Studio milestone snapshots. | A playable place snapshot when visual or structural Studio work is accepted. |
| `scripts/check-context.ps1` | Verifies context, append-only source evidence, and appended knowledge-log entries. | Not synced to Studio. |
| `scripts/audit-project.ps1` | Runs the full read-only repository and mapping audit. | Not synced to Studio. |
| `scripts/setup-git-hooks.ps1` | Activates the repository’s versioned Git hooks after cloning. | Not synced to Studio. |
| `scripts/lint-wiki.ps1` | Deterministically checks wiki structure and references. | Not synced to Studio. |
| `scripts/audit-wiki.ps1` | Produces a read-only wiki health-review report. | Not synced to Studio. |
| `scripts/test-lint-wiki.ps1` | Runs isolated negative tests for the wiki linter. | Not synced to Studio. |
| `scripts/test-check-context.ps1` | Runs an isolated newest-Work-Log regression test for the staged commit validator. | Not synced to Studio. |
| `scripts/hooks/pre-commit` | Runs the staged context check before commits. | Not synced to Studio. |
| `scripts/hooks/commit-msg` | Confirms the Work Log commit subject matches the Git commit subject. | Not synced to Studio. |
| `.github/workflows/context-audit.yml` | Runs the full context audit for pull requests and pushes to `master`. | Not synced to Studio. |

### First playable slice modules

| Path | Purpose | Roblox destination |
| --- | --- | --- |
| `src/shared/GameConfig.luau` | First-slice schema, DataStore, economy, and save constants. | `ReplicatedStorage.Shared.GameConfig` |
| `src/shared/UpgradeConfig.luau` | First-slice Core and Cache cost table. | `ReplicatedStorage.Shared.UpgradeConfig` |
| `src/shared/ComputeRules.luau` | Pure state normalization, accrual, capacity, and purchase rules. | `ReplicatedStorage.Shared.ComputeRules` |
| `src/server/PlayerDataService.luau` | DataStore load/save, validated player state, and snapshots. | `ServerScriptService.OverclockSimulatorServer.PlayerDataService` |
| `src/server/ComputeService.luau` | One-second server accrual loop. | `ServerScriptService.OverclockSimulatorServer.ComputeService` |
| `src/server/UpgradeService.luau` | Server validation boundary for Core and Cache requests. | `ServerScriptService.OverclockSimulatorServer.UpgradeService` |
| `src/server/OverclockServer.server.luau` | Server bootstrap, remotes, saves, and temporary test world. | `ServerScriptService.OverclockSimulatorServer.OverclockServer` |
| `src/server/FirstSliceAssertions.server.luau` | Studio-only assertions for economy rules and invalid upgrades. | `ServerScriptService.OverclockSimulatorServer.FirstSliceAssertions` |
| `src/client/MainHUD.client.luau` | Responsive mobile hardware-panel HUD and upgrade input. | `StarterPlayer.StarterPlayerScripts.OverclockSimulatorClient.MainHUD` |
| `src/client/DeskVisual.client.luau` | Client-only low-poly personal desk and CPU Core feedback. | `StarterPlayer.StarterPlayerScripts.OverclockSimulatorClient.DeskVisual` |

### Runtime-created first-slice objects

| Object | Owner | Purpose |
| --- | --- | --- |
| `ReplicatedStorage.OverclockRemotes.GetState` | `OverclockServer` | Initial server-approved player snapshot. |
| `ReplicatedStorage.OverclockRemotes.RequestUpgrade` | `OverclockServer` | Client request for `Cores` or `Cache`; server validates it. |
| `ReplicatedStorage.OverclockRemotes.StateChanged` | `OverclockServer` | Server-to-client snapshot updates. |
| `Workspace.OverclockTestWorld` | `OverclockServer` | Temporary floor and spawn for the personal test place. |
| `Workspace.OverclockLocalDesk` | `DeskVisual` on each client | Visual-only personal desk and CPU; not authoritative or shared. |

## Studio artifact policy

No gameplay, structural, or accepted visual change may exist only in Studio. Represent it in `src/` where Rojo supports it; otherwise save a milestone snapshot at `place/OverclockSimulator.rbxlx`, commit it, and record its purpose and Studio Explorer path in `WORKLOG.md` and this map. Temporary builds remain outside the repository.

## Generated and ignored files

- Generated binary place/model files (`*.rbxl`, `*.rbxm`, `*.rbxmx`) are ignored.
- The canonical XML milestone snapshot `place/OverclockSimulator.rbxlx` is intentionally tracked when it exists.
- Rojo sourcemaps and local Rokit state are ignored.
- Credentials are never tracked.
