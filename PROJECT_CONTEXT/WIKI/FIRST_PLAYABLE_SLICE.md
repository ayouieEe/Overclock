# First playable slice

**Decision:** The first playable slice proves one complete free-player loop before the full MVP: earn Compute, buy Cores or Cache, see the CPU change, leave, and return without losing valid progress.

## Scope

Included:

- One personal desk-lab and one CPU.
- Server-authoritative Compute accrual and collection.
- Cores and Cache only.
- One visible CPU change for each Core level.
- Save/load with safe defaults when no player data exists.
- A single mobile-friendly HUD with Compute, rate, capacity, and two upgrade cards.

Excluded until this slice passes:

- Clock Speed, Cooling, Efficiency, build timers, component shop, events, visits, gamepasses, cosmetics, leaderboards, and release publishing.

## Initial numbers

These are deliberately test values, not production balance.

| Value | Rule |
| --- | --- |
| Starting Compute | `0` |
| Starting Cores | `1` |
| Starting Cache | `1` |
| Base generation | `1 Compute/second` per Core level |
| Capacity | `50 Compute` per Cache level |
| Core level 2 cost | `20 Compute` |
| Core level 3 cost | `60 Compute` |
| Cache level 2 cost | `15 Compute` |
| Cache level 3 cost | `50 Compute` |
| Offline accrual limit | `4 hours`, still capped by capacity |

**Inference:** At the initial rate, the first upgrade is available in 15–20 seconds. This makes the interaction understandable immediately; later free-player playtests must establish the five-minute meaningful-progression target before production balancing.

## Player-data contract

The first implementation persists this validated server-owned state:

```text
schemaVersion: 1
compute: non-negative whole number
cores: whole number, minimum 1
cache: whole number, minimum 1
lastAccrualUnix: whole-number Unix timestamp
```

- Rate is derived from `cores`; capacity is derived from `cache`. Neither is saved independently.
- The server clamps accrued Compute to capacity before exposing it to the client.
- On first join or invalid/missing stored data, use the listed safe defaults.
- On a save failure, keep the session playable, warn in server output, and do not claim the progress was saved.
- The first implementation uses a testable in-memory fallback when Roblox DataStore access is unavailable in Studio; this is not persistence proof.

## First-session journey

1. Player sees a small CPU, `0 / 50 Compute`, and `1 Compute/s`.
2. Compute visibly rises; the HUD shows the next affordable upgrade.
3. At 15 Compute, the player can buy Cache; at 20 Compute, they can buy a Core.
4. Buying a Core raises the rate to `2 Compute/s` and visibly adds a CPU detail.
5. Buying Cache raises capacity to `100 Compute`.
6. The player can leave and rejoin; valid saved data restores, and offline accrual is capped.

## Acceptance criteria

- [ ] A new player receives exactly the safe default state.
- [ ] The server, not the client, calculates accrual, affordability, and purchases.
- [ ] Compute rises by one per second at Core level 1 and cannot exceed current capacity.
- [ ] Cache level 2 costs 15 Compute and changes capacity from 50 to 100.
- [ ] Core level 2 costs 20 Compute and changes generation from 1 to 2 Compute/s.
- [ ] Invalid, unaffordable, or unknown upgrade requests do not change player state.
- [ ] A Core purchase visibly changes the CPU in the desk-lab.
- [ ] Valid persisted data restores after a rejoin; offline accrual respects both the 4-hour limit and capacity.
- [ ] The HUD remains usable at a phone-sized viewport without relying on hover input.
- [ ] A Studio playtest records the result of every criterion; DataStore persistence is only marked verified if Studio API access is enabled and a rejoin proves it.

## Evidence status

**Not verified:** No implementation or playtest exists yet. These values and criteria are the contract for the next implementation task.

Related: [Core loop](CORE_LOOP.md), [Economy](ECONOMY.md), [Mobile UX](MOBILE_UX.md), and [Playtest findings](PLAYTEST_FINDINGS.md).
