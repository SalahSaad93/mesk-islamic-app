# Implementation Plan: Clay UI Design System Redesign

**Branch**: `006-clay-ui-redesign` | **Date**: 2026-03-12 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/006-clay-ui-redesign/spec.md`

## Summary

Complete visual redesign of the Mesk Islamic App from the current Material green theme to a Claymorphism design system. The approach replaces centralized design tokens (colors, typography, shadows, radii) first, then rebuilds reusable components (ClayCard, ClayButton, ClayInput, BackgroundBlobs), and finally applies the new design to all 14+ screens across 6 navigation tabs. This is a presentation-layer-only change — no data, domain, or business logic modifications. Light theme only (dark mode deferred).

## Technical Context

**Language/Version**: Dart 3.10.4 / Flutter 3.x (Material 3 enabled)
**Primary Dependencies**: flutter_riverpod ^2.6.1, google_fonts ^6.2.1 (adding Nunito + DM Sans), shared_preferences ^2.3.4
**Storage**: N/A (no storage changes — UI-only redesign)
**Testing**: flutter test (unit, integration, widget) with test package + mockito
**Target Platform**: Android + iOS mobile
**Project Type**: Mobile app (Flutter)
**Performance Goals**: 60 FPS scrolling with multi-layer clay shadows; screen transitions ≤ 300ms; cold start ≤ 2s
**Constraints**: Multi-layer BoxShadow rendering must not cause jank on mid-range devices; ≤ 80MB idle RAM
**Scale/Scope**: 14+ screens across 6 tabs; 31 files import AppColors; 25 files import AppTextStyles; 9 files use IslamicCard (17 occurrences)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Phase 0 Gate

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | PASS | Presentation-layer only changes; no cross-layer violations |
| II. Testing (TDD, 80%) | PASS | Widget tests required for all new clay components + restyled screens |
| III. UX Consistency | VIOLATION (justified) | Replacing IslamicCard → ClayCard, color palette #1A7A4A → #7C3AED, Inter → Nunito/DM Sans. See Complexity Tracking. |
| IV. Performance | PASS with risk | Multi-layer shadows need profiling; shadow reduction strategy for low-end devices |
| V. Versioning | PASS | MINOR version bump (visual redesign, non-breaking) |

**Gate result**: PASS with justified violations. Proceed to Phase 0.

### Post-Phase 1 Re-check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | PASS | All new components in `lib/core/widgets/` and `lib/core/constants/`. No cross-layer access. |
| II. Testing (TDD, 80%) | PASS | Widget tests planned for ClayCard, ClayButton, BackgroundBlobs, and all restyled screens |
| III. UX Consistency | PASS (with waiver) | New design system fully defined in data-model.md. ClayCard replaces IslamicCard as canonical card. Touch targets raised to 48dp (constitution). |
| IV. Performance | PASS | Research R1 defines 2-layer "lite" shadow for scrolling lists. R2 uses CustomPainter for blobs (no BackdropFilter). Profiling required before merge. |
| V. Versioning | PASS | MINOR bump for visual redesign |

**Gate result**: PASS. All NEEDS CLARIFICATION resolved in research.md. Ready for task generation.

## Project Structure

### Documentation (this feature)

```text
specs/006-clay-ui-redesign/
├── plan.md              # This file
├── research.md          # Phase 0: technical research
├── data-model.md        # Phase 1: component model definitions
├── quickstart.md        # Phase 1: developer quickstart guide
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # REPLACE: Clay color tokens
│   │   ├── app_text_styles.dart     # REPLACE: Clay typography (Nunito/DM Sans + Amiri preserved)
│   │   ├── app_spacing.dart         # UPDATE: Clay spacing scale
│   │   ├── app_assets.dart          # NO CHANGE
│   │   ├── clay_shadows.dart        # NEW: Multi-layer shadow definitions
│   │   └── clay_radii.dart          # NEW: Border radius hierarchy
│   ├── theme/
│   │   └── app_theme.dart           # REPLACE: Clay theme configuration
│   ├── widgets/
│   │   ├── islamic_card.dart        # REPLACE → clay_card.dart
│   │   ├── clay_card.dart           # NEW: Universal clay card component
│   │   ├── clay_button.dart         # NEW: 4-variant clay button
│   │   ├── clay_input.dart          # NEW: Recessed clay input field
│   │   ├── background_blobs.dart    # NEW: Animated floating blob decorations
│   │   ├── loading_indicator.dart   # UPDATE: Clay-styled loading
│   │   ├── error_view.dart          # UPDATE: Clay-styled error
│   │   ├── empty_state.dart         # UPDATE: Clay-styled empty state
│   │   └── section_header.dart      # UPDATE: Clay typography
│   └── navigation/
│       └── app_shell.dart           # UPDATE: Clay bottom nav styling
├── features/
│   ├── home/presentation/           # UPDATE: Bento layout, clay cards
│   ├── prayer_times/presentation/   # UPDATE: Clay prayer cards
│   ├── qibla/presentation/          # UPDATE: Clay compass styling
│   ├── quran/presentation/          # UPDATE: Clay surah cards, reader controls
│   ├── athkar/presentation/         # UPDATE: Clay category cards, detail
│   ├── tasbih/presentation/         # UPDATE: Clay counter button
│   └── settings/presentation/       # UPDATE: Clay settings groups
test/
├── widget/
│   ├── clay_card_test.dart          # NEW
│   ├── clay_button_test.dart        # NEW
│   ├── background_blobs_test.dart   # NEW
│   └── [feature]_screen_test.dart   # NEW per restyled screen
```

**Structure Decision**: Follows existing clean architecture. New clay components go in `lib/core/widgets/` and `lib/core/constants/`. No new architectural layers — this is a presentation-layer token + component replacement.

## Complexity Tracking

> Constitution III violations justified below — this feature IS a design system overhaul.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Replacing IslamicCard with ClayCard | Feature goal is a complete design system swap from Material green to Claymorphism | Wrapping IslamicCard with clay styling would create unnecessary indirection; a clean replacement is simpler |
| Color palette change (#1A7A4A → #7C3AED) | Clay design system defines violet as primary accent | Keeping green would contradict the design system spec entirely |
| Font change (Inter → Nunito/DM Sans) | Clay design system specifies Nunito headings + DM Sans body | Keeping Inter would break typographic identity of clay system |
| Touch target 44px vs constitution 48dp | Clay spec says 44px minimum; constitution says 48dp | Will use 48dp (constitution wins) — clay spec's 44px is a minimum, 48dp satisfies both |
