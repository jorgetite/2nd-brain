# Layer 2 — Procedural Memory

The routing table: it maps an intent or trigger to the skill that handles it. This is how the
node decides what to do. Slow-changing — `skills/core/reflect` appends new routes as the node
learns. The skills themselves live in `skills/`; this layer only routes to them.

## Routes

| Trigger / intent                | Skill                       |
| ------------------------------- | --------------------------- |
| Personalize a fresh node        | `skills/core/init`          |
| Hand a task to a child node     | `skills/core/delegate`      |
| Consolidate / self-improve      | `skills/core/reflect`       |
| Absorb a new raw source         | `skills/wiki/ingest`        |
| Answer from existing knowledge  | `skills/wiki/query`         |
| Audit the wiki's health         | `skills/wiki/lint`          |
| Add a child node                | `skills/assistants/add`     |
| Remove a child node             | `skills/assistants/remove`  |

Add a route as `| <trigger> | <skill path> |`, most specific first. Every route must resolve
to a real skill directory under `skills/`.
