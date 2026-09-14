---
name: Clarity Notes & Tasks
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#434655'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#505f76'
  on-secondary: '#ffffff'
  secondary-container: '#d0e1fb'
  on-secondary-container: '#54647a'
  tertiary: '#632ecd'
  on-tertiary: '#ffffff'
  tertiary-container: '#7d4ce7'
  on-tertiary-container: '#f6edff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d3e4fe'
  secondary-fixed-dim: '#b7c8e1'
  on-secondary-fixed: '#0b1c30'
  on-secondary-fixed-variant: '#38485d'
  tertiary-fixed: '#e9ddff'
  tertiary-fixed-dim: '#d0bcff'
  on-tertiary-fixed: '#23005c'
  on-tertiary-fixed-variant: '#5516be'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 24px
  title-sm:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The design system embodies a focused, systematic, and calming mobile productivity environment. Designed specifically for note capture, task scheduling, and thought organization, the aesthetic merges Modern Corporate precision with tactile digital minimalism. 

The emotional signature is clarity, calm efficiency, and quiet competence: users should feel that their thoughts are structured, their agenda is manageable, and their cognitive load is visibly reduced the moment they launch the application.

Visual traits:
- Generous, clean whitespace resting over cool, low-strain neutral canvases.
- Restrained, intentional pops of functional color that classify rather than distract.
- Tactile clarity: crisp, hairline container outlines paired with subtle diffused ambient elevations to ground interactive cards against canvas layers.
- Confident, modern typography optimized for handheld screens and rapid scanning.

## Colors
The color architecture relies on a crisp functional hierarchy designed for prolonged readability and rapid scanning on OLED and LCD mobile screens.

### Core Roles
- **Primary (`#2563EB`)**: The central action anchor used for primary CTAs, active tab indicators, selected radio/checkbox fills, and interactive focal points. Deep variant `#1D4ED8` handles active/pressed states.
- **Primary Container / Tint (`#EFF6FF`)**: Subtle, low-chroma blue wash used for selected list tiles, active filter badge backgrounds, and contextual highlight blocks.
- **Secondary / Muted (`#64748B`)**: Slate-500 for secondary body copy, timestamps, supporting meta-labels, unfocused icons, and trailing chevron indicators.
- **Neutral Deep (`#0F172A`)**: Slate-900 high-contrast ink for main headings, note titles, and primary reading text. Never use pure black (`#000000`).
- **Surface & Canvas**:
  - Main Background Canvas: `#F8FAFC` (Slate-50) creates subtle separation from phone bezels.
  - Surface Cards & Modals: `#FFFFFF` (Pure White) provides clean contrast against the slate canvas.
  - Hairline Borders: `#E2E8F0` (Slate-200) defines distinct card boundaries without visual clutter.

### Semantic Category Palette
Applied strictly to category tags, pill indicators, and folder badges:
- **Work / Travail**: Violet `#8B5CF6` on `#EDE9FE` tint.
- **Personal / Personnel**: Emerald `#10B981` on `#D1FAE5` tint.
- **Study / Études**: Amber `#F59E0B` on `#FEF3C7` tint.
- **Ideas / Idées**: Sky `#0284C7` on `#E0F2FE` tint.

### Feedback & Alerts
- **Error / Urgent**: Coral Red `#EF4444` on light crimson wash `#FEF2F2` with `#FCA5A5` border for non-intrusive floating banners and destructive actions.
- **Success / Completed**: `#10B981` on `#ECFDF5` for task completion markers and snackbar confirmations.

## Typography
The system uses **Inter** throughout, delivering geometric balance and tall x-heights suited for scanning lists and drafting long-form notes on mobile devices.

### Hierarchy Guidelines
- **`headline-lg` / `headline-md`**: Page titles, folder directory headers, and top app bar greetings. Always set to bold/semi-bold in `#0F172A`.
- **`title-md` / `title-sm`**: Note titles in feed views, modal card titles, and section headers.
- **`body-lg` / `body-md`**: Note editing content, full body text in expanded preview cards, and bottom sheet instructions.
- **`body-sm`**: Note metadata snippets, secondary preview strings, and timestamp indicators (`#64748B`).
- **`label-lg`**: Primary action buttons, FAB labels, and text-button actions.
- **`label-md` / `label-sm`**: Category pill badges, status tags, badge counts, and input field label overlines. Letter-spacing should be tightened slightly (-0.01em) for sizes 16px and above, and relaxed (+0.02em) for `label-sm` to maintain legibility.

## Layout & Spacing
The layout follows a responsive 4-column fluid mobile grid expanding to 8 columns on foldables and tablets, grounded by a strict 4pt/8pt layout rhythm.

### Grid & Canvas Structure
- **Outer Canvas Margins**: Mobile phones use `1.25rem` (20px) horizontal safe margins to prevent thumb cutoff along screen curves. Tablets use `2rem` (32px).
- **Column Gutter**: Fixed at `1rem` (16px) for side-by-side note grids (masonry or two-column boards).
- **Vertical Rhythm**:
  - App bar to content: `1.5rem` (24px).
  - Inter-card list stack: `0.75rem` (12px) for high density; `1rem` (16px) for standard view.
  - Category horizontal rail spacing: `0.5rem` (8px) between chips.

### Form Factors & Adaptation
- **Compact Handheld (< 600dp)**: Single column stacked list or staggered 2-column masonry grid for note cards. Bottom Navigation Bar anchored with center-docked or trailing FAB.
- **Medium & Tablet (600dp - 840dp)**: 2 to 3 column card grid with fixed 280dp left-hand folder navigation rail replacing the bottom bar.

