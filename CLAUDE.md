# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A framework for an everyday, AI-powered personal assistant ("2nd brain"). It is deliberately **harness-agnostic and provider/model-agnostic**: it targets any agent harness that supports the `AGENTS.md` and `SKILL.md` standards, and assumes nothing about the underlying LLM provider or model. Licensed under MIT.

The framework is **customizable and extensible across distinct domains**. A single assistant covers multiple domains by managing several **OKF knowledge bundles** (one per domain) under `bundles/` — the knowledge base is a set of portable, [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) markdown bundles rather than a single wiki.

## The two foundational concepts

The architecture is the synthesis of two ideas. Understanding both is prerequisite to working productively here.

### 1. LLM Wiki (Karpathy) — the persistent knowledge layer

Source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

Instead of re-retrieving and re-synthesizing knowledge on every query (classic RAG), the assistant **incrementally builds and maintains persistent, LLM-authored markdown** that compounds over time. Here that knowledge is stored as one or more [OKF](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) bundles under `bundles/`. Three layers:

- **Raw Sources** — immutable input documents (articles, papers, notes, data) under `sources/`.
- **The Bundles** — LLM-maintained OKF concepts: markdown files under `bundles/<name>/`, each carrying a required `type:` in YAML frontmatter, cross-linked with absolute bundle-relative links.
- **The Schema** — OKF's free-string concept `type` plus each bundle's own `templates/` skeletons (there is no separate schema file).

Three core operations define the lifecycle:

- **Ingest** — extract from new sources, integrate across existing concepts, update the bundle's index and log.
- **Query** — search relevant concepts, synthesize an answer, and **file valuable results back into a bundle** rather than losing them in chat history.
- **Lint** — periodically audit for OKF conformance, contradictions, stale claims, orphaned concepts, and broken links.

Within each bundle, navigation relies on two reserved files: `index.md` (a progressive-disclosure listing) and `log.md` (chronological, newest-first change history). OKF allows an `index.md` at any directory level, so a large bundle nests subdirectory indexes to stay progressively disclosed. A `bundles/index.md` catalog lists the bundles themselves. The key insight: the expensive part of a knowledge base is the *bookkeeping*, so that work is delegated to the LLM.

> Note: this project's own agent memory (under the harness's memory directory) follows the same spirit — one fact per file, an index that points at them, links between related facts. The user-facing bundles and the agent's operational memory are distinct stores; keep them separate.

### 2. Continual Harness — the self-improvement layer

Source: https://arxiv.org/abs/2605.09998 (*Continual Harness: Online Adaptation for Self-Improving Foundation Agents*)

A **reset-free, self-improving harness** wraps the foundation model with tools, memory, and planning. The agent **adapts online within a single run** — no episode resets — continuously refining its own **prompts, skills, and memory** using historical trajectory data. Execution and strategy-refinement alternate, with long-context memory used to spot improvement opportunities. The result: strong performance starting from a minimal interface with no curated domain knowledge.

### How they combine here

The LLM Wiki is the **knowledge that compounds**; the Continual Harness is the **capability that compounds**. The framework treats both the bundles (what the assistant knows) and the assistant's own skills/prompts/memory (how the assistant acts) as living artifacts the assistant maintains over time. When extending the framework, ask which layer a change belongs to: knowledge (bundles ingest/query/lint) or capability (skills, prompts, memory, harness behavior).

## Architecture

### Multi-Bundle Knowledge

- A single assistant owns its knowledge as **one or more OKF bundles** under `bundles/`, one per domain. The `bundles/index.md` catalog lists them and is loaded at bootstrap.
- Each bundle is a self-contained OKF markdown tree — its own `index.md`, `log.md`, per-type `templates/`, and `type`-tagged concept files — so it stays portable and can be shared or moved independently.
- Adding a bundle is human-initiated: `skills/bundles/create` generates a new empty bundle, or `skills/bundles/import` adopts an existing OKF bundle authored elsewhere; `skills/bundles/remove` retires one (destructive, confirms first — archiving the bundle's unshared backing sources to `sources/archive/`). `ingest`/`query`/`lint` operate on the appropriate bundle chosen from the catalog.

### Project Structure

```
.
├── install.sh            # TRACKED — installer: install an assistant from src/ into a target path
├── src/                  # TRACKED — the framework source (the only versioned resources)
│   ├── AGENTS.md         #   entrypoint: bootstrap, then act
│   ├── memory/           #   blank 4-layer contracts: core, procedural, state, journal
│   └── skills/           #   SKILL.md playbooks: core/, bundles/
├── assistant/            # GITIGNORED — a working instance installed from src/. Gains sources/ and
│                         #   bundles/ at install/runtime, and evolves its own memory & skills.
├── docs/                 # concepts, memory model, bundles
├── README.md
└── CLAUDE.md
```

Install a working instance with `sh ./install.sh <target>` (e.g. `sh ./install.sh assistant`). Only
`src/` (and `install.sh`) are version-controlled; an installed instance is regenerable and not
tracked.


## MUST FOLLOW PRINCIPLES

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
