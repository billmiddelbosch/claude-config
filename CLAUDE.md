# Global Claude Code Preferences

## Communication Style
- Be concise. Lead with the answer. Skip preamble.
- No emojis unless explicitly requested.
- Reference file paths with line numbers when pointing to code.
- Short sentences over long explanations.

## Commit Convention
- Use conventional commits: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`
- Never use `--no-verify` or `--no-gpg-sign`
- Never commit to `main` directly — always use a feature branch
- Never commit without explicit user approval

## Default Tech Stack
- Package manager: npm
- Framework: Vue 3 with Composition API + `<script setup>`
- Language: JavaScript (ES modules) unless the project uses TypeScript
- Default locale: Dutch (`nl`), fallback English (`en`)
- Tailwind CSS v4 (no config file; tokens via `@theme {}` in CSS)

## Workflow Preferences
- Always read files before editing them
- Prefer editing existing files over creating new ones
- Ask before any destructive git operation (reset, force-push, branch delete)
- Never auto-push — leave push to the user unless explicitly asked
- Use worktrees for isolated experiments

## Projects
- `~/development/wieDoetHet` — primary active project (Vue 3, npm, AWS Lambda backend)
- `~/development/myGuide` — secondary project (Vue 3, cityCast)
- `~/development/claude-config` — this config repo (agents, commands, skills)
