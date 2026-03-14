# Feature Specification: Clay UI Design System Redesign

**Feature Branch**: `006-clay-ui-redesign`
**Created**: 2026-03-12
**Status**: Draft
**Input**: User description: "Redesign the app design to be a complete Flutter Clay UI kit following instructions from FlutterClayUI.md"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Core Design Tokens & Theme Foundation (Priority: P1)

A user opens the app and sees a completely refreshed visual identity: soft lavender canvas background (#F4F1FA), violet accent colors, Nunito headings, DM Sans body text, and rounded clay-style elements throughout. The overall feel is soft, volumetric, and tactile — like interacting with premium digital clay.

**Why this priority**: Every screen depends on the centralized design tokens (colors, typography, spacing, shadows, radii). Without this foundation, no other UI work can proceed consistently.

**Independent Test**: Can be tested by launching the app and verifying the canvas color, font rendering, and basic theme appearance on the home screen without any other feature work.

**Acceptance Scenarios**:

1. **Given** the app launches, **When** any screen renders, **Then** the background canvas is #F4F1FA with animated floating blurred blobs in accent colors
2. **Given** any screen with text, **When** headings render, **Then** they use Nunito (weight 700–900) and body text uses DM Sans (weight 400–700)
3. **Given** any interactive element, **When** the user views a card or button, **Then** it displays multi-layered clay shadows (outer shadow, highlight shadow, inner reflection, inner rim light)
4. **Given** any card element, **When** rendered, **Then** it uses rounded corners of 32px with soft floating shadows
5. **Given** the app is in Arabic mode, **When** Arabic text renders, **Then** it uses Amiri font (preserving existing Arabic typography system)

---

### User Story 2 - Clay Card & Button Components (Priority: P1)

A user interacts with cards and buttons throughout the app. Cards feel like they float above the surface with volumetric depth. Buttons have gradient backgrounds with a convex clay appearance. Pressing a button produces a satisfying squish animation, and cards respond to taps with subtle lift effects.

**Why this priority**: Cards and buttons are the two most-used components across all screens. They form the building blocks for every feature screen.

**Independent Test**: Can be tested by creating a component showcase screen that displays all card and button variants with their interaction states.

**Acceptance Scenarios**:

1. **Given** a clay card, **When** displayed, **Then** it has large rounded radius (32px), floating shadow layers, internal padding, and optional glass effect
2. **Given** a primary button, **When** displayed, **Then** it shows a gradient from light violet to primary violet (#7C3AED) with a convex shadow
3. **Given** a button, **When** pressed, **Then** it plays a squish/compress animation
4. **Given** a button, **When** released after press, **Then** it returns to its original convex state smoothly
5. **Given** secondary, outline, and ghost button variants, **When** displayed, **Then** each has its distinct clay styling per the design system

---

### User Story 3 - Home Screen Redesign (Priority: P2)

A user opens the home screen and sees a modern clay UI dashboard with a bento-style layout. The next prayer countdown, daily inspiration card, and quick-access feature tiles are rendered as clay cards with varied sizes and colorful icon containers using pastel-to-saturated gradients.

**Why this priority**: The home screen is the first thing users see and sets the visual tone for the entire app experience.

**Independent Test**: Can be tested by navigating to the home screen and verifying the layout, card styles, typography, background blobs, and interaction animations.

**Acceptance Scenarios**:

1. **Given** the home screen, **When** displayed, **Then** it uses a bento/varied grid layout (not uniform cards)
2. **Given** feature quick-access tiles, **When** displayed, **Then** icon containers use pastel-to-saturated gradient backgrounds
3. **Given** the next prayer countdown, **When** displayed, **Then** it is presented in a prominent clay card with hero-level typography
4. **Given** floating background blobs, **When** displayed, **Then** they animate with slow drift motion behind the content
5. **Given** any card on home, **When** tapped, **Then** it shows a subtle lift animation before navigating

---

### User Story 4 - Navigation Bar Redesign (Priority: P2)

A user sees a redesigned bottom navigation bar that follows the clay aesthetic — soft rounded shape, clay shadow beneath it, violet-accented selected state, and smooth transition animations between tabs.

**Why this priority**: The navigation bar is visible on every screen and is critical to the cohesive feel of the redesign.

**Independent Test**: Can be tested by switching between all 6 tabs and verifying visual styling, active/inactive states, and transition smoothness.

**Acceptance Scenarios**:

1. **Given** the bottom navigation bar, **When** displayed, **Then** it has rounded top corners, clay shadow, and a soft surface appearance
2. **Given** a selected tab, **When** active, **Then** it uses the primary accent color (#7C3AED) with a filled icon variant
3. **Given** tab switching, **When** the user taps a new tab, **Then** the transition includes a smooth animation

---

### User Story 5 - Prayer Times Screen Redesign (Priority: P2)

A user views prayer times in a redesigned clay layout. Each prayer time is displayed in its own clay card with clear visual hierarchy: the next upcoming prayer is prominently highlighted with a gradient accent, past prayers are softly muted, and future prayers are standard.

**Why this priority**: Prayer times is one of the most frequently used features in an Islamic app.

**Independent Test**: Can be tested by navigating to the prayer times tab and verifying card styles, prayer status colors, countdown display, and overall layout.

**Acceptance Scenarios**:

1. **Given** prayer times screen, **When** displayed, **Then** each prayer time appears in an individual clay card with proper shadow layers
2. **Given** the next upcoming prayer, **When** displayed, **Then** it is visually emphasized with a gradient accent border or background
3. **Given** past prayers, **When** displayed, **Then** they appear in a muted/softer clay card style
4. **Given** the countdown timer, **When** displayed, **Then** it uses hero-level typography (bold, large) in a prominent position

---

### User Story 6 - Quran Reader & Athkar Screens Redesign (Priority: P3)

A user browses Quran surahs and reads athkar in a redesigned clay interface. Surah cards in the index use varied layouts. The Quran reader maintains excellent readability with Arabic typography while incorporating clay-styled controls. Athkar category cards use distinct pastel-to-saturated gradient icon containers.

**Why this priority**: These are content-heavy screens where readability must be preserved alongside the new aesthetic.

**Independent Test**: Can be tested by browsing the surah index, opening a surah, and browsing athkar categories independently.

**Acceptance Scenarios**:

1. **Given** surah index, **When** displayed, **Then** each surah is presented in a clay card with rounded corners and proper shadow
2. **Given** athkar categories, **When** displayed, **Then** each category card has a distinct gradient icon container
3. **Given** the Quran reader, **When** reading verses, **Then** Arabic text remains highly readable with Amiri font and generous line height
4. **Given** the athkar detail screen, **When** displayed, **Then** the counter and progress elements use clay-styled interactive components

---

### User Story 7 - Tasbih Counter & Settings Redesign (Priority: P3)

A user uses the tasbih counter with a large clay-styled counter button that compresses on press and springs back. The settings screen uses clay cards for each settings group with recessed clay-styled input fields and toggles.

**Why this priority**: These screens complete the full app redesign but have lower usage frequency.

**Independent Test**: Can be tested by opening the tasbih screen and tapping the counter, and by navigating to settings and toggling options.

**Acceptance Scenarios**:

1. **Given** the tasbih counter button, **When** pressed, **Then** it shows a press/squish animation with an inset shadow
2. **Given** the tasbih counter button, **When** released, **Then** it springs back to its convex clay state
3. **Given** settings groups, **When** displayed, **Then** each group is wrapped in a clay card
4. **Given** toggle switches, **When** displayed, **Then** they use the violet accent color and clay-styled track

---

### User Story 8 - Animation & Motion System (Priority: P3)

A user experiences consistent, delightful micro-animations throughout the app: floating background blobs, breathing decorative elements, hover lift on interactive cards, and press animations on buttons. Users who prefer reduced motion see a simplified experience.

**Why this priority**: Animations enhance polish but are not blocking for visual correctness.

**Independent Test**: Can be tested by navigating through all screens and observing animations, then enabling reduced motion in device settings and verifying animations are suppressed.

**Acceptance Scenarios**:

1. **Given** background blobs, **When** displayed, **Then** they animate with slow vertical drifting and subtle rotation
2. **Given** decorative elements, **When** displayed, **Then** they use a subtle breathing (scale) animation
3. **Given** device reduced motion setting is ON, **When** the app renders, **Then** all animations are disabled or minimized
4. **Given** interactive cards, **When** tapped, **Then** they show a brief lift animation before action

---

### Edge Cases

- What happens when the device uses a very small screen (< 320px width)? Radii and padding scale down proportionally to avoid cramped layouts.
- How does the clay shadow system perform on low-end devices? Shadow layers are reduced (fewer box shadows) for devices below a performance threshold or when battery saver is on.
- What happens when the user switches to dark mode? The app falls back to a basic dark surface until the clay dark theme is implemented in a follow-up feature.
- How do overlapping decorative elements behave with screen readers? Decorative blobs and animations are excluded from the accessibility tree.
- What happens when Arabic RTL layout is active? All layouts mirror correctly; clay shadows adjust light direction for RTL (top-right light source).

## Clarifications

### Session 2026-03-12

- Q: Should dark mode clay theme be included in this redesign or deferred? → A: Deferred to a follow-up feature. This redesign targets light clay theme only.
- Q: Should utility widgets (loading, error, empty states) be restyled with clay aesthetic? → A: Yes, restyle all utility widgets to maintain visual consistency across all screen states.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST replace the current Material green theme with Clay UI design tokens: canvas #F4F1FA, primary accent #7C3AED, secondary accent #DB2777, tertiary accent #0EA5E9, text colors #332F3A / #635F69
- **FR-002**: System MUST render headings in Nunito (weights 700/800/900) and body text in DM Sans (weights 400/500/700), while preserving Amiri for Arabic text
- **FR-003**: System MUST apply multi-layered clay shadows (outer, highlight, inner reflection, inner rim light) to cards and elevated surfaces
- **FR-004**: System MUST use rounded corners following the hierarchy: large containers 48–60px, standard cards 32px, medium elements 24px, buttons/inputs 20px, icons 16px/circular, badges 8px minimum
- **FR-005**: System MUST render animated floating blurred blobs as background decorative elements on all main screens
- **FR-006**: System MUST implement gradient primary buttons (light violet to #7C3AED) with convex clay shadow and press squish animation
- **FR-007**: System MUST provide four button variants: primary (gradient), secondary (neutral), outline (border accent), ghost (minimal)
- **FR-008**: System MUST implement clay-styled input fields with recessed appearance, soft inner shadow, and raised surface on focus
- **FR-009**: System MUST animate interactive elements: tap lift on cards, press compression on buttons, breathing on decorative elements
- **FR-010**: System MUST respect the device reduced motion accessibility setting by disabling or minimizing all animations
- **FR-011**: System MUST maintain a bento/varied grid layout on the home screen, avoiding uniform card repetition
- **FR-012**: System MUST support both LTR and RTL layouts with appropriate shadow direction adjustments
- **FR-013**: System MUST redesign all 6 navigation tabs (Home, Prayers, Qibla, Quran, Athkar, Settings) to use the clay aesthetic
- **FR-014**: System MUST ensure all interactive elements have a minimum touch target of 44px
- **FR-015**: System MUST maintain high contrast between text and backgrounds (WCAG AA compliance for body text)
- **FR-016**: ~~DEFERRED~~ Dark mode clay theme is out of scope for this feature and will be addressed in a separate follow-up
- **FR-017**: System MUST preserve all existing functionality — the redesign is visual only; no behavioral changes to features
- **FR-018**: System MUST restyle utility widgets (loading indicator, error view, empty state) with the clay aesthetic so all screen states — including transient ones — are visually consistent

### Key Entities

- **ClayTheme**: Centralized design token container — colors, typography, shadows, radii, spacing, gradients
- **ClayShadow**: Multi-layer shadow definition — outer shadow, highlight shadow, inner reflection, inner rim light parameters
- **ClayCard**: Universal card component — radius, shadow layers, padding, optional glass effect, tap interaction
- **ClayButton**: Interactive button component — variant (primary/secondary/outline/ghost), gradient, shadow, press animation
- **BackgroundBlob**: Decorative element — position, color, opacity, blur radius, animation parameters

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of app screens render with the Clay UI design system — no screens retain the old green Material theme
- **SC-002**: All interactive elements (buttons, cards, inputs) respond to user input within 100ms with visible feedback animation
- **SC-003**: Users with reduced motion enabled see zero decorative animations while retaining full functionality
- **SC-004**: All body text meets WCAG AA contrast ratio (4.5:1 minimum) against the canvas and card backgrounds
- **SC-005**: The app maintains smooth scrolling (no dropped frames from shadow rendering) on mid-range devices
- **SC-006**: All existing features (prayer times, Quran reader, athkar, tasbih, qibla, settings) function identically after the redesign — zero functional regressions
- **SC-007**: Touch targets are at minimum 44px across all interactive elements on all screen sizes
- **SC-008**: RTL layout renders correctly with mirrored clay shadows on all screens

## Assumptions

- The existing clean architecture (data/domain/presentation per feature) will be preserved; only presentation layer widgets change
- The Amiri font for Arabic text is retained as-is; only English/UI fonts change to Nunito and DM Sans
- The 6-tab navigation structure remains the same; only visual styling changes
- Dark mode clay theme is deferred to a follow-up feature; this redesign targets light theme only
- Performance optimization (shadow layer reduction) for low-end devices uses Flutter's built-in device capability detection
- Background blobs are purely decorative and do not affect touch/interaction zones
