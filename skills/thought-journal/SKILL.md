-----

## name: thought-journal
description: >
Use this skill whenever the user wants to log, capture, or record a “thought of the day”,
daily reflection, personal insight, or any idea they want to preserve in their thought journal.
Triggers include: “thought of the day”, “log my thought”, “add to my journal”, “I’ve been thinking
about…”, “my thought today is…”, “add this to my thought paper”, or any time the user shares
a personal insight or reflection they want saved. Also triggers when the user asks to review,
search, or browse their thought journal. This skill writes directly to Obsidian via obsidian://
deep links into the Bill vault, organized by theme folder.

# Thought Journal Skill

A personal thought journal that captures the user’s daily thought, enriches it with context and
quotes, and opens it directly in Obsidian via a deep link. Each entry becomes a separate markdown
note inside a theme-based folder in the **Bill** vault.

No file uploads, no Google Drive. Just a single `obsidian://new` deep link that opens the note
instantly in the app.

-----

## Overview

When the user shares a thought, this skill:

1. **Captures** the thought with today’s date
1. **Enriches** it with: a relevant quote, contextual background, and links to past similar thoughts
1. **Auto-detects** the theme/topic → determines the folder
1. **Builds** a markdown note locally
1. **Generates** an `obsidian://new` deep link that opens the note directly in Obsidian

-----

## Greeting Behavior (New Conversation)

When a new conversation starts and no other task has been given, Claude should open with:

> *“Goedemorgen/middag/avond, Bill! 🌱 Wat is jouw gedachte van vandaag?”*

Keep it warm and brief — no preamble, no explanation. Just the greeting and the question.
If the user has already shared a thought in their opening message, skip the greeting and go straight to Step 2.

-----

## Workflow

### Step 1: Capture the Thought

Ask the user: *“What’s your thought of the day?”* — unless they’ve already shared it.

Note today’s date (use the `user_time_v0` tool if available, otherwise ask).

### Step 2: Enrich the Thought

Use web search (if available) to find:

- **A relevant quote** from a known thinker, author, or figure that resonates with the thought
- **Background context**: a brief paragraph (3–5 sentences) that expands on the idea — historical roots, scientific angle, philosophical dimension, etc.

### Step 3: Detect Theme → Determine Folder

Based on the thought’s content, assign it to one of the following themes. The theme becomes the
**subfolder** inside the vault:

|Theme                  |Obsidian folder                      |
|-----------------------|-------------------------------------|
|Philosophy & Meaning   |`Thoughts/Filosofie & Betekenis/`    |
|Creativity & Expression|`Thoughts/Creativiteit & Expressie/` |
|People & Relationships |`Thoughts/Mensen & Relaties/`        |
|Work & Ambition        |`Thoughts/Werk & Ambitie/`           |
|Nature & Science       |`Thoughts/Natuur & Wetenschap/`      |
|Self & Growth          |`Thoughts/Zelf & Groei/`             |
|Society & Change       |`Thoughts/Samenleving & Verandering/`|
|Health & Body          |`Thoughts/Gezondheid & Lichaam/`     |
|Technology & Future    |`Thoughts/Technologie & Toekomst/`   |
|*(new theme)*          |`Thoughts/[Nieuwe naam]/`            |

Use your judgment. One thought = one theme = one folder.

### Step 4: Build the Markdown Note

Create the note content in markdown. Use the following structure:

```markdown
---
date: YYYY-MM-DD
thema: [Theme name in Dutch]
tags: [gedachte, thema-slug]
---

# [One-line summary of the thought]

## Mijn Gedachte
[The user's thought, verbatim or lightly cleaned up]

---

## Context
[3–5 sentence background/enrichment paragraph in Dutch]

---

## Citaat
> "[Quote text in Dutch, original in parentheses if translated]"
> — [Author, source if known]

---

## Gerelateerde Gedachten
- [[ ]] ← leave empty if no known related notes; suggest the user link manually
```

Write the note content as a string. Keep it clean markdown — no HTML.

### Step 5: Generate the Obsidian Deep Link

Construct an `obsidian://new` URI:

```
obsidian://new?vault=Bill&file=Thoughts%2F[EncodedFolder]%2F[EncodedFilename]&content=[EncodedContent]
```

- **vault**: `Bill`
- **file**: path including theme subfolder, e.g. `Thoughts/Technologie & Toekomst/2025-04-01 AI als spiegel`
- **content**: the full markdown note content from Step 4
- All path segments and content must be **URL-encoded** (`encodeURIComponent` in JS, `urllib.parse.quote` in Python)

#### File naming convention:

```
YYYY-MM-DD [Short title].md
```

Example: `2025-04-01 AI als spiegel voor menselijk denken.md`

### Step 6: Present the Deep Link to the User

Render the deep link as a clickable button or link in the chat:

> 📖 **[Open in Obsidian](obsidian://new?vault=Bill&...)**

Add a brief confirmation in Dutch:

> ✅ Klaar! Klik op de link om de note direct in Obsidian te openen onder **Thoughts/[Thema]/**
> 
> **[Datum] — [Samenvatting]**
> 
> *”[Citaat]”* — [Auteur]
> 
> [1-zin samenvatting van de toegevoegde context]

The user clicks the link → Obsidian opens with the note pre-filled, ready to save.

-----

## Important: URL Encoding

The `content` parameter can be long. Always fully URL-encode it. Special characters that must
be encoded include: spaces (`%20`), newlines (`%0A`), `#` (`%23`), `&` (`%26`), `=` (`%3D`),
`/` (`%2F`), quotes (`%22`), `>` (`%3E`), `-` can stay as-is.

In practice: use `encodeURIComponent()` on the entire content string, and encode the file path
segments individually.

If the resulting URL is very long (>2000 chars), use the `append` action instead with a shorter
content, and tell the user the full note is shown in chat for copy-paste:

```
obsidian://new?vault=Bill&file=[path]
```

Then show the full markdown in a code block so the user can paste it manually.

-----

## No Google Drive, No File Uploads

This skill does **not** use Google Drive, docx files, or browser automation.
The entire flow is: build markdown → encode → deep link → user clicks → Obsidian opens.

-----

## Tone & Voice

- All journal entries are written in **Dutch**
- The greeting and chat confirmation are also in Dutch
- Enrichment text: **informatief maar toegankelijk** — geen jargon
- Quotes: **genuinely resonant** — translate to Dutch if needed, original in parentheses
- The journal should feel **persoonlijk en doordacht**, not clinical

-----

## Dependencies

- `user_time_v0` tool (for today’s date)
- Web search (for quote + context enrichment)
- URL encoding (built-in, no extra libraries needed)
- Obsidian installed on user’s device with vault named **Bill**