## Elevation & Depth
Depth in this design system is conveyed through combined hairline geometry and tinted ambient diffusion, avoiding harsh drop shadows in favor of a crisp layered tactile feel.

### Elevation Levels
- **Level 0 (Canvas Surface)**: `#F8FAFC`. Completely flat without shadows. Contains search bars, background canvas, and disabled containers.
- **Level 1 (Cards, Unselected Pills, Form Containers)**: 
  - Fill: `#FFFFFF`
  - Border: 1px solid `#E2E8F0`
  - Shadow: `0 1px 3px 0 rgba(15, 23, 42, 0.05), 0 1px 2px -1px rgba(15, 23, 42, 0.03)`
- **Level 2 (Active Cards, Modals, Bottom Sheets)**:
  - Fill: `#FFFFFF`
  - Border: 1px solid `#E2E8F0`
  - Shadow: `0 4px 6px -1px rgba(15, 23, 42, 0.07), 0 2px 4px -2px rgba(15, 23, 42, 0.05)`
- **Level 3 (Floating Action Button & Alert Banners)**:
  - Primary FAB: Fill `#2563EB`, Shadow `0 10px 15px -3px rgba(37, 99, 235, 0.35), 0 4px 6px -4px rgba(37, 99, 235, 0.20)`
  - Alert Banners: Fill `#FEF2F2`, Border 1px solid `#FCA5A5`, Shadow `0 10px 15px -3px rgba(15, 23, 42, 0.08)`

## Shapes
The design system adopts a balanced **Rounded** (`2`) shape philosophy, delivering tactile, friendly geometry while preserving high content density.

### Radius Assignments
- **Input Fields & Text Areas**: `rounded-xl` (0.75rem / 12px to 1rem / 16px) creates smooth touch targets that guide the thumb.
- **Note Cards & Modal Surfaces**: `rounded-xl` (1rem / 16px) for card corners.
- **Category Filter Chips & Status Badges**: Fully pill-shaped (`rounded-full` / 9999px) to distinctly contrast against rectangular note cards.
- **Primary Buttons & FAB**: Primary buttons use `rounded-xl` (12px); Floating Action Buttons use either `rounded-2xl` (16px) for an modern squircle or `rounded-full` (28px).
- **Checkboxes**: `rounded-md` (6px) for soft, modern check toggles.

## Components

### Buttons
- **Primary Button**: Height 48px, background `#2563EB`, text `#FFFFFF` (`label-lg`), radius 12px. Pressed state darkens to `#1D4ED8`. Subtle blue glow shadow (`rgba(37, 99, 235, 0.25)`).
- **Secondary / Tinted Button**: Height 48px, background `#EFF6FF`, text `#2563EB`, radius 12px, border none. Pressed state `#DBEAFE`.
- **Ghost / Icon Button**: 40x40px touch bounding box, transparent background, `#64748B` icon color, ripple effect mapped to `#F1F5F9`.

### Note & Task Cards
- **Structure**: `#FFFFFF` background, 1px border `#E2E8F0`, radius 16px, Level 1 shadow.
- **Content Spacing**: Internal padding `1rem` (16px).
- **Header**: Contains title (`title-sm`, `#0F172A`) and pinned icon or category tag.
- **Body**: Max 3 lines preview (`body-sm`, `#64748B`).
- **Footer**: Timestamp on leading edge (`label-sm`, `#94A3B8`), task completion fraction badge or checklist pill on trailing edge.

### Category Chips & Filter Pills
- **Unselected**: Surface `#FFFFFF`, border 1px solid `#E2E8F0`, text `#64748B`, height 32px, padding horizontal 12px, fully rounded.
- **Selected**: Surface `#EFF6FF`, border 1px solid `#2563EB`, text `#2563EB`, font weight 600.
- **Category-specific Tag Variant**: Fixed tint backgrounds with saturated foreground text (e.g., Travail = `#EDE9FE` background with `#8B5CF6` text and an optional leading 6px dot).

### Input Fields & Search Bar
- **Search Bar**: Height 44px, background `#F1F5F9`, border none, icon leading `#64748B`, placeholder "Rechercher notes, tâches...", radius 12px.
- **Form Text Field**: Background `#FFFFFF`, border 1px solid `#CBD5E1`, text `#0F172A`, placeholder `#94A3B8`, radius 12px, vertical padding 12px, horizontal padding 16px.
- **Focused State**: Border `#2563EB` with an outer 3px focus ring `rgba(37, 99, 235, 0.15)`.

### Checkboxes & Task List Items
- **Checkbox**: 20x20px, radius 6px, unselected 1.5px solid `#CBD5E1`. Selected: fill `#2563EB`, border `#2563EB`, white checkmark icon.
- **Completed Item**: Text strikes through with font color shifting to `#94A3B8`.

### Floating Action Button (FAB)
- 56x56px circular or squircle container docked 20px above bottom bar.
- Background `#2563EB`, icon 24px pure white `+`. Elevation Level 3.

### Floating Alert Banners
- Anchored 16px below top app bar with safe area inset.
- Fill `#FEF2F2`, border 1px solid `#FCA5A5`, radius 12px, Level 3 shadow.
- Text `#991B1B` with leading `#EF4444` exclamation icon and trailing dismiss icon.