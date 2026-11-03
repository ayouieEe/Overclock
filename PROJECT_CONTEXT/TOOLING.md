# Tooling and integration status

## Verified local state

| Tool | Status | Evidence |
| --- | --- | --- |
| Git | Available | Used for source control and the clean baseline. |
| GitHub CLI | Installed and authenticated | Creates pull requests and inspects Actions and protection through the Windows keyring. |
| Rokit | Installed and verified | Version 1.2.0. |
| Rojo | Installed and verified | Version 7.7.1 built the current project mapping. |
| Roblox Studio | Installed and authenticated | Version 0.745.0.7451137 synced with the local `Place1` test place. No gameplay playtest is verified. |
| Roblox Studio MCP | Not connected | Required only for live-place inspection or edits. |

## Commands

```powershell
rokit install
rojo build default.project.json -o OverclockSimulator.rbxl
rojo serve
powershell -ExecutionPolicy Bypass -File scripts/audit-project.ps1
```

After a fresh clone, run `powershell -ExecutionPolicy Bypass -File scripts/setup-git-hooks.ps1`.

## Verified repository workflow

- The public `master` branch has a clean baseline and a passing `Context Audit` workflow run.
- Branch protection requires pull requests and the `context-audit` status check, with administrator bypass disabled and zero required approving reviewers.
- The official Rojo 7.7.1 plugin is installed in Studio's local Plugins folder. `rojo serve default.project.json` connected to `RobloxStudioBeta` on `localhost:34872`; a temporary source probe appeared and was removed from the live tree.
- A final group-owned experience and Studio MCP connection remain unverified.
