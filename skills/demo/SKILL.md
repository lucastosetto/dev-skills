---
name: demo
description: >-
  Turn an implementation (ticket, PR, branch or feature) into a short, presentation-friendly demo:
  few words, diagrams, before/after, and a live demo script, as slides, a doc page or markdown. Use on
  "prepare a demo", "make slides for this feature", "present this implementation", "demo deck",
  "/demo".
argument-hint: "<ticket|pr|branch|feature> [slides|doc|markdown]"
---

# Demo

Follow `../../shared/policy.md`. Run `dev-skills:project-profile` first.

## 1. Material
Run `dev-skills:gather-context` on the ticket/PR, and read the diff (or merged PRs for a feature).
Collect: the problem in the user's terms, what changed, how it works, numbers if available (run
`dev-skills:observe` when the feature is live and impact matters), screenshots via the browser on a
local or staging run when visuals help.

## 2. Story
5-8 slides or sections, one idea each:
1. The problem (who hurt, how).
2. What we built (one sentence + a screenshot).
3. How it works (diagram: flow or components; Mermaid or SVG).
4. Before / after.
5. Live demo script: numbered steps with the data to use, what to click, what to point out.
6. Impact or early numbers (if any).
7. What's next / known limits.
At most ~25 words of text per slide; diagrams and visuals carry the rest. Audience is mixed: no code
unless the user asks.

## 3. Format
Use the format asked for, else the profile/defaults `### demo` note, else slides.
- **slides:** a slide-deck artifact type or slides skill if the session offers one, else a .pptx via the
  pptx skill.
- **doc:** a doc in the connected docs tool (Notion/Confluence/Docs). Creating it there is a shared-tool
  write: confirmation list.
- **markdown:** `demo.md` with Mermaid diagrams in the work folder.

## Output
The link or path, the outline in 5-8 lines, and the demo script.
