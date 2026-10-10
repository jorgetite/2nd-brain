---
type: <type>
title: {{title}}
description: {{one-line summary}}
resource: {{resource-uri-or-omit}}
tags: []
status: {{draft | deprecated — omit when stable}}
generated:
  by: {{assistant-name}}/{{model-id-or-unknown}}
  at: {{YYYY-MM-DDTHH:MM:SS±HH:MM}}
verified:  # only when the human stated or confirmed the content; else omit
  by: human:{{human-id}}
  at: {{YYYY-MM-DDTHH:MM:SS±HH:MM}}
stale_after: {{<datetime> — from this type's horizon in # Authoring; omit if its facts don't age}}
sources:
  - id: {{kebab-id}}
    resource: {{library:<file> | https://… | human:<id> | /<type>/<concept>.md}}
    title: {{short label}}
---

{{summary}}

# <Content heading named for what it holds>
{{one or more such sections, per the type's agreed design; end each sourced claim with its footnote.[^kebab-id]}}

# Examples
{{examples — omit if not applicable}}

[^kebab-id]: {{short label}}

# Authoring
_Rules for filling this template. Not part of a concept page — delete this section when filling._
{{per-type rules — including the stale_after horizon, if this type's facts age — or omit the section if the skeleton alone is enough}}
