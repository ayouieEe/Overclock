# Architecture

**Decision:** Rojo and Git are the durable source workflow. Studio is required for visual work and runtime verification; Studio-only accepted work must be represented in source or a committed milestone snapshot.

**Verified:** Rojo can build the current empty mapping. Studio plugin, live sync, Studio MCP, and gameplay runtime are not verified.

**Decision:** Server code owns Compute, upgrades, timers, saves, and purchases.

Related: [Playtest findings](PLAYTEST_FINDINGS.md), [Open questions](OPEN_QUESTIONS.md).
