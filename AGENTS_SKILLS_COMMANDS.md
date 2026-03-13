# Claude Code Configuration: Agents, Skills & Commands

This guide explains all available agents, skills, and commands in this Claude Code configuration. Use this as a reference to understand when to invoke each agent and what resources are available.

---

## 🤖 Agents

Agents are specialized autonomous workers that handle complex, multi-step tasks using a structured command pipeline.

### **vuejs-feature-builder**
**Purpose:** Build scalable, maintainable Vue.js features with a structured pipeline.

**Use when:**
- Adding large, complex authentication systems
- Creating new reusable components with multiple dependent pieces
- Building features that require UX design, state management, and testing
- Making significant architectural changes to a Vue.js app

**Pipeline:** BRANCH → VISION → SPEC → DESIGN → IMPLEMENT → TEST → REVIEW → VALIDATE → COMMIT

**Expertise:**
- Vue 3 Composition API, TypeScript, Pinia, Vue Router
- Atomic Design (atoms → molecules → organisms → templates → pages)
- Component-driven architecture, code splitting
- E2E testing with Cypress, unit tests with Vitest

**Key Features:**
- Generates component specs with atomic levels and rationale
- Ensures Atomic Design principles are followed
- Updates product vision and roadmap automatically
- Keeps spec files synchronized with implementation
- Runs E2E tests before validation

**Entry Points:**
- **LARGE:** Full pipeline (VISION through COMMIT)
- **MEDIUM:** Start at SPEC (skip VISION for well-scoped features)
- **SMALL:** Start at DESIGN (minor UI changes, props)
- **BUGFIX:** Start at IMPLEMENT (skip VISION)

---

### **lambda-feature-builder**
**Purpose:** Build scalable, maintainable AWS Lambda serverless functions with complete AWS integration.

**Use when:**
- Creating complex payment processing workflows
- Adding Lambda functions triggered by API Gateway, S3, DynamoDB Streams, etc.
- Building multi-Lambda systems with queues and state management
- Setting up API Gateway integrations

**Pipeline:** BRANCH → VISION → SPEC → DESIGN → IMPLEMENT → TEST → REVIEW → PACKAGE → VALIDATE → COMMIT

**Expertise:**
- AWS Lambda, API Gateway, DynamoDB, SQS, SNS, S3, CloudWatch
- Node.js/TypeScript, AWS SDK v3, Infrastructure as Code (Terraform/CloudFormation/SAM)
- Serverless architecture, event-driven design
- Lambda optimization (cold starts, memory allocation, layers)
- API Gateway configuration and integration

**Key Features:**
- Generates Lambda test JSONs for AWS Lambda console
- Creates per-method API Gateway request models (with project name prefix)
- Generates per-method API Gateway test objects for Method Test
- Creates OpenAPI 3.0 specifications for new APIs
- Generates API Gateway setup TODO files for existing APIs
- Bundles and zips Lambda functions for production
- Creates IAM policies per Lambda with minimal permissions
- Generates Postman collections for API testing
- Configures CORS, Lambda Proxy Integration, and body passthrough settings

**Entry Points:**
- **LARGE:** Full pipeline (VISION through COMMIT)
- **MEDIUM:** Start at SPEC (new function with standard integrations)
- **SMALL:** Start at DESIGN (utility function, minor changes)
- **BUGFIX:** Start at IMPLEMENT (specific Lambda issues)

**Naming Conventions:**
- Lambda functions: `<project-name>-<handler-name>` (e.g., `myapp-process-payment`)
- All AWS resources tagged with project name
- All API files prefixed with project name (e.g., `myapp-api.openapi.json`)

---

### **dynamodb-feature-builder**
**Purpose:** Design and implement DynamoDB schemas around access patterns with optimal performance.

**Use when:**
- Designing complete data models for multi-tenant SaaS applications
- Optimizing slow DynamoDB queries with better indexes
- Performing schema migrations
- Adding complex Global or Local Secondary Indexes
- Redesigning data models for hot partition optimization

**Pipeline:** BRANCH → VISION → SPEC → DESIGN → IMPLEMENT → TEST → REVIEW → PACKAGE → VALIDATE → COMMIT

