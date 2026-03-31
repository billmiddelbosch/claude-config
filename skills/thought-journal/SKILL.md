---
name: thought-journal
description: >
  Use this skill whenever the user wants to log, capture, or record a "thought of the day",
  daily reflection, personal insight, or any idea they want to preserve in their thought journal.
  Triggers include: "thought of the day", "log my thought", "add to my journal", "I've been thinking
  about...", "my thought today is...", "add this to my thought paper", or any time the user shares
  a personal insight or reflection they want saved. Also triggers when the user asks to review,
  search, or browse their thought journal, OR when they ask to generate a blog post, LinkedIn post,
  or podcast script from their journal entries. Works fully on mobile — no browser or desktop tools needed.
---

# Thought Journal Skill

A personal thought journal that captures daily insights as individual Markdown files in GitHub,
organized by theme — and serves as a content pipeline for blogs, LinkedIn posts, and (optionally) podcasts.

**Source of truth**: GitHub repo `billmiddelbosch/thought-journal`
**Mobile-first**: No browser tools required for core journaling flow.

---

## Folder Structure in GitHub

```
thought-journal/
├── entries/
│   ├── 2026-03-31-ai-als-collega.md
│   ├── 2026-03-28-waarde-van-slow-thinking.md
│   └── ...
├── themes/
│   ├── _technologie-toekomst.md     ← thema-index
│   ├── _werk-ambitie.md
│   └── ...
└── output/
    ├── blog-technologie-toekomst-v1.md
    └── linkedin-ai-als-collega.md
```

Each entry = one file. Theme indexes group entries. Output folder holds generated content.

---

## Modes

This skill has three modes. Detect which mode applies from the user's message:

**MODE 1 — LOG**: User shares a thought → capture, enrich, save entry + update theme index
**MODE 2 — BROWSE**: User wants to review past entries or a theme → read and summarize
**MODE 3 — PUBLISH**: User wants a blog, LinkedIn post, or podcast script from entries → generate content

---

## MODE 1: Log a New Thought

### Step 1: Capture

Ask: *"Wat is jouw gedachte van vandaag?"* — unless already shared.
Use today's date in format `YYYY-MM-DD`.

### Step 2: Enrich

Use web search to find:
- **Citaat**: A resonant quote from a known thinker. Translate to Dutch, original in parentheses.
- **Context**: 3–5 sentences expanding the idea — historical roots, scientific or philosophical angle.

### Step 3: Detect Theme

Assign one theme (or create new if none fit):
- Filosofie & Betekenis
- Creativiteit & Expressie
- Mensen & Relaties
- Werk & Ambitie
- Natuur & Wetenschap
- Zelf & Groei
- Samenleving & Verandering
- Gezondheid & Lichaam
- Technologie & Toekomst

### Step 4: Read Existing Entries for Cross-referencing

Search the GitHub repo for related entries:
```
mcp__github__search_code: repo:billmiddelbosch/thought-journal [keyword]
```
Scan the 3 most relevant results. Note any past entry that connects to today's thought.

### Step 5: Build the Entry File

**Filename**: `YYYY-MM-DD-[slug].md`
where slug = 3–5 Dutch words from the thought, lowercase, hyphens, no special chars.

**File content**:
```markdown
---
date: YYYY-MM-DD
theme: [Thema naam]
slug: [slug]
tags: [tag1, tag2, tag3]
summary: [One-line samenvatting]
---

# [Datum] — [One-line samenvatting]

## Mijn Gedachte
[The user's thought, verbatim or lightly cleaned up]

## Context
[3–5 sentence enrichment paragraph]

## Citaat
> "[Quote text]"
> — [Author]

## Gerelateerde Gedachten
- [YYYY-MM-DD](../entries/YYYY-MM-DD-slug.md): [Brief link to related past entry]
```
*(Omit Gerelateerde Gedachten section if no relevant past entries found)*

### Step 6: Save Entry to GitHub

Use `mcp__github__create_or_update_file` to commit the entry:
- **repo**: `billmiddelbosch/thought-journal`
- **path**: `entries/YYYY-MM-DD-[slug].md`
- **content**: the markdown file content (base64-encoded)
- **message**: `journal: add YYYY-MM-DD-[slug]`
- **branch**: `main`

