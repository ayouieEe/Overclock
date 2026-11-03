# Tooling and integration status

## Verified local state

| Tool | Status | Evidence |
| --- | --- | --- |
| Git | Available | Used for source control and the clean baseline. |
| GitHub CLI | Installed and authenticated | Creates pull requests and inspects Actions and protection through the Windows keyring. |
| Rokit | Installed and verified | Version 1.2.0. |
| Rojo | Installed and verified | Version 7.7.1 built the current project mapping. |
| Roblox Studio | Not verified | Required before Studio plugin and live sync tests. |
| Roblox Studio MCP | Not connected | Required only for live-place inspection or edits. |

## Commands

```powershell
rokit install
rojo build default.project.json -o OverclockSimulator.rbxl
rojo serve
powershell -ExecutionPolicy Bypass -File scripts/audit-project.ps1
```

After a fresh clone, run `powershell -ExecutionPolicy Bypass -File scripts/setup-git-hooks.ps1`.
