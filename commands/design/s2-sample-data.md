# Sample Data

You are helping the user create realistic sample data for a section of their product. This data will be used to populate Vue.js screen designs. You will also generate TypeScript types based on the data structure.

**Important:** This project uses Vue 3 with Composition API. All types must be compatible with Vue's `defineProps()` and `defineEmits()` patterns as defined in `CLAUDE.md`.

## Step 1: Check Prerequisites

First, identify the target section and verify that `spec.md` exists for it.

Read `/product/product-roadmap.md` to get the list of available sections.
Read `CLAUDE.md` to understand the Vue.js patterns used in this project.

If there's only one section, auto-select it. If there are multiple sections, use the AskUserQuestion tool to ask which section the user wants to generate data for.

Then check if `product/sections/[section-id]/spec.md` exists. If it doesn't:

"I don't see a specification for **[Section Title]** yet. Please run `/shape-section` first to define the section's requirements, then come back to generate sample data."

Stop here if the spec doesn't exist.

## Step 2: Check for Global Data Model

Check if `/product/data-model/data-model.md` exists.

**If it exists:**
- Read the file to understand the global entity definitions
- Entity names in your sample data should match the global data model
- Use the descriptions and relationships as a guide

**If it doesn't exist:**
Show a warning but continue:

"Note: A global data model hasn't been defined yet. I'll create entity structures based on the section spec, but for consistency across sections, consider running `/data-model` first."

## Step 3: Analyze the Specification

Read and analyze `product/sections/[section-id]/spec.md` to understand:

- What data entities are implied by the user flows?
- What fields/properties would each entity need?
- What sample values would be realistic and helpful for design?
- What actions can be taken on each entity? (These become emitted events in Vue)

**If a global data model exists:** Cross-reference the spec with the data model. Use the same entity names and ensure consistency.

## Step 4: Present Data Structure

Present your proposed data structure to the user in human-friendly language. Non-technical users should understand how their data is being organized.

**If using global data model:**

"Based on the specification for **[Section Title]** and your global data model, here's how I'm organizing the data:

**Entities (from your data model):**

- **[Entity1]** — [Description from data model]
- **[Entity2]** — [Description from data model]

**Section-specific data:**