First check if the file already exists using `mcp__github__get_file_contents` to retrieve the current SHA (required for updates).

**Fallback if GitHub MCP unavailable** → present the markdown file as a copy-able artifact
and instruct the user (in Dutch) to manually commit it to `entries/` in the `billmiddelbosch/thought-journal` repo.

### Step 7: Update the Theme Index

Fetch the existing theme index using:
```
mcp__github__get_file_contents: repo:billmiddelbosch/thought-journal path:themes/_[thema-slug].md
```

**If exists**: retrieve content + SHA, prepend new entry reference to the entries list, then commit with `mcp__github__create_or_update_file` (include SHA for update).
**If not**: create new theme index file with `mcp__github__create_or_update_file`.

**Theme index format** (`_technologie-toekomst.md`):
```markdown
---
theme: Technologie & Toekomst
entry_count: 4
last_updated: YYYY-MM-DD
---

# Technologie & Toekomst

Alle dagboekentries over dit thema, meest recent bovenaan.

## Entries
- [YYYY-MM-DD — Samenvatting](../entries/YYYY-MM-DD-slug.md)
- [YYYY-MM-DD — Samenvatting](../entries/YYYY-MM-DD-slug.md)

## Content gemaakt van dit thema
- [Blog: Titel](../output/blog-technologie-toekomst-v1.md) — YYYY-MM-DD
```

**Commit message**: `journal: update theme index [thema-slug]`

### Step 8: Update Master README Index

Fetch the existing README using:
```
mcp__github__get_file_contents: repo:billmiddelbosch/thought-journal path:README.md
```

**If exists**: retrieve content + SHA. Find the entries table (between `<!-- ENTRIES_START -->` and `<!-- ENTRIES_END -->` markers) and prepend a new row for this entry.
**If not**: create the full README from scratch using the template below.

**README.md format**:
```markdown
# Thought Journal — Bill Middelbosch

Persoonlijk dagboek van inzichten, reflecties en ideeën. Opgeslagen als Markdown — bruikbaar als bron voor NotebookLM, blogs en LinkedIn posts.

## Statistieken
- **Totaal entries**: [N]
- **Laatste entry**: [YYYY-MM-DD]
- **Thema's**: Filosofie & Betekenis · Creativiteit & Expressie · Mensen & Relaties · Werk & Ambitie · Natuur & Wetenschap · Zelf & Groei · Samenleving & Verandering · Gezondheid & Lichaam · Technologie & Toekomst

---

## Alle Entries

<!-- ENTRIES_START -->
| Datum | Thema | Samenvatting |
|-------|-------|--------------|
| [YYYY-MM-DD](entries/YYYY-MM-DD-slug.md) | [Thema] | [One-line samenvatting] |
<!-- ENTRIES_END -->

---

## Gegenereerde Content

<!-- OUTPUT_START -->
| Datum | Type | Titel |
|-------|------|-------|
| [YYYY-MM-DD](output/filename.md) | Blog / LinkedIn | [Titel of slug] |
<!-- OUTPUT_END -->

---

*Gegenereerd door Claude · Bronbestanden in `entries/` · Gegenereerde content in `output/`*
```

When updating an existing README:
- Increment the entry count in the Statistieken section
- Update "Laatste entry" date
- Prepend the new row **after** `<!-- ENTRIES_START -->` (most recent first)

**Commit message**: `journal: update README index`

---

### Step 9: Confirm in Chat (in Dutch)

```
✅ Opgeslagen in GitHub onder **[Thema]**

**[Datum] — [Samenvatting]**

*"[Citaat]"* — [Auteur]

[1 zin context]

[🔗 Gekoppeld aan [datum] over [onderwerp] — alleen indien relevant]

💡 Dit thema heeft nu [N] entries. Wil je hier een blog of LinkedIn post van maken?
```

---

## MODE 2: Browse Journal

When the user asks to review entries, find a past thought, or explore a theme:

1. Search repo: `mcp__github__search_code` with relevant keywords or theme name in `billmiddelbosch/thought-journal`
2. Fetch the most relevant files via `mcp__github__get_file_contents`
3. Summarize findings conversationally in Dutch
4. Offer to generate content: *"Wil je hier een blog of LinkedIn post van maken?"*

