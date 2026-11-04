# Playtest findings

**Verified:** November 4, 2026 — a Rojo-connected Studio playtest ran in `ershal_panget's Place: 11042026_1` with Studio API Services enabled.

## First playable slice — pending Studio test

**Observed:** The first playable slice ran from `feat/first-playable-slice` before its commit. The test used the default desktop Studio client viewport and the `OverclockSimulator_Dev_v1` development DataStore.

| Check | Result |
| --- | --- |
| Default rate/capacity and live accrual | Pass — the initial observed state was `2 / 50 Compute` at `1 Compute/s`; the elapsed two seconds prevent a claim that the screen was captured at exactly zero. |
| Cache and Core costs/effects | Pass — Cache changed `26 / 50` to `17 / 100`; Core changed `25 / 100` at `1 Compute/s` to `10 / 100` at `2 Compute/s`. |
| Invalid remote requests | Not verified in a live client-abuse test. |
| Visible CPU Core feedback | Pass — purchasing Core level 2 added a second visible cyan CPU module. |
| DataStore save/rejoin | Pass — after stopping and restarting the Studio test, level-2 Core/Cache state, `100` capacity, `2 Compute/s`, and development DataStore connection restored. |
| Four-hour offline boundary | Not verified at runtime; covered by a Studio-only source assertion awaiting an explicit rerun/output check. |
| Phone-sized HUD | Not verified; desktop Studio viewport only. |

Record each accepted playtest with date, build/commit, device, observed behavior, result, and unresolved issue. Link the corresponding `WORKLOG.md` entry; do not promote a proposal to verified behavior without this evidence.

Related: [Architecture](ARCHITECTURE.md), [Mobile UX](MOBILE_UX.md).
