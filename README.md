# claude-config

Personal Claude Code configuration: agents, commands, and skills.

## Contents

- **agents/** — Reusable Claude agents (Vue.js feature builder, project scaffolder)
- **commands/** — Slash commands for Claude Code
  - `Vision/` — Product vision and roadmap
  - `design/` — Design workflow (data model → tokens → shell → screen design)
- **skills/** — Claude Code skills with reference docs
  - `ui-designer/` — Visual design, component library, design tokens
  - `ux-designer/` — UX patterns, flows, psychology

## Install

### macOS / Linux

```bash
git clone https://github.com/billmiddelbosch/claude-config.git
chmod +x install.sh
./install.sh
```

### Windows

```powershell
git clone https://github.com/billmiddelbosch/claude-config.git
cd claude-config
.\install.ps1
```

---

This creates symlinks (or junctions on Windows) from `~/.claude/{agents,commands,skills}` to this repo.
A `git pull` is all you need to update on any machine.

## Update

```bash
cd ~/claude-config
git pull
```

## Claude structure

### local
\Users\<user>\.claude\
- Folders /agents /commands /skills link to /Gebruikers/<user>/claude-config

\Users\<user>\.claude\plugins\cache\claude-plugins-official"
- Also consist of agents, commands and skills


