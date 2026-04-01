# Bill Middelbosch — Claude Code Context

## About

Freelance product owner and AI enthusiast. Founder of **AIntern** — helping small companies automate their business processes using AI.

Projects are built solo for different clients but share a common architecture. Each project is a **monorepo** containing a Vue 3 frontend and an AWS CDK backend.

---

## Technology Stack

Applies to all projects unless a project-level `CLAUDE.md` states otherwise.

### Frontend
- Vue 3 + TypeScript — always Composition API with `<script setup>`
- Pinia (state management), Vue Router (routing)
- Tailwind CSS 4, Lucide Vue Next (icons)
- Axios with auth interceptors, VueUse
- Vue I18n — **default locale: Dutch (nl), English (en) required as first translation**
- Vitest (unit), Playwright (e2e)

### Backend
- AWS Lambda — Node.js 22, TypeScript
- AWS CDK (TypeScript) for all infrastructure — `NodejsFunction` + esbuild, no manual zipping
- DynamoDB single-table design (PK/SK composite key + GSI1)
- API Gateway REST with dev/prod stage variable aliases
- S3 for file storage, AWS Secrets Manager for all secrets
- Anthropic Claude API for AI features
- **Default AWS region: eu-west-2 (London)**

### Tooling
- npm, Vite (frontend), esbuild (Lambda bundling via CDK)
- ESLint flat config + Prettier: no semicolons, single quotes, 2-space indent, 100-char width, trailing commas, LF line endings
- Path alias `@/*` → `./src/*`

### Project Structure
```
project-root/
  src/          # Vue 3 frontend
  infra/
    bin/        # CDK app entry
    lib/        # CDK stacks
    lambda/     # Lambda handlers (named: {project}-{handler})
  e2e/          # Playwright tests
  product/      # Product docs, specs, backlog
  knowledge/    # Project-scoped knowledge domains
  decisions/    # Architecture decision records
```

---

## Workflow Rules

These apply to every conversation and every project, regardless of which agent is active.

- **Always present options before acting** — describe the available approaches and ask which to take before proceeding with any significant decision or implementation choice
- **Always branch first** — create a feature branch before writing any code; never write code on `main`
- **Never commit or push without explicit confirmation** — always ask, always wait for approval
- **Always present a numbered build plan** before writing any files — list every work unit and wait for approval before starting
- **Always ask for the client name** at the start of project work to load client-specific rules from agent memory
- **Spec files must stay in sync** — check before implementing, update after every stage that produces code

---

## Security

Security is non-negotiable and must be applied proactively, not as an afterthought.

- **No secrets or credentials in code** — always use AWS Secrets Manager or environment variables
- **IAM least-privilege** — no wildcards on actions or resources; every policy must be scoped to exact resources
- **Validate all input at system boundaries** — user input, API payloads, Lambda event data
- **No injection vectors** — NoSQL injection, XSS, command injection
- **No hardcoded configuration** — regions, table names, endpoint URLs go in environment variables
- **Run the `security-reviewer` agent proactively** on any code that handles authentication, user input, API endpoints, file uploads, or sensitive data — do not wait to be asked
- **Flag security concerns immediately** — do not proceed past a security issue without explicit acknowledgement from the user

---

## Code Review

The `code-reviewer` agent **must be invoked after every code change** — this is a hard rule, not a suggestion. Do not mark any task complete without having run it. CRITICAL findings block completion; HIGH findings require explicit user approval to proceed.

---

## Communication

- **Present options before acting** — always
- Be concise: no preamble, no trailing summaries, no restating what the user said
- When referencing code, include `file_path:line_number`
- Conversation language: **English**
- Application UI: Dutch (nl) as default, English (en) as first required translation

---

## Knowledge System

Projects use a three-scope knowledge hierarchy. Check in priority order before every feature; extract insights and log decisions during REVIEW.

| Scope | Location |
|---|---|
| **Universal** | `~/.claude/agent-memory/{agent}/knowledge/{domain}/rules.md` |
| **Client** | `~/.claude/agent-memory/{agent}/clients/{name}/rules.md` |
| **Project** | `/knowledge/{domain}/` and `/decisions/` in the project repo |

---

## Available Agents

| Agent | Use when |
|---|---|
| `vuejs-feature-builder` | Building or fixing anything in the Vue.js frontend |
| `lambda-feature-builder` | Building or fixing Lambda functions or CDK infrastructure |
| `dynamodb-feature-builder` | Designing or modifying DynamoDB schemas and access patterns |
| `vuejs-project-scaffolder` | Bootstrapping a new Vue.js project from scratch |
| `code-reviewer` | After every code change — mandatory |
| `security-reviewer` | Any code touching auth, user input, APIs, or sensitive data — proactive |
| `backlog-manager` | Managing the product backlog |
