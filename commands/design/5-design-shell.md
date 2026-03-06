# Design Shell

You are helping the user design the application shell — the persistent navigation and layout that wraps all sections. This is a screen design, not implementation code.

**Important:** This project uses Vue 3 with Composition API. All components must follow the patterns defined in `CLAUDE.md`.

## Step 1: Check Prerequisites

First, verify prerequisites exist:

1. Read `/product/product-overview.md` — Product name and description
2. Read `/product/product-roadmap.md` — Sections for navigation
3. Check if `/product/design-system/colors.json` and `/product/design-system/typography.json` exist
4. Read `CLAUDE.md` — Development guidelines and Vue patterns

If overview or roadmap are missing:

"Before designing the shell, you need to define your product and sections. Please run:
1. `/product-vision` — Define your product
2. `/product-roadmap` — Define your sections"

Stop here if overview or roadmap are missing.

If design tokens are missing, show a warning but continue:

"Note: Design tokens haven't been defined yet. I'll proceed with default styling, but you may want to run `/design-tokens` first for consistent colors and typography."

## Step 2: Invoke UX Designer Skill

Before analyzing the product structure and presenting navigation options, read the `ux-designer` skill to ground every navigation decision in user experience principles.

Read the file at `.claude/skills/ux-designer/SKILL.md`. When evaluating and presenting shell layout options, apply:
- **Navigation principles** — users must always know where they are, where they can go, and how to get back
- **Breadth over depth** — prefer wider, flatter navigation over deep nesting
- **Spatial memory** — consistent navigation placement across all pages builds user confidence
- **Information architecture** — present options that match users' mental models of the product

## Step 3: Analyze Product Structure

Review the roadmap sections and present navigation options:

"I'm designing the shell for **[Product Name]**. Based on your roadmap, you have [N] sections:

1. **[Section 1]** — [Description]
2. **[Section 2]** — [Description]
3. **[Section 3]** — [Description]

Let's decide on the shell layout. Common patterns:

**A. Sidebar Navigation** — Vertical nav on the left, content on the right
   Best for: Apps with many sections, dashboard-style tools, admin panels

**B. Top Navigation** — Horizontal nav at top, content below
   Best for: Simpler apps, marketing-style products, fewer sections

**C. Minimal Header** — Just logo + user menu, sections accessed differently
   Best for: Single-purpose tools, wizard-style flows

Which pattern fits **[Product Name]** best?"

Wait for their response.

## Step 4: Gather Design Details

Use AskUserQuestion to clarify:

- "Where should the user menu (avatar, logout) appear?"
- "Do you want the sidebar collapsible on mobile, or should it become a hamburger menu?"
- "Any additional items in the navigation? (Settings, Help, etc.)"
- "What should the 'home' or default view be when the app loads?"

## Step 5: Present Shell Specification

Once you understand their preferences:

"Here's the shell design for **[Product Name]**:

**Layout Pattern:** [Sidebar/Top Nav/Minimal]

**Navigation Structure:**
- [Nav Item 1] → [Section]
- [Nav Item 2] → [Section]
- [Nav Item 3] → [Section]
- [Additional items like Settings, Help]

**User Menu:**
- Location: [Top right / Bottom of sidebar]
- Contents: Avatar, user name, logout

**Responsive Behavior:**
- Desktop: [How it looks]
- Mobile: [How it adapts]

Does this match what you had in mind?"

Iterate until approved.

## Step 6: Create the Shell Specification

Create `/product/shell/spec.md`:

```markdown
# Application Shell Specification

## Overview
[Description of the shell design and its purpose]

## Navigation Structure
- [Nav Item 1] → [Section 1]
- [Nav Item 2] → [Section 2]
- [Nav Item 3] → [Section 3]
- [Any additional nav items]

## User Menu
[Description of user menu location and contents]

## Layout Pattern
[Description of the layout — sidebar, top nav, etc.]

## Responsive Behavior
- **Desktop:** [Behavior]
- **Tablet:** [Behavior]
- **Mobile:** [Behavior]

## Design Notes
[Any additional design decisions or notes]
```

## Step 7: Invoke UI Designer Skill

