# Current state

- **Updated:** November 3, 2026
- **Updated by:** Codex
- **Milestone:** Live-sync foundation verified — protected source workflow, knowledge system, and local Rojo-to-Studio sync are ready; gameplay development remains pending.

## Working

- Root agent instructions, context records, Rojo mapping, and empty source folders are present.
- The design-research synthesis is indexed by `RESEARCH.md`.
- Context checks, wiki lint, isolated wiki-lint tests, and the GitHub Context Audit workflow are present.
- Rokit 1.2.0 and project-pinned Rojo 7.7.1 are installed and verified.
- The public repository has a clean baseline, and protected `master` requires the `context-audit` check and pull requests.
- Roblox Studio 0.745.0.7451137 is authenticated with a local `Place1` test place open.
- The official Rojo 7.7.1 plugin is installed manually, and `rojo serve default.project.json` is connected to Roblox Studio on `localhost:34872`.

## Not working or not yet built

- No published/group-owned Studio experience, Studio MCP session, or Luau gameplay code exists.
- A temporary local `Place1` is the verified sync target; it is not the intended final group-owned release place.
- Ponytail lifecycle-hook trust is not verified.

## Next single recommended task

Define the first playable vertical slice and its numerical acceptance criteria, then implement it through the verified Rojo workflow.

## Blockers

- A final group-owned experience and Studio MCP connection are not verified.

## Last verified evidence

- Rojo 7.7.1 successfully built `default.project.json` into a temporary `.rbxl` output.
- GitHub Context Audit completed successfully for the clean baseline; branch protection requires `context-audit`, pull requests, and no administrator bypass.
- Roblox Studio 0.745.0.7451137 authenticated successfully and connected to the Rojo 7.7.1 server on `localhost:34872`.
- A temporary `LiveSyncProbe` source file appeared in the live Rojo instance tree while `RobloxStudioBeta` was connected, then its removal propagated; the checkout returned clean.
- No runtime or gameplay claim is verified.
