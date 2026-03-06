# Design Screen

You are helping the user create a screen design for a section of their product. The screen design will be a Vue 3 component using Composition API that can be exported and integrated into any Vue codebase.

**Important:** This project uses Vue 3 with Composition API. All components must follow the patterns defined in `CLAUDE.md`.

## Step 1: Check Prerequisites

First, identify the target section and verify that `spec.md`, `data.json`, and `types.ts` all exist.

Read `/product/product-roadmap.md` to get the list of available sections.
Read `CLAUDE.md` to understand the Vue.js patterns used in this project.

If there's only one section, auto-select it. If there are multiple sections, use the AskUserQuestion tool to ask which section the user wants to create a screen design for.

Then verify all required files exist:

- `product/sections/[section-id]/spec.md`
- `product/sections/[section-id]/data.json`
- `product/sections/[section-id]/types.ts`

If spec.md doesn't exist:

"I don't see a specification for **[Section Title]** yet. Please run `/shape-section` first to define the section's requirements."

If data.json or types.ts don't exist:

"I don't see sample data for **[Section Title]** yet. Please run `/sample-data` first to create sample data and types for the screen designs."

Stop here if any file is missing.

## Step 2: Check for Design System and Shell

Check for optional enhancements:

**Design Tokens:**
- Check if `/product/design-system/colors.json` exists
- Check if `/product/design-system/typography.json` exists

If design tokens exist, read them and use them for styling. If they don't exist, show a warning:

"Note: Design tokens haven't been defined yet. I'll use default styling, but for consistent branding, consider running `/design-tokens` first."

**Shell:**
- Check if `src/components/shell/AppShell.vue` exists

If shell exists, the screen design will render inside the shell. If not, show a warning:

"Note: An application shell hasn't been designed yet. The screen design will render standalone. Consider running `/design-shell` first to see section screen designs in the full app context."

## Step 3: Analyze Requirements

Read and analyze all three files:

1. **spec.md** - Understand the user flows and UI requirements
2. **data.json** - Understand the data structure and sample content
3. **types.ts** - Understand the TypeScript interfaces and available events

Identify what views are needed based on the spec. Common patterns:

- List/dashboard view (showing multiple items)
- Detail view (showing a single item)
- Form/create view (for adding/editing)

## Step 4: Clarify the Screen Design Scope

If the spec implies multiple views, use the AskUserQuestion tool to confirm which view to build first:

"The specification suggests a few different views for **[Section Title]**:

1. **[View 1]** - [Brief description]
2. **[View 2]** - [Brief description]

Which view should I create first?"

If there's only one obvious view, proceed directly.

## Step 5: Invoke the UI Designer Skill

Before creating the screen design, read the `ui-designer` skill to ensure high-quality visual design output.

Read the file at `.claude/skills/ui-designer/SKILL.md` and follow its guidance for creating pixel-perfect, visually polished interfaces. Pay particular attention to:
- **The 8pt grid** — all spacing must be multiples of 8px
- **Type scale** — use a mathematical ratio, not arbitrary sizes
- **60-30-10 rule** — dominant background, secondary surfaces, 10% accent
- **Component anatomy** — button hierarchy, card patterns, input design
- **Visual quality checklist** — run it before showing any work

## Step 6: Apply Atomic Design Architecture

Before creating any file, classify each component and plan the full component hierarchy.

### The Five Levels

| Level | Definition | Directory | Examples |
|---|---|---|---|
| **Atoms** | Smallest indivisible UI elements. No project-specific logic. Highly reusable. | `src/components/ui/` | `BaseButton.vue`, `BaseInput.vue`, `BaseIcon.vue` |
| **Molecules** | Groups of atoms functioning as a simple unit. Single responsibility. | `src/components/molecules/` | `FormField.vue`, `SearchBar.vue`, `NavItem.vue` |
| **Organisms** | Complex UI sections with domain logic. Composed of molecules and/or atoms. | `src/components/organisms/` | `UserProfileCard.vue`, `NavigationBar.vue`, `DataTable.vue` |
| **Templates** | Page-level layouts defining structure. Wrap `<RouterView>`. | `src/layouts/` | `DefaultLayout.vue`, `AuthLayout.vue` |
| **Pages** | Route-level components. Bind data to templates/organisms. Keep thin. | `src/views/` | `HomeView.vue`, `LoginView.vue` |

### Classification Rules

1. **Start at atom level.** Before creating a molecule, ensure the atoms it needs exist.
2. **Atoms are project-agnostic.** No store imports, no composable imports, no project-specific logic.
3. **Molecules coordinate atoms.** May use composables but not Pinia stores directly.
4. **Organisms own domain logic.** May access stores, call composables, and orchestrate molecules/atoms.
5. **Pages are thin.** Views delegate rendering to organisms and layouts — no significant UI logic.
6. **When in doubt, go smaller.** Easier to compose atoms into a molecule than to break apart a bloated organism.

### Plan the Component Tree

Before writing any code, create an annotated component diagram:

```
[ATOM]     BaseButton.vue         → src/components/ui/
[ATOM]     BaseInput.vue          → src/components/ui/
[MOLECULE] FormField.vue          → src/components/molecules/
[ORGANISM] TaskForm.vue           → src/components/organisms/
[PAGE]     HomeView.vue           → src/views/
```

Check `src/components/ui/` and `src/components/molecules/` first — **reuse existing components before creating new ones**.

### Spec File: Atomic Level Fields

Every spec file must include:

```markdown
**Atomic Level**: Atom | Molecule | Organism | Template | Page
**Atomic Rationale**: [Why this level? What does it compose from or into?]
```

### Atomic Design Quality Gate

Before creating any component, verify:
- [ ] Placed in the correct directory for its atomic level
- [ ] Atoms have no store/composable/project-specific imports
- [ ] Molecules compose from atoms, not raw DOM primitives
- [ ] Organisms own domain logic, not pages or molecules
- [ ] No existing atom or molecule was duplicated
- [ ] Spec file includes Atomic Level and Atomic Rationale

> **Note:** Section components created in `src/components/sections/` serve as design prototypes. During implementation, refactor them into the appropriate Atomic Design directories.

## Step 7: Create the Vue Component

Create the main component file at `src/components/sections/[section-id]/[ViewName].vue`.

### Component Structure

The component MUST:

- Use Vue 3 Composition API with `<script setup>`
- Import types from the types.ts file
- Accept all data via `defineProps`
- Emit events via `defineEmits` for all actions
- Use scoped styles
- Be fully self-contained and portable

Example:

```vue
<script setup lang="ts">
import type { Invoice, InvoiceListEmits } from '@/../product/sections/invoices/types'

// Props
const props = defineProps<{
  invoices: Invoice[]
}>()

// Events
const emit = defineEmits<InvoiceListEmits>()

// Handlers
const handleView = (id: string) => {
  emit('view', id)
}

const handleCreate = () => {
  emit('create')
}
</script>

<template>
  <div class="invoice-list">
    <!-- Header with create button -->
    <div class="list-header">
      <h2>Invoices</h2>
      <button class="btn-primary" @click="handleCreate">
        Create Invoice
      </button>
    </div>

    <!-- Invoice items -->
    <div class="invoice-items">
      <div
        v-for="invoice in invoices"
        :key="invoice.id"
        class="invoice-item"
      >
        <span class="client-name">{{ invoice.clientName }}</span>
        <div class="actions">
          <button @click="emit('view', invoice.id)">View</button>
          <button @click="emit('edit', invoice.id)">Edit</button>
          <button @click="emit('delete', invoice.id)">Delete</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.invoice-list {
  max-width: 64rem;
  margin: 0 auto;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.invoice-items {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.invoice-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: var(--color-neutral-50);
  border-radius: 0.5rem;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .invoice-item {
    background: var(--color-neutral-800);
  }
}
</style>
```

### Design Requirements

- **Mobile responsive:** Use CSS media queries or flexible layouts to ensure the design works on mobile, tablet, and desktop
- **Light & dark mode:** Use CSS custom properties with `@media (prefers-color-scheme: dark)` or CSS variables
- **Use design tokens:** Apply the product's color palette via CSS custom properties (e.g., `var(--color-primary)`)
- **Follow the ui-designer skill:** Create distinctive, memorable interfaces
- **Scoped styles:** Always use `<style scoped>` to prevent CSS leakage

### Applying Design Tokens

**If `/product/design-system/colors.json` exists:**
- Use the primary color for buttons, links, and key accents: `var(--color-primary)`
- Use the secondary color for tags, highlights: `var(--color-secondary)`
- Use the neutral color for backgrounds, text, borders: `var(--color-neutral-*)`

**If `/product/design-system/typography.json` exists:**
- Use font variables: `var(--font-heading)`, `var(--font-body)`

**If design tokens don't exist:**
- Fall back to slate for neutrals and teal for accents

### What to Include

- Implement ALL user flows and UI requirements from the spec
- Use the prop data (not hardcoded values)
- Include realistic UI states (hover, active, focus)
- Emit events for all interactive elements
- Use Vue's `v-for`, `v-if`, `v-show` directives appropriately

### What NOT to Include

- No `import data from` statements - data comes via props
- No features not specified in the spec
- No routing logic - events handle navigation intent
- No navigation elements (shell handles navigation)

## Step 8: Create Sub-Components (If Needed)

For complex views, break down into sub-components. Each sub-component should also use `defineProps` and `defineEmits`.

Create sub-components at `src/components/sections/[section-id]/[SubComponent].vue`.

Example:

```vue
<script setup lang="ts">
import type { Invoice } from '@/../product/sections/invoices/types'

// Props
const props = defineProps<{
  invoice: Invoice
}>()

// Events
const emit = defineEmits<{
  (e: 'view'): void
  (e: 'edit'): void
  (e: 'delete'): void
}>()
</script>

<template>
  <div class="invoice-row">
    <div class="invoice-info">
      <p class="client-name">{{ invoice.clientName }}</p>
      <p class="invoice-number">{{ invoice.invoiceNumber }}</p>
    </div>
    <div class="invoice-actions">
      <button @click="emit('view')">View</button>
      <button @click="emit('edit')">Edit</button>
      <button @click="emit('delete')">Delete</button>
    </div>
  </div>
</template>

<style scoped>
.invoice-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem;
  border-bottom: 1px solid var(--color-neutral-200);
}

.invoice-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.client-name {
  font-weight: 500;
  color: var(--color-neutral-900);
}

.invoice-number {
  font-size: 0.875rem;
  color: var(--color-neutral-500);
}

.invoice-actions {
  display: flex;
  gap: 0.5rem;
}
</style>
```

Then import and use in the main component:

```vue
<script setup lang="ts">
import type { Invoice, InvoiceListEmits } from '@/../product/sections/invoices/types'
import InvoiceRow from './InvoiceRow.vue'

const props = defineProps<{
  invoices: Invoice[]
}>()

const emit = defineEmits<InvoiceListEmits>()
</script>

<template>
  <div class="invoice-list">
    <InvoiceRow
      v-for="invoice in invoices"
      :key="invoice.id"
      :invoice="invoice"
      @view="emit('view', invoice.id)"
      @edit="emit('edit', invoice.id)"
      @delete="emit('delete', invoice.id)"
    />
  </div>
</template>
```

## Step 9: Create the Preview/View Component

Create a view component at `src/views/sections/[SectionName]View.vue`.

This view component imports the sample data and feeds it to the props-based component. It can be used in the router.

Example:

```vue
<script setup lang="ts">
import { ref } from 'vue'
import data from '@/../product/sections/invoices/data.json'
import InvoiceList from '@/components/sections/invoices/InvoiceList.vue'

// Import data
const invoices = ref(data.invoices)

// Event handlers
const handleView = (id: string) => {
  console.log('View invoice:', id)
  // TODO: Navigate to detail view
}

const handleEdit = (id: string) => {
  console.log('Edit invoice:', id)
  // TODO: Open edit modal or navigate
}

const handleDelete = (id: string) => {
  console.log('Delete invoice:', id)
  // TODO: Show confirmation and delete
}

const handleCreate = () => {
  console.log('Create new invoice')
  // TODO: Open create modal or navigate
}
</script>

<template>
  <InvoiceList
    :invoices="invoices"
    @view="handleView"
    @edit="handleEdit"
    @delete="handleDelete"
    @create="handleCreate"
  />
</template>
```

The view component:

- Imports sample data from data.json
- Uses `ref()` for reactive data
- Passes data to the component via props
- Handles emitted events with console.log (for testing) or real logic
- Can be registered in Vue Router
- **Will render inside the shell** if one has been designed

## Step 10: Create Component Index

Create an index file at `src/components/sections/[section-id]/index.js` to cleanly export all components.

Example:

```javascript
export { default as InvoiceList } from './InvoiceList.vue'
export { default as InvoiceRow } from './InvoiceRow.vue'
// Add other sub-components as needed
```

## Step 11: Update Router (Optional)

If the section should be accessible via a route, add it to `src/router/index.js`:

```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // ... existing routes
  {
    path: '/invoices',
    name: 'invoices',
    component: () => import('@/views/sections/InvoicesView.vue')
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
```

## Step 12: Confirm and Next Steps

Let the user know:

"I've created the screen design for **[Section Title]**:

**Exportable components** (props-based, portable):

- `src/components/sections/[section-id]/[ViewName].vue`
- `src/components/sections/[section-id]/[SubComponent].vue` (if created)
- `src/components/sections/[section-id]/index.js`

**View component** (for routing):

- `src/views/sections/[SectionName]View.vue`

**Important:** Restart your dev server to see the changes.

[If shell exists]: The screen design will render inside your application shell, showing the full app experience.

[If design tokens exist]: I've applied your color palette ([primary], [secondary], [neutral]) and typography choices via CSS custom properties.

**Next steps:**

- Run `/screenshot-design` to capture a screenshot of this screen design for documentation
- If the spec calls for additional views, run `/design-screen` again to create them
- When all sections are complete, run `/export-product` to generate the complete export package"

If the spec indicates additional views are needed:

"The specification also calls for [other view(s)]. Run `/design-screen` again to create those, then `/screenshot-design` to capture each one."

## Important Notes

- ALWAYS read the `ui-designer` skill before creating screen designs
- Components MUST use Vue 3 Composition API with `<script setup>`
- Use `defineProps<>()` for type-safe props
- Use `defineEmits<>()` for type-safe events
- The view component is the ONLY file that imports data.json
- Use TypeScript interfaces from types.ts for all props and emits
- Always use `<style scoped>` to prevent CSS leakage
- Always remind the user to restart the dev server after creating files
- Sub-components should also use defineProps/defineEmits for maximum portability
- Apply design tokens via CSS custom properties (e.g., `var(--color-primary)`)
- Screen designs render inside the shell when wrapped in App.vue (if shell exists)
- Follow the patterns defined in CLAUDE.md for consistency