Before creating shell components, read the `ui-designer` skill to ensure the navigation chrome is visually polished and systematic.

Read the file at `.claude/skills/ui-designer/SKILL.md`. Apply these principles to the shell components:
- **Navigation sizing** — top nav 48–64px tall; sidebar 240–280px expanded, 64–72px collapsed
- **Active state** — immediately obvious via background + weight or color change
- **8pt grid** — all spacing values must be multiples of 8px
- **Icon consistency** — 20–24px with consistent stroke weight across the entire set
- **Dark mode** — use lighter surface colors for depth, not shadows; test at night in a dim room

## Step 8: Create Shell Components

Create the shell components at `src/components/shell/`:

### AppShell.vue
The main wrapper component that uses slots for content and provides the layout structure.

```vue
<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import MainNav from './MainNav.vue'
import UserMenu from './UserMenu.vue'

const props = defineProps({
  navigationItems: {
    type: Array, // Array<{ label: string; to: string; icon?: string }>
    required: true
  },
  user: {
    type: Object, // { name: string; avatarUrl?: string }
    default: null
  }
})

const emit = defineEmits(['logout'])

const router = useRouter()
const route = useRoute()

const navigate = (to) => {
  router.push(to)
}

const handleLogout = () => {
  emit('logout')
}
</script>

<template>
  <div class="app-shell">
    <MainNav
      :items="navigationItems"
      :current-path="route.path"
      @navigate="navigate"
    />
    <main class="main-content">
      <header class="main-header">
        <UserMenu
          v-if="user"
          :user="user"
          @logout="handleLogout"
        />
      </header>
      <div class="page-content">
        <slot />
      </div>
    </main>
  </div>
</template>

<style scoped>
/* Component styles here */
</style>
```

### MainNav.vue
The navigation component (sidebar or top nav based on the chosen pattern).

```vue
<script setup>
const props = defineProps({
  items: {
    type: Array,
    required: true
  },
  currentPath: {
    type: String,
    default: '/'
  }
})

const emit = defineEmits(['navigate'])

const isActive = (to) => props.currentPath === to
</script>

<template>
  <nav class="main-nav">
    <div class="nav-brand">
      <!-- Logo here -->
    </div>
    <ul class="nav-items">
      <li
        v-for="item in items"
        :key="item.to"
        :class="{ active: isActive(item.to) }"
      >
        <a @click.prevent="emit('navigate', item.to)">
          {{ item.label }}
        </a>
      </li>
    </ul>
  </nav>
</template>

<style scoped>
/* Navigation styles here */
</style>
```

### UserMenu.vue
The user menu with avatar and dropdown.

```vue
<script setup>
import { ref } from 'vue'

const props = defineProps({
  user: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['logout'])

const isOpen = ref(false)

const toggleMenu = () => {
  isOpen.value = !isOpen.value
}

const handleLogout = () => {
  isOpen.value = false
  emit('logout')
}
</script>

<template>
  <div class="user-menu">
    <button @click="toggleMenu" class="user-button">
      <img
        v-if="user.avatarUrl"
        :src="user.avatarUrl"
        :alt="user.name"
        class="avatar"
      />
      <span v-else class="avatar-placeholder">
        {{ user.name.charAt(0) }}
      </span>
      <span class="user-name">{{ user.name }}</span>
    </button>
    <div v-if="isOpen" class="dropdown">
      <button @click="handleLogout">Logout</button>
    </div>
  </div>
</template>

<style scoped>
/* User menu styles here */
</style>
```

### index.js
Export all components.

```javascript
export { default as AppShell } from './AppShell.vue'
export { default as MainNav } from './MainNav.vue'
export { default as UserMenu } from './UserMenu.vue'
```

**Component Requirements:**
- Use Vue 3 Composition API with `<script setup>`
- Use `defineProps` for props and `defineEmits` for events
- Use slots instead of children props
- Use Vue Router (`useRouter`, `useRoute`) for navigation
- Apply design tokens via CSS custom properties
- Support light and dark mode with CSS media queries
- Be mobile responsive
- Use scoped styles to prevent CSS leakage
- Use lucide-vue-next for icons (if needed)