**Expertise:**
- DynamoDB, NoSQL data modeling, access patterns
- Global Secondary Indexes (GSIs), Local Secondary Indexes (LSIs)
- Partition key design and hot partition prevention
- DynamoDB Streams, point-in-time recovery, capacity planning
- Terraform/CloudFormation/SAM for infrastructure

**Key Features:**
- Designs schema around access patterns (not entities)
- Generates access pattern validation tests
- Creates IAM policies per table with minimal DynamoDB permissions
- Generates comprehensive deployment TODO with table setup instructions
- Validates partition key distribution prevents hot partitions
- Plans migrations with zero-downtime execution
- Includes capacity planning (RCU/WCU) and cost estimation

**Entry Points:**
- **LARGE:** Full pipeline (VISION through COMMIT)
- **MEDIUM:** Start at SPEC (new table with multiple indexes)
- **SMALL:** Start at DESIGN (add GSI, add attribute, TTL change)
- **BUGFIX/OPTIMIZATION:** Start at DESIGN (fix inefficiency, rebalance)

**Naming Conventions:**
- Table names: `<project-name>-<table-name>` (e.g., `myapp-users`)
- All tables tagged with project name

---

### **vuejs-project-scaffolder**
**Purpose:** Quickly bootstrap a new Vue.js project with selected plugins and Claude Code configuration.

**Use when:**
- Starting a completely new Vue.js application
- Setting up a Vue.js project with specific plugins (Pinia, Vue Router, Tailwind CSS, Vitest)
- Initializing Claude Code integration for AI-assisted development
- Creating a new monorepo entry point

**Key Features:**
- Uses latest Vue.js version
- Configures selected plugins automatically
- Sets up Claude Code integration (CLAUDE.md)
- Installs dependencies
- Creates project structure with proper conventions

**Use Cases:**
- `"Create a new Vue.js project with TypeScript, Pinia, Vue Router, and Vitest"`
- `"Set up a new Vue 3 app for me with Tailwind CSS, Pinia, and Vue Router"`

---

### **backlog-manager**
**Purpose:** Manage product feature backlog and hand off items to feature builders for development.

**Use when:**
- Viewing and organizing the product feature backlog
- Adding new feature ideas or requirements
- Prioritizing features for development
- Kicking off development of a backlog item

**Key Features:**
- Interactively browse backlog items
- Add new feature ideas (confirms details before saving)
- Reorder and prioritize items
- Hand off to vuejs-feature-builder, lambda-feature-builder, or dynamodb-feature-builder
- Confirms all changes with user before writing

**Use Cases:**
- `"Show me the backlog and let me pick what to build next"`
- `"Add 'offline support' to the backlog"`
- `"Let's build the WhatsApp reminder feature"`

---

## 💡 Skills

Skills provide domain-specific knowledge and reference documentation that agents can consult. They activate automatically when relevant.

### **ui-designer**
**Purpose:** Expert visual design, UI systems, component libraries, and pixel-perfect implementation.

**When it activates:**
- Building, styling, or polishing any interface (websites, apps, dashboards, component libraries)
- Questions about CSS styling, component design, layout, spacing, typography, colors
- Dark mode, responsive design, design tokens, design systems
- Phrases: "make it look good", "improve the design", "it looks off", "pixel perfect"

**What it provides:**
- Visual hierarchy principles
- Component design patterns
- Design system documentation
- Color palette theory
- Typography guidelines
- Icon and spacing conventions
- Shadow and border-radius best practices
- Animation and transition patterns

**References in skill:**
- component-library.md — Reusable component patterns
- design-tokens.md — Design token system
- polish-and-craft.md — Visual refinement techniques

---

### **ux-designer**
**Purpose:** Expert UX design thinking, user psychology, and experience strategy.

**When it activates:**
- Building or reviewing any user-facing interface
- Questions about user flows, wireframes, prototypes, usability
- Information architecture, content strategy, error handling
- Accessibility, interaction design, user testing, conversion optimization
- Phrases: "how should this flow", "user experience", "make it easier", "onboarding", "friction"

**What it provides:**
- User journey mapping
- Interaction patterns and best practices
- Error handling and recovery UX
- Accessibility guidelines
- Conversion optimization strategies
- User testing approaches
- Information architecture principles

**References in skill:**
- patterns-and-flows.md — Common UX patterns and user flows
- psychology-deep-dive.md — User psychology and decision-making