---

## MODE 3: Generate Content from Entries

Triggered by: "maak een blog", "LinkedIn post", "schrijf een artikel", "podcast script",
or when the user references a theme and wants to publish.

### Step 1: Gather Source Entries

Ask which theme or entries to use — or infer from context.
List entries in the relevant theme folder or search by keyword using `mcp__github__search_code`.
Fetch all relevant entry files via `mcp__github__get_file_contents`.

### Step 2: Generate the Content

#### Blog Post (800–1200 woorden)
- Toon: Persoonlijk maar professioneel. Eerste persoon. Concreet en toegankelijk.
- Structuur:
  - **Opening**: Prikkelende stelling of anekdote (geen "In dit artikel...")
  - **Kern**: 3 inzichten uit de entries, elk met eigen alinea
  - **Synthese**: Wat verbindt deze gedachten?
  - **Slot**: Oproep tot reflectie of actie — geen samenvatting
- Bronvermelding: Sluit af met *"Gebaseerd op dagboekentries van [datum] t/m [datum]"*

#### LinkedIn Post (max 1300 tekens)
- Haakje in de eerste zin (geen "Ik heb nagedacht over...")
- Witregels tussen alinea's (mobiele leesbaarheid)
- 1 centrale stelling, 2–3 ondersteunende punten
- Afsluiting met vraag aan de lezer
- 3–5 relevante hashtags
- Geen bullet points — vloeiende tekst

#### Podcast Script (optioneel, op verzoek)
- Intro: 30 seconden, prikkelende stelling
- Segment 1–3: Elk één entry als vertrekpunt, conversationele stijl
- Verbindende zinnen tussen segmenten
- Outro: Open vraag aan luisteraar
- Tijdsinschatting: ~1 minuut per 150 woorden

### Step 3: Save Output to GitHub and Update README Index

Commit generated content to `output/` using `mcp__github__create_or_update_file`:
- **repo**: `billmiddelbosch/thought-journal`
- **path**: `output/blog-[thema-slug]-v[N].md` / `output/linkedin-[slug]-[datum].md` / `output/podcast-[thema-slug]-[datum].md`
- **message**: `output: add [type] [slug]`
- **branch**: `main`

Update the relevant theme index to reference the new output file.

Then fetch `README.md` and prepend a new row to the output table (between `<!-- OUTPUT_START -->` and `<!-- OUTPUT_END -->` markers):
```
| [YYYY-MM-DD](output/filename.md) | [Blog / LinkedIn / Podcast] | [Titel of slug] |
```
Commit with message: `journal: update README output index`

### Step 4: Present to User

Show the full content in chat so the user can copy directly — especially important on mobile.
Offer follow-up: *"Wil je iets aanpassen, of direct opslaan?"*

---

## Mobile-First Principles

- **No browser tools in core flow** — everything runs via GitHub MCP + Claude
- **Always show content in chat** — user can copy/paste on mobile without needing file downloads
- **Short confirmation messages** — mobile screens are small
- **Proactive suggestions** — after logging, always suggest the next logical step
- **Offline fallback** — if GitHub MCP unavailable, generate markdown artifact + clear manual instructions in Dutch

---

## Greeting Behavior

When no other task is given, open with:
> *"Goedemorgen/middag/avond, Bill! 🌱 Wat is jouw gedachte van vandaag?"*

Warm, brief, no preamble. If thought already shared, skip greeting.

---

## Tone & Voice

- **Journal entries**: Dutch, persoonlijk, informatief maar toegankelijk
- **Blog**: Eerste persoon, concreet, geen jargon — schrijf voor MKB-ondernemers
- **LinkedIn**: Direct, energiek, nodigt uit tot reactie
- **Podcast**: Conversationeel, alsof je met één persoon praat

---

## Dependencies

- `mcp__github__create_or_update_file` — create or update files (commits to `billmiddelbosch/thought-journal`)
- `mcp__github__get_file_contents` — read file contents from repo
- `mcp__github__search_code` — search entries by keyword
- Web search — quotes en context verrijking
- No browser tools required for core flow
