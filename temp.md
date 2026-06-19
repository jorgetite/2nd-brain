# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A framework for an everyday, AI-powered personal assistant ("2nd brain"). It is deliberately **harness-agnostic and provider/model-agnostic**: it targets any agent harness that supports the `AGENTS.md` and `SKILL.md` standards, and assumes nothing about the underlying LLM provider or model. Licensed under MIT.

The framework is **customizable and extensible across distinct domains**, and its design is **recursive**: assistants can oversee, manage, and communicate with other assistants. A typical deployment has specialized **domain assistants** (each owning one domain) coordinated by an **orchestrator assistant** that routes tasks and brokers communication across domains.

## The two foundational concepts

The architecture is the synthesis of two ideas. Understanding both is prerequisite to working productively here.

### 1. LLM Wiki (Karpathy) — the persistent knowledge layer

Source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

Instead of re-retrieving and re-synthesizing knowledge on every query (classic RAG), the assistant **incrementally builds and maintains a persistent, LLM-authored wiki** of markdown that compounds over time. Three layers:

- **Raw Sources** — immutable input documents (articles, papers, notes, data).
- **The Wiki** — LLM-generated/maintained markdown: summaries, entity pages, cross-references.
- **The Schema** — a config document defining wiki structure and workflows.

Three core operations define the lifecycle:

- **Ingest** — extract from new sources, integrate across existing pages, update indexes and cross-references.
- **Query** — search relevant pages, synthesize an answer, and **file valuable results back into the wiki** rather than losing them in chat history.
- **Lint** — periodically audit for contradictions, stale claims, orphaned pages, and missing links.

Navigation relies on two special files: `index.md` (catalog by category) and `log.md` (chronological record of ingests/modifications). The key insight: the expensive part of a knowledge base is the *bookkeeping*, so that work is delegated to the LLM.

> Note: this project's own agent memory (under the harness's memory directory) follows the same spirit — one fact per file, an index that points at them, links between related facts. The user-facing wiki and the agent's operational memory are distinct stores; keep them separate.

### 2. Continual Harness — the self-improvement layer

Source: https://arxiv.org/abs/2605.09998 (*Continual Harness: Online Adaptation for Self-Improving Foundation Agents*)

A **reset-free, self-improving harness** wraps the foundation model with tools, memory, and planning. The agent **adapts online within a single run** — no episode resets — continuously refining its own **prompts, sub-agents, skills, and memory** using historical trajectory data. Execution and strategy-refinement alternate, with long-context memory used to spot improvement opportunities. The result: strong performance starting from a minimal interface with no curated domain knowledge.

### How they combine here

The LLM Wiki is the **knowledge that compounds**; the Continual Harness is the **capability that compounds**. The framework treats both the wiki (what the assistant knows) and the assistant's own skills/prompts/sub-agents (how the assistant acts) as living artifacts the assistant maintains over time. When extending the framework, ask which layer a change belongs to: knowledge (wiki ingest/query/lint) or capability (skills, sub-agents, prompts, harness behavior).

## Architecture: recursive orchestration

- A **domain assistant** is defined by its `AGENTS.md` (operating instructions, scope, constraints) plus the `SKILL.md` skills it can invoke and the slice of the wiki it owns.
- An **orchestrator assistant** is itself an assistant whose "domain" is coordination: it decomposes tasks, dispatches to domain assistants, and relays communication between them. Because the model is recursive, an orchestrator can itself be a domain assistant under a higher-level orchestrator.
- Keep this composability intact: a new domain assistant should be self-contained (its own AGENTS.md, skills, and wiki slice) so it works standalone *and* as a child under an orchestrator.

## Conventions to honor

- **Standards-first.** Capabilities are expressed as `SKILL.md` skills and assistant behavior as `AGENTS.md` files, per the public standards — not as harness-specific glue. Anything tied to one harness or one provider is a smell; keep it at the edges.
- **Provider/model agnostic.** Do not hardcode a vendor, model id, or provider SDK into framework core. If model-specific behavior is unavoidable, isolate it behind a clear boundary.
- **Wiki edits are operations, not freeform writes.** When changing wiki content, follow the Ingest/Query/Lint discipline and keep `index.md` and `log.md` consistent with the change.
- **MIT licensed** — keep new files compatible.

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