---

### **agent-customization** (Copilot Skill)
**Purpose:** Create, update, review, and debug Claude Code agent and skill customization files.

**When to use:**
- Saving coding preferences and custom instructions
- Troubleshooting why instructions/skills aren't working
- Configuring agent activation patterns
- Creating custom agent modes or specialized workflows
- Defining tool restrictions and capabilities

**What it helps with:**
- .instructions.md files (Claude Code instructions)
- .prompt.md files (system prompts for agents)
- .agent.md files (agent definitions)
- SKILL.md files (skill definitions)
- copilot-instructions.md (Copilot-specific instructions)
- AGENTS.md (agent registry)
- YAML frontmatter syntax in configuration files

---

## 🎯 Commands

Commands are slash-inspired workflows that guide you through multi-step processes interactively.

### **Vision Commands** (`/Vision/`)

#### **/product-vision** (1-product-vision.md)
**Purpose:** Create or update the product overview and feature list.

**Creates/Updates:**
- `product/product-overview.md` — High-level product description, target users, core features

**Use in:** VISION stage of any feature-builder agent

**Generates:**
- Product overview with feature list
- User personas and pain points
- Core value propositions

---

#### **/product-roadmap** (2-product-roadmap.md)
**Purpose:** Create or update the product roadmap with features and timeline.

**Creates/Updates:**
- `product/product-roadmap.md` — Feature roadmap with timeline and dependencies

**Use in:** VISION stage of any feature-builder agent

**Generates:**
- Roadmap sections per feature
- Release timelines
- Dependency mapping
- Priority indicators

---

### **Design Commands** (`/design/`)

#### **/shape-section** (s1-shape-section.md)
**Purpose:** Collaboratively define user flows, requirements, and feature scope.

**Creates/Updates:**
- Scope definition and user story details
- UI flow diagrams
- Acceptance criteria refinement

**Use in:** SPEC stage of feature-builders

**Guides you through:**
- User workflow definition
- Edge case identification
- Acceptance criteria refinement
- Scope boundaries

---

#### **/sample-data** (s2-sample-data.md)
**Purpose:** Generate realistic sample data and TypeScript types from specifications.

**Creates:**
- Sample data sets for development/testing
- TypeScript type definitions matching the data
- Seed data scripts

**Use in:** DESIGN stage of feature-builders

**Generates:**
- Realistic mock data
- TypeScript interfaces
- Seed data for development databases

---

#### **/design-screen** (s3-design-screen.md)
**Purpose:** Create visual prototypes with Atomic Design classification.

**Creates:**
- Visual mockups/prototypes
- Component hierarchy diagrams
- Atomic Design level assignments (`[ATOM]`, `[MOLECULE]`, `[ORGANISM]`)

**Use in:** DESIGN stage of Vue.js feature-builder

**Produces:**
- Visual wireframes or high-fidelity mockups
- Component breakdown by atomic level
- Reuse recommendations (existing components)

---

#### **/screenshot-design** (s4-screenshot-design.md)
**Purpose:** Create detailed screenshot mockups with annotations.

**Creates:**
- Annotated design screenshots
- Layout specifications
- Interaction notes

**Use in:** DESIGN stage when visual refinement is needed

---

#### **/data-model** (3-data-model.md)
**Purpose:** Define core entities, relationships, attributes, and DynamoDB access patterns.

**Creates/Updates:**
- Entity-Relationship (ER) diagrams
- Data structure definitions
- Access pattern specifications (for DynamoDB)
- TypeScript type definitions

**Use in:** VISION or SPEC stage when introducing new domain concepts

**Defines:**
- Entity types and attributes
- Relationships between entities
- DynamoDB partition/sort keys (for serverless)
- Access patterns and queries
- Data constraints and validation

---

#### **/design-tokens** (4-design-tokens.md)
**Purpose:** Establish the color palette, typography, and design system tokens.

**Creates:**
- `tokens/colors.json` — Color palette
- `tokens/typography.json` — Font scales and sizes
- `tokens/spacing.json` — Spacing scale
- Design token documentation

**Use in:** DESIGN stage when setting up a new design system

**Produces:**
- Complete design token system
- CSS custom properties (or SCSS variables)
- Design token reference guide