## Step 9: Create Shell Preview

Create `src/views/ShellPreview.vue` — a preview wrapper for viewing the shell:

```vue
<script setup>
import { ref } from 'vue'
import { AppShell } from '@/components/shell'

const navigationItems = ref([
  { label: '[Section 1]', to: '/' },
  { label: '[Section 2]', to: '/section-2' },
  { label: '[Section 3]', to: '/section-3' },
])

const user = ref({
  name: 'Alex Morgan',
  avatarUrl: null,
})

const handleLogout = () => {
  console.log('Logout clicked')
}
</script>

<template>
  <AppShell
    :navigation-items="navigationItems"
    :user="user"
    @logout="handleLogout"
  >
    <div class="p-8">
      <h1 class="text-2xl font-bold mb-4">Content Area</h1>
      <p class="text-slate-600 dark:text-slate-400">
        Section content will render here.
      </p>
    </div>
  </AppShell>
</template>
```

## Step 10: Update Router Configuration

Ensure the router is configured to use the shell. Update `src/router/index.js`:

```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/HomeView.vue')
  },
  {
    path: '/builder',
    name: 'builder',
    component: () => import('@/views/TourBuilderView.vue')
  },
  {
    path: '/tour/:id',
    name: 'tour',
    component: () => import('@/views/TourExperienceView.vue')
  },
  {
    path: '/my-tours',
    name: 'my-tours',
    component: () => import('@/views/MyToursView.vue')
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
```

## Step 11: Apply Design Tokens

If design tokens exist, apply them to the shell components:

**Colors:**
- Read `/product/design-system/colors.json`
- Use primary color for active nav items, key accents
- Use secondary color for hover states, subtle highlights
- Use neutral color for backgrounds, borders, text

**Typography:**
- Read `/product/design-system/typography.json`
- Apply heading font to nav items and titles
- Apply body font to other text
- Include Google Fonts import in `index.html` or `style.css`

**Example CSS custom properties in `style.css`:**

```css
:root {
  /* Colors from design tokens */
  --color-primary: theme('colors.teal.500');
  --color-primary-hover: theme('colors.teal.600');
  --color-secondary: theme('colors.amber.500');
  --color-neutral-50: theme('colors.slate.50');
  --color-neutral-100: theme('colors.slate.100');
  --color-neutral-500: theme('colors.slate.500');
  --color-neutral-900: theme('colors.slate.900');

  /* Typography */
  --font-heading: 'DM Sans', system-ui, sans-serif;
  --font-body: 'DM Sans', system-ui, sans-serif;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-neutral-50: theme('colors.slate.900');
    --color-neutral-100: theme('colors.slate.800');
    --color-neutral-500: theme('colors.slate.400');
    --color-neutral-900: theme('colors.slate.50');
  }
}
```

## Step 12: Confirm Completion

Let the user know:

"I've designed the application shell for **[Product Name]**:

**Created files:**
- `/product/shell/spec.md` — Shell specification
- `src/components/shell/AppShell.vue` — Main shell wrapper
- `src/components/shell/MainNav.vue` — Navigation component
- `src/components/shell/UserMenu.vue` — User menu component
- `src/components/shell/index.js` — Component exports
- `src/views/ShellPreview.vue` — Preview wrapper (optional)

**Shell features:**
- [Layout pattern] layout
- Navigation for all [N] sections using Vue Router
- User menu with avatar and logout
- Mobile responsive design
- Light/dark mode support via CSS custom properties

**Important:** Restart your dev server to see the changes.

When you design section screens with `/design-screen`, they will render inside this shell, showing the full app experience.

Next: Run `/shape-section` to start designing your first section."

## Important Notes

- The shell uses Vue 3 Composition API with `<script setup>` syntax
- Components use slots for content injection (not children props)
- Navigation uses Vue Router (`useRouter`, `useRoute`)
- Events are emitted using `defineEmits`, not callback props
- All styles are scoped to prevent CSS leakage
- Design tokens are applied via CSS custom properties
- The preview wrapper is for development only — not part of the final export
- Keep the shell focused on navigation chrome — no authentication UI
- Section screen designs will render inside the shell's slot
