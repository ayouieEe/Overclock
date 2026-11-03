# Tooling and integration status

## Verified local state

| Tool | Status | Evidence |
| --- | --- | --- |
| Git | Available | Used for source control and the clean baseline. |
| GitHub CLI | Installed and authenticated | Creates pull requests and inspects Actions and protection through the Windows keyring. |
| Rokit | Installed and verified | Version 1.2.0. |
| Rojo | Installed and verified | Version 7.7.1 built the current project mapping. |
| Roblox Studio | Installed; login pending | Version 0.745.0.7451137 is running at the login screen. No place or playtest is verified. |
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
- Rojo Studio plugin installation and `rojo serve` live sync remain unverified until Roblox Studio is authenticated and a place is open.