---

#### **/design-shell** (5-design-shell.md)
**Purpose:** Design the app shell, layout structure, and navigation.

**Creates:**
- App shell layout (header, sidebar, footer, main area)
- Navigation structure
- Shared component specifications

**Use in:** DESIGN stage when designing the overall app container

**Defines:**
- Layout grid and hierarchy
- Navigation patterns
- Shell component contracts
- Responsive behavior

---

## 📋 Workflow Summary

### Typical Feature Development Flow

```
PLAN & ORGANIZE
↓
backlog-manager — Manage features
   ↓
   Choose feature → Hand off to feature-builder
   
BUILD FEATURE
↓
[Feature Builder] — Appropriate agent (Vue.js, Lambda, DynamoDB)
   BRANCH — Create feature branch
   VISION → Create product overview & roadmap
   SPEC → Define detailed requirements
   DESIGN → Create architecture/prototypes
      ├─ /shape-section — Define flows
      ├─ /sample-data — Create test data
      ├─ /design-tokens (if new design system)
      ├─ /design-shell (if app shell)
      └─ /design-screen — Create mockups
   IMPLEMENT → Write code
   TEST → Validate functionality
   REVIEW → Quality assurance
   PACKAGE → Generate deployment artifacts
   VALIDATE → User acceptance testing
   COMMIT → Push to repository
```

### Quick Command Reference

| Need | Agent | Command |
|------|-------|---------|
| New Vue feature | vuejs-feature-builder | — |
| New Lambda function | lambda-feature-builder | — |
| New DynamoDB schema | dynamodb-feature-builder | — |
| New Vue project | vuejs-project-scaffolder | — |
| Manage backlog | backlog-manager | — |
| Document product | — | /product-vision, /product-roadmap |
| Define flows | — | /shape-section |
| Create mockups | — | /design-screen |
| Design database | — | /data-model |
| Create design tokens | — | /design-tokens |
| Design app shell | — | /design-shell |
| Generate sample data | — | /sample-data |

---

## 🎓 Best Practices

### When to Use Each Agent

- **vuejs-feature-builder**: Frontend features, UI components, user workflows
- **lambda-feature-builder**: Backend APIs, event processing, integrations
- **dynamodb-feature-builder**: Data models, schemas, access patterns
- **backlog-manager**: Feature prioritization and workflow organization

### Naming Conventions Enforced by Agents

- **Vue components**: PascalCase (e.g., `UserProfile.vue`)
- **Composables**: `use` prefix (e.g., `useAuthentication.ts`)
- **Lambda functions**: `<project-name>-<handler-name>` (e.g., `myapp-process-payment`)
- **DynamoDB tables**: `<project-name>-<table-name>` (e.g., `myapp-users`)
- **API files**: `<project-name>-api.*` (e.g., `myapp-api.openapi.json`)

### Key Principles

1. **Spec Synchronization**: All agents keep specification files updated with implementation
2. **Branch-First**: Always create feature branch before any code changes
3. **Vision-First**: Always update product docs before implementation (except bugfixes)
4. **Quality Gates**: Each agent has mandatory validation checklist before completion
5. **Atomic Design**: Vue features follow Atomic Design (atom → molecule → organism → template → page)
6. **Access Patterns First**: DynamoDB schema designed around queries, not entities
7. **Least-Privilege**: All IAM policies grant only necessary permissions

---

## 🚀 Getting Started

1. **Clone** this repo: `git clone https://github.com/billmiddelbosch/claude-config.git`
2. **Install** using provide script (install.sh on macOS/Linux, install.ps1 on Windows)
3. **Choose an agent** based on your task
4. **Tell Claude Code** what you need, e.g.:
   - `"Create a new Vue.js project with Tailwind CSS and Pinia"`
   - `"Build a payment processing Lambda that stores data in DynamoDB"`
   - `"Design a DynamoDB schema for an e-commerce application"`
5. **Claude Code** will guide you through the structured pipeline

---

## 📚 Additional Resources

- **README.md** — Project overview and installation instructions
- Each **agent file** contains complete instructions and best practices
- Each **skill file** contains reference documentation and examples
- Each **command file** provides interactive guidance for specific tasks

---

**Last Updated:** March 13, 2026
