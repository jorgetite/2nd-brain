# Concepts

This framework is the synthesis of two ideas. Each is worth reading in full; this page distills
how they combine here.

## 1. The LLM Wiki — knowledge that compounds

Source: Karpathy, *LLM Wiki* — https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

Rather than re-retrieving and re-synthesizing knowledge on every query (classic RAG), the assistant
**incrementally builds and maintains a persistent, LLM-authored wiki** of markdown that compounds
over time. Knowledge is integrated once and updated as new sources arrive.

- **Raw sources** — immutable inputs (`sources/`: inbox → library/archive).
- **The wiki** — curated, interlinked markdown pages (`wiki/`).
- **The schema** — how this wiki is organized (`wiki/schema.md`).

Three operations form the lifecycle, one skill each: **ingest**, **query**, **lint**.

## 2. The Continual Harness — capability that compounds

Source: *Continual Harness: Online Adaptation for Self-Improving Foundation Agents* —
https://arxiv.org/abs/2605.09998

A reset-free, self-improving harness adapts the agent *during* operation — refining its own prompts,
skills, and memory from its activity history, without resets. Here, model weights are frozen; what
adapts is the **harness**: the assistant's memory and skills. That loop is the `reflect` skill,
driven by the working-memory activity stream.

## How they combine

The wiki is **what the assistant knows**; the skills and memory are **how it acts**. Both are living
artifacts the assistant maintains. When extending the framework, ask which half a change belongs to:
knowledge (wiki: ingest / query / lint) or capability (memory + skills: reflect).

See also: [memory model](memory.md), [recursion](recursion.md).