[Any additional data specific to this section's UI needs]

**What You Can Do:**

- View, edit, and delete [entities]
- [Other key actions from the spec]

**Sample Data:**

I'll create [X] realistic [Entity1] records with varied content to make your screen designs feel real.

Does this structure make sense? Any adjustments?"

**If no global data model:**

"Based on the specification for **[Section Title]**, here's how I'm proposing to organize your data:

**Data Models:**

- **[Entity1]** — [One sentence explaining what this represents]
- **[Entity2]** — [One sentence explanation]

**How They Connect:**

[Explain relationships in simple terms]

**What You Can Do:**

- View, edit, and delete [entities]
- [Other key actions from the spec]

**Sample Data:**

I'll create [X] realistic [Entity1] records with varied content to make your screen designs feel real.

Does this structure make sense for your product? Any adjustments?"

Use the AskUserQuestion tool if there are ambiguities about what data is needed.

## Step 5: Generate the Data File

Once the user approves the structure, create `product/sections/[section-id]/data.json` with:

- **A `_meta` section** - Human-readable descriptions of each data model and their relationships (displayed in the UI)
- **Realistic sample data** - Use believable names, dates, descriptions, etc.
- **Varied content** - Mix short and long text, different statuses, etc.
- **Edge cases** - Include at least one empty array, one long description, etc.
- **Vue-friendly structure** - Use consistent field names and types compatible with Vue's reactivity

### Required `_meta` Structure

Every data.json MUST include a `_meta` object at the top level with:

1. **`models`** - An object where each key is a model name and value is a plain-language description
2. **`relationships`** - An array of strings explaining how models connect to each other

Example structure:

```json
{
  "_meta": {
    "models": {
      "invoices": "Each invoice represents a bill you send to a client for work completed.",
      "lineItems": "Line items are the individual services or products listed on each invoice."
    },
    "relationships": [
      "Each Invoice contains one or more Line Items (the breakdown of charges)",
      "Invoices track which Client they belong to via the clientName field"
    ]
  },
  "invoices": [
    {
      "id": "inv-001",
      "invoiceNumber": "INV-2024-001",
      "clientName": "Acme Corp",
      "clientEmail": "billing@acme.com",
      "total": 1500.00,
      "status": "sent",
      "dueDate": "2024-02-15",
      "lineItems": [
        { "description": "Web Design", "quantity": 1, "rate": 1500.00 }
      ]
    }
  ]
}
```

The `_meta` descriptions should:
- Use plain, non-technical language
- Explain what each model represents in the context of the user's product
- Describe relationships in terms of "contains", "belongs to", "links to", etc.
- **Match the global data model descriptions if one exists**

The data should directly support the user flows and UI requirements in the spec.

## Step 6: Generate TypeScript Types for Vue

After creating data.json, generate `product/sections/[section-id]/types.ts` based on the data structure.

### Type Generation Rules

1. **Infer types from the sample data values:**
   - Strings → `string`
   - Numbers → `number`
   - Booleans → `boolean`
   - Arrays → `TypeName[]`
   - Objects → Create a named interface

2. **Use union types for status/enum fields:**
   - If a field like `status` has known values, use a union: `'draft' | 'sent' | 'paid' | 'overdue'`
   - Base this on the spec and the variety in sample data

3. **Create Vue-compatible prop type definitions:**
   - Props are defined for use with Vue's `defineProps()`
   - Use `PropType` from Vue for complex types
   - Events are listed separately for use with `defineEmits()`

4. **Use consistent entity names:**
   - If a global data model exists, use the same entity names
   - This ensures consistency across sections

Example types.ts for Vue:

```typescript
import type { PropType } from 'vue'

// =============================================================================
// Data Types
// =============================================================================

export interface LineItem {
  description: string
  quantity: number
  rate: number
}

export interface Invoice {
  id: string
  invoiceNumber: string
  clientName: string
  clientEmail: string
  total: number
  status: 'draft' | 'sent' | 'paid' | 'overdue'
  dueDate: string
  lineItems: LineItem[]
}

// =============================================================================
// Component Props (for use with defineProps)
// =============================================================================

/**
 * Props for InvoiceList.vue
 *
 * Usage in component:
 * ```vue
 * <script setup>
 * import type { Invoice } from '@/../product/sections/invoices/types'
 *
 * const props = defineProps<{
 *   invoices: Invoice[]
 * }>()
 *
 * const emit = defineEmits<{
 *   view: [id: string]
 *   edit: [id: string]
 *   delete: [id: string]
 *   create: []
 * }>()
 * </script>
 * ```
 */
export interface InvoiceListProps {
  /** The list of invoices to display */
  invoices: Invoice[]
}

// =============================================================================
// Component Events (for use with defineEmits)
// =============================================================================

/**
 * Events emitted by InvoiceList.vue
 *
 * Usage:
 * ```vue
 * const emit = defineEmits<InvoiceListEmits>()
 * emit('view', invoice.id)
 * ```
 */
export interface InvoiceListEmits {
  /** Emitted when user wants to view an invoice's details */
  (e: 'view', id: string): void
  /** Emitted when user wants to edit an invoice */
  (e: 'edit', id: string): void
  /** Emitted when user wants to delete an invoice */
  (e: 'delete', id: string): void
  /** Emitted when user wants to archive an invoice */
  (e: 'archive', id: string): void
  /** Emitted when user wants to create a new invoice */
  (e: 'create'): void
}

// =============================================================================
// Prop Definitions (for runtime validation)
// =============================================================================

/**
 * Runtime prop definitions for use with defineProps()
 *
 * Usage:
 * ```vue
 * <script setup>
 * import { invoiceListPropDefs } from '@/../product/sections/invoices/types'
 * const props = defineProps(invoiceListPropDefs)
 * </script>
 * ```
 */
export const invoiceListPropDefs = {
  invoices: {
    type: Array as PropType<Invoice[]>,
    required: true
  }
} as const
```

### Vue Component Usage Pattern

Show how the types are used in a Vue component:

```vue
<script setup lang="ts">
import type { Invoice, InvoiceListEmits } from '@/../product/sections/invoices/types'

// Props with TypeScript
const props = defineProps<{
  invoices: Invoice[]
}>()

// Events with TypeScript
const emit = defineEmits<InvoiceListEmits>()

// Using emit
const handleView = (id: string) => {
  emit('view', id)
}

const handleCreate = () => {
  emit('create')
}
</script>

<template>
  <div>
    <button @click="handleCreate">Create Invoice</button>
    <div v-for="invoice in invoices" :key="invoice.id">
      <span>{{ invoice.clientName }}</span>
      <button @click="emit('view', invoice.id)">View</button>
      <button @click="emit('edit', invoice.id)">Edit</button>
      <button @click="emit('delete', invoice.id)">Delete</button>
    </div>
  </div>
</template>
```

### Naming Conventions

- Use PascalCase for interface names: `Invoice`, `LineItem`, `InvoiceListProps`
- Use camelCase for property names: `clientName`, `dueDate`, `lineItems`
- Props interface should be named `[ComponentName]Props` (e.g., `InvoiceListProps`)
- Emits interface should be named `[ComponentName]Emits` (e.g., `InvoiceListEmits`)
- Event names use kebab-case in templates but camelCase in TypeScript: `@start-tour` → `'startTour'`
- Add JSDoc comments for props and events to explain their purpose
- **Match entity names from the global data model if one exists**

## Step 7: Confirm and Next Steps

Let the user know:

"I've created two files for **[Section Title]**:

1. `product/sections/[section-id]/data.json` - Sample data with [X] records

2. `product/sections/[section-id]/types.ts` - TypeScript types for Vue components

The types include:

- `[Entity]` - The main data type
- `[SectionName]Props` - Props interface for use with `defineProps<>()`
- `[SectionName]Emits` - Events interface for use with `defineEmits<>()`

When you're ready, run `/design-screen` to create the Vue screen design for this section."

## Important Notes

- Generate realistic, believable sample data - not "Lorem ipsum" or "Test 123"
- Include 5-10 sample records for main entities (enough to show a realistic list)
- Include edge cases: empty arrays, long text, different statuses
- Keep field names clear and Vue/TypeScript-friendly (camelCase)
- The data structure should directly map to the spec's user flows
- Always generate types.ts alongside data.json
- Use Vue's `defineEmits` pattern instead of callback props
- Event names should be descriptive: `'view'`, `'edit'`, `'delete'`, `'startTour'`
- **Use entity names from the global data model for consistency across sections**
- **Follow Vue 3 Composition API patterns as defined in CLAUDE.md**
