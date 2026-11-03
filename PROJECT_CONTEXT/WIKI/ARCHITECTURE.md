# Architecture

**Decision:** Rojo and Git are the durable source workflow. Studio is required for visual work and runtime verification; Studio-only accepted work must be represented in source or a committed milestone snapshot.

**Verified:** Rojo can build the current empty mapping and live-sync it to the local Studio test place through the Rojo 7.7.1 plugin. Studio MCP and gameplay runtime are not verified.

**Decision:** Server code owns Compute, upgrades, timers, saves, and purchases.

Related: [Playtest findings](PLAYTEST_FINDINGS.md), [Open questions](OPEN_QUESTIONS.md).
