# Overclock Simulator

A simple, relaxing Roblox simulator where players build a CPU, collect Compute, and gradually improve a personal desk-lab machine.

## Start here

Every model and contributor must read [PROJECT_CONTEXT/README.md](PROJECT_CONTEXT/README.md) and [PROJECT_CONTEXT/INDEX.md](PROJECT_CONTEXT/INDEX.md) before changing the project. That folder is the project’s persistent memory: game purpose, current state, decisions, file mappings, evidence-linked research, tooling, and verified work.

Meaningful changes use a feature branch, one matching Work Log entry, local `scripts/audit-project.ps1`, and a pull request to `master`. After cloning, run `scripts/setup-git-hooks.ps1` to activate the versioned documentation gates.

## Source-of-truth model

- Local Rojo source files and Git history are the durable project record.
- Roblox Studio is used for visual work, live inspection, and playtesting.
- Studio-only edits are not complete until recorded in `PROJECT_CONTEXT/WORKLOG.md` and `PROJECT_CONTEXT/MAP.md`.

## Planned development commands

Rokit and the project-pinned Rojo CLI are installed and verified. `rojo build` has validated the initial mapping. `rojo serve`, the Rojo Studio plugin, and a Studio connection remain **Not verified**.

```powershell
rokit install
rojo serve
rojo build -o OverclockSimulator.rbxl
```

See [PROJECT_CONTEXT/TOOLING.md](PROJECT_CONTEXT/TOOLING.md) for verified tool status and setup requirements.
