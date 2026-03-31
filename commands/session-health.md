---
name: session-health
description: Periodic session health check — context usage, Vue/Lambda standards compliance, spec file sync, and token efficiency. Flags issues and proposes fixes. Never auto-fixes without explicit approval.
---

Perform a session health check across these 4 areas. For **each finding**, clearly flag the issue, propose a specific fix, and explicitly wait for my approval before making any changes.

---

## 1. Context Usage

Report current context window usage.
- If >70%: Flag `⚠️ CONTEXT WARNING: X% used` and suggest specific items to summarize or clear to reduce usage.
- If >90%: Flag `🔴 CONTEXT CRITICAL: X% used` and strongly recommend immediate action.

---

## 2. Vue.js Standards Compliance

Review all `.vue` files modified in this session. Check each against these standards:

- `<script setup lang="ts">` used — never Options API
- Props defined with TypeScript generics: `defineProps<{ ... }>()`
- Emits defined with TypeScript generics: `defineEmits<{ ... }>()`
- No `any` types
- `@/` path alias used for all imports
- `<RouterLink>` used for internal navigation — never raw `<a>` tags
- Component filename is PascalCase
- API calls live in composables (`src/composables/`), not directly in components
- Global state in Pinia stores; local ephemeral state with `ref`/`reactive`
- Translation keys added to both `en.json` and `nl.json` when new UI strings are added

For each violation:
> 🔴 **STANDARDS VIOLATION** in `[file]:[line]`
> _Issue:_ [description]
> _Proposed fix:_ [corrected code snippet]
> **Waiting for approval before applying.**

---

## 3. Specification File Sync

Review all `.vue` files and Lambda function files modified in this session. Check whether the corresponding specification files reflect those changes.

Specification targets to check:
- Feature spec files (any `specs/`, `docs/`, or `*.spec.md` files)
- Type definitions in `src/types/`
- API contracts or interface definitions
- Route definitions in `src/router/index.ts` (if new views were added)
- Lambda function specs or README files alongside the function

For each out-of-sync spec:
> 📋 **SPEC UPDATE NEEDED**: `[spec file]`
> _What changed:_ [summary of code change]
> _Proposed spec update:_ [exact content to add/change]
> **Waiting for approval before updating.**

---

## 4. Token Efficiency

Scan the conversation for inefficient token usage patterns:

- Large files re-read multiple times when content hasn't changed
- Verbose responses where a concise answer would suffice
- Redundant tool calls (same file read twice, same search repeated)
- Entire large files passed when only a section was needed
- Long back-and-forth clarification chains that could have been resolved upfront

For each inefficiency found:
> 💡 **TOKEN INEFFICIENCY**
> _Pattern:_ [what is happening]
> _Suggestion:_ [how to avoid it going forward]

---

## Summary

After all checks, output this block:

```
╔══════════════════════════════════╗
║       SESSION HEALTH REPORT      ║
╠══════════════════════════════════╣
║ Context:    X% used   [STATUS]   ║
║ Standards:  X violations found   ║
║ Spec sync:  X files out of sync  ║
║ Efficiency: X issues found       ║
╚══════════════════════════════════╝
```

Status values: ✅ OK | ⚠️ WARNING | 🔴 CRITICAL

**Do NOT auto-fix anything. Propose all changes and wait for explicit approval.**
