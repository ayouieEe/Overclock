# Current game design

## Core loop

```text
Check CPU -> collect accumulated Compute -> inspect upgrades or rotating components
-> improve the CPU -> watch its desk-lab model change -> return later for more Compute
```

## Main resource

- **Compute:** The only player currency in the MVP. It is generated over time and spent on upgrades.
- **Compute capacity:** A statistic that caps uncollected Compute; it is not a separate currency.

## Player progression

The CPU starts small and expands without resets in the MVP.

| Upgrade | Player-facing effect |
| --- | --- |
| Cores | Raises base Compute generation. |
| Clock Speed | Raises the generation multiplier. |
| Cache | Raises stored Compute capacity. |
| Cooling | Supports higher clock levels and reduces heat penalties. |
| Efficiency | Improves offline generation and may reduce upgrade costs slightly. |

Upgrades are purchased through mobile-friendly cards. Early upgrades are instant or very short; later upgrades use short build timers.

## Return and discovery systems

- The CPU accumulates Compute while the player is offline, up to capacity.
- A global rotating component shop will eventually offer common through experimental components.
- Power Cycle events will temporarily improve an existing system rather than create a separate game mode.
- Initial event concepts: Turbo Hour, Cooling Cycle, Memory Surge, Efficiency Week, and a carefully balanced Overclock Event.

## Social experience

Players may visit and compare CPU desks. A showcase can display cores, clock speed, cache, cooling, efficiency, total Compute, and cosmetic theme. Visitors cannot take or change another player’s resources.

## Monetization

Permitted gamepass value: shorter build timers, an extra queue slot, cosmetic CPU colors, desk themes, and build animations.

Forbidden value: exclusive functional parts, higher maximum stats, premium-only resources, exclusive event power, or paid random progression.

## Full MVP boundary

The first playable build needs one desk-lab, one CPU, Compute generation and collection, capacity, the five upgrade categories, visible CPU changes, saving/loading, and a basic mobile-friendly HUD. Pets, trading, rebirths, large zones, and complex events are post-MVP.

## First playable slice

Before the full MVP, implement and playtest only Compute, Cores, Cache, one visible Core-driven CPU change, save/load, and one mobile HUD. The exact initial economy, player-data contract, and acceptance checks are defined in [First playable slice](WIKI/FIRST_PLAYABLE_SLICE.md). Other upgrade categories and systems remain out of this slice until its loop is verified.
