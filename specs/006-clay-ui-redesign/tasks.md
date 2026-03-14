# Tasks: Clay UI Design System Redesign

**Input**: Design documents from `/specs/006-clay-ui-redesign/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Included — constitution mandates TDD with 80% coverage.

**Organization**: Tasks grouped by user story. US1 (design tokens) maps to Foundational phase since all other stories depend on it.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US8)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: Project initialization, font bundling, dependency verification

- [X] T001 Verify google_fonts ^6.2.1 supports Nunito and DM Sans in pubspec.yaml
- [X] T002 [P] Bundle Nunito font files (weights 700/800/900) as local assets in assets/fonts/Nunito/
- [X] T003 [P] Bundle DM Sans font files (weights 400/500/700) as local assets in assets/fonts/DMSans/
- [X] T004 Register bundled fonts in pubspec.yaml under fonts section and configure GoogleFonts.config.allowRuntimeFetching = false in lib/main.dart

---

## Phase 2: Foundational — US1: Core Design Tokens & Theme Foundation (Priority: P1)

**Purpose**: Core infrastructure that MUST be complete before ANY other user story

**Goal**: Replace all design tokens (colors, typography, shadows, radii, spacing) and theme configuration so the app renders with the clay visual identity.

**Independent Test**: Launch app and verify canvas color #F4F1FA, Nunito headings, DM Sans body, Amiri Arabic text on home screen.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Tests for Foundational (US1)

> Write these tests FIRST, ensure they FAIL before implementation

- [X] T005 [P] [US1] Widget test verifying canvas background color is #F4F1FA in test/widget/clay_theme_test.dart
- [X] T006 [P] [US1] Widget test verifying Nunito heading font and DM Sans body font rendering in test/widget/clay_typography_test.dart
- [X] T007 [P] [US1] Widget test verifying Amiri font preserved for Arabic text in test/widget/clay_typography_test.dart
- [X] T008 [P] [US1] Unit test verifying all ClayColors token values match data-model.md in test/unit/clay_colors_test.dart
- [X] T009 [P] [US1] Unit test verifying ClayShadow presets (surface, surfaceLite, button, pressed, navigation) in test/unit/clay_shadows_test.dart

### Implementation for Foundational (US1)

- [X] T010 [P] [US1] Replace color tokens in lib/core/constants/app_colors.dart with clay palette per data-model.md ClayColors table (rename constants: primaryGreen→primaryAccent, backgroundLight→canvas, etc.)
- [X] T011 [P] [US1] Create multi-layer shadow presets in lib/core/constants/clay_shadows.dart with surface, surfaceLite, button, pressed, navigation levels per data-model.md ClayShadow table
- [X] T012 [P] [US1] Create border radius hierarchy in lib/core/constants/clay_radii.dart with containerLarge, card, medium, button, icon, badge per data-model.md ClayRadii table
- [X] T013 [P] [US1] Replace typography styles in lib/core/constants/app_text_styles.dart with Nunito headings + DM Sans body per data-model.md ClayTypography table, preserving all Arabic (Amiri) styles
- [X] T014 [US1] Update spacing scale in lib/core/constants/app_spacing.dart to ensure values are used consistently (currently defined but unused across codebase)
- [X] T015 [US1] Replace theme configuration in lib/core/theme/app_theme.dart with clay theme: canvas background, violet ColorScheme seed, clay CardTheme (32px radius), clay AppBarTheme (Nunito), clay BottomNavBarTheme, clay InputDecorationTheme (20px radius, recessed), clay ChipTheme, clay SwitchTheme (violet)
- [X] T016 [US1] Add RTL-aware shadow helper method to lib/core/constants/clay_shadows.dart that negates x-offsets when Directionality is RTL per research R8
- [X] T017 [US1] Create reduced motion utility ClayAnimationUtil.shouldAnimate(context) in lib/core/utils/clay_animation_util.dart per research R7

**Checkpoint**: App renders with clay canvas color, fonts, and basic theme. All screens automatically pick up new colors/typography from centralized tokens.

---

## Phase 3: US2 — Clay Card & Button Components (Priority: P1) 🎯 MVP

**Goal**: Build the core reusable components (ClayCard, ClayButton, ClayInput, BackgroundBlobs) and restyle utility widgets.

**Independent Test**: All component variants render correctly with proper shadows, animations, and interaction states.

### Tests for US2

> Write these tests FIRST, ensure they FAIL before implementation

- [ ] T018 [P] [US2] Widget test for ClayCard: renders with 32px radius, shadow layers, glass effect option, tap lift animation in test/widget/clay_card_test.dart
- [ ] T019 [P] [US2] Widget test for ClayButton: all 4 variants (primary gradient, secondary, outline, ghost), press squish animation, disabled state in test/widget/clay_button_test.dart
- [ ] T020 [P] [US2] Widget test for ClayInput: recessed appearance, focus raise, prefix/suffix icons in test/widget/clay_input_test.dart
- [ ] T021 [P] [US2] Widget test for BackgroundBlobsLayer: renders blobs, respects reduced motion setting in test/widget/background_blobs_test.dart

### Implementation for US2

- [X] T022 [US2] Create ClayCard widget in lib/core/widgets/clay_card.dart per data-model.md ClayCard spec: 32px radius, configurable shadow level, glass effect, tap lift animation (translateY -2px over 100ms), 48dp min touch target
- [X] T023 [US2] Create ClayButton widget in lib/core/widgets/clay_button.dart per data-model.md ClayButton spec: 4 variants with gradient/solid/outline/ghost, press squish animation (scale 0.95 over 100ms down, 150ms up per research R4), isLoading state, 48dp min touch target
- [X] T024 [US2] Create ClayInput widget in lib/core/widgets/clay_input.dart per data-model.md ClayInput spec: recessed shadow (pressed level), raised shadow on focus (surface level), 20px radius
- [X] T025 [US2] Create BackgroundBlobsLayer widget in lib/core/widgets/background_blobs.dart per research R2: CustomPainter with radial gradients, AnimationController for slow drift, RepaintBoundary isolation, reduced motion support via ClayAnimationUtil
- [X] T026 [US2] Update IslamicCard in lib/core/widgets/islamic_card.dart to re-export ClayCard as deprecated alias per research R5
- [X] T027 [P] [US2] Update LoadingIndicator in lib/core/widgets/loading_indicator.dart with clay styling: violet accent color, clay-themed appearance
- [X] T028 [P] [US2] Update ErrorView in lib/core/widgets/error_view.dart with clay styling: wrap in ClayCard, use clay typography and colors
- [X] T029 [P] [US2] Update EmptyState in lib/core/widgets/empty_state.dart with clay styling: clay typography, violet accent icon
- [X] T030 [US2] Update SectionHeader in lib/core/widgets/section_header.dart with clay typography (Nunito section title, violet accent)

**Checkpoint**: All reusable clay components built and tested. Utility widgets restyled. Ready for screen-by-screen application.

---

## Phase 4: US3 — Home Screen Redesign (Priority: P2)

**Goal**: Redesign home screen with bento layout, clay cards, gradient icon containers, and background blobs.

**Independent Test**: Navigate to home tab; verify bento layout, gradient tiles, hero prayer countdown card, blob animations, tap lift.

### Tests for US3

- [X] T031 [P] [US3] Widget test for home screen bento layout and clay card rendering in test/widget/home_screen_test.dart

### Implementation for US3

- [X] T032 [US3] Redesign home screen in lib/features/home/presentation/screens/home_screen.dart: add BackgroundBlobsLayer, replace uniform layout with bento/varied grid, wrap sections in ClayCard
- [X] T033 [US3] Update prayer countdown card on home to use hero-level ClayCard with heroTitle typography (Nunito 32px 900) in lib/features/home/presentation/screens/home_screen.dart
- [X] T034 [US3] Update quick-access feature tiles on home to use pastel-to-saturated gradient icon containers in lib/features/home/presentation/widgets/
- [X] T035 [US3] Update DailyInspirationWidget with clay card styling in lib/features/home/presentation/widgets/daily_inspiration_widget.dart

**Checkpoint**: Home screen fully redesigned with clay aesthetic, bento layout, blobs.

---

## Phase 5: US4 — Navigation Bar Redesign (Priority: P2)

**Goal**: Restyle bottom navigation bar with clay aesthetic — rounded top corners, clay shadow, violet selected state.

**Independent Test**: Switch between all 6 tabs; verify clay nav styling, violet active state, smooth transitions.

### Tests for US4

- [ ] T036 [US4] Widget test for clay bottom navigation bar styling and tab switching in test/widget/app_shell_test.dart

### Implementation for US4

- [ ] T037 [US4] Redesign bottom navigation bar in lib/core/navigation/app_shell.dart: rounded top corners (ClayRadii.medium), navigation shadow level, violet selected icon (#7C3AED), smooth tab transition animation, 48dp touch targets

**Checkpoint**: Navigation bar fully restyled. All tab switching works with clay aesthetic.

---

## Phase 6: US5 — Prayer Times Screen Redesign (Priority: P2)

**Goal**: Redesign prayer times with individual clay cards per prayer, gradient accent for next prayer, muted past prayers, hero countdown.

**Independent Test**: Navigate to prayer times tab; verify individual prayer cards, active/past/upcoming states, countdown typography.

### Tests for US5

- [ ] T038 [US5] Widget test for prayer times screen clay cards and prayer status styling in test/widget/prayer_times_screen_test.dart

### Implementation for US5

- [ ] T039 [US5] Redesign prayer times screen in lib/features/prayer_times/presentation/screens/prayer_times_screen.dart: add BackgroundBlobsLayer, wrap each prayer time in ClayCard, use gradient accent for next prayer, muted surfaceLite shadow for past prayers, hero countdown with countdownTimer typography
- [ ] T040 [US5] Replace all IslamicCard references in prayer_times_screen.dart with ClayCard (if any remain after token migration)

**Checkpoint**: Prayer times screen fully redesigned with clay cards and prayer status hierarchy.

---

## Phase 7: US6 — Quran Reader & Athkar Screens Redesign (Priority: P3)

**Goal**: Restyle Quran index/reader and athkar screens with clay aesthetic while preserving Arabic readability.

**Independent Test**: Browse surah index, open a surah, browse athkar categories, view athkar detail — verify clay cards, Arabic readability, gradient icons.

### Tests for US6

- [ ] T041 [P] [US6] Widget test for surah index clay card rendering in test/widget/quran_screens_test.dart
- [ ] T042 [P] [US6] Widget test for athkar home category cards with gradient icons in test/widget/athkar_screens_test.dart

### Implementation for US6

- [ ] T043 [P] [US6] Redesign Quran home screen in lib/features/quran/presentation/screens/quran_home_screen.dart: add BackgroundBlobsLayer, replace cards with ClayCard, clay typography
- [ ] T044 [P] [US6] Redesign surah index in lib/features/quran/presentation/screens/surah_index_screen.dart: ClayCard per surah with surfaceLite shadow for scroll performance, clay typography
- [ ] T045 [P] [US6] Redesign juz index in lib/features/quran/presentation/screens/juz_index_screen.dart: ClayCard styling, clay typography
- [ ] T046 [US6] Update Quran reader controls in lib/features/quran/presentation/screens/quran_reader_screen.dart: clay-styled audio controls, navigation, preserve Amiri Arabic text with generous line height
- [ ] T047 [P] [US6] Update Quran search screen in lib/features/quran/presentation/screens/quran_search_screen.dart: ClayInput for search field, ClayCard for results
- [ ] T048 [P] [US6] Update bookmarks screen in lib/features/quran/presentation/screens/bookmarks_screen.dart: ClayCard list items
- [ ] T049 [P] [US6] Update notes screen in lib/features/quran/presentation/screens/notes_screen.dart: ClayCard list items
- [ ] T050 [US6] Redesign athkar home in lib/features/athkar/presentation/screens/athkar_home_screen.dart: add BackgroundBlobsLayer, ClayCard per category with distinct gradient icon containers
- [ ] T051 [US6] Redesign athkar list in lib/features/athkar/presentation/screens/athkar_list_screen.dart: ClayCard per athkar item with surfaceLite shadow
- [ ] T052 [US6] Redesign athkar detail in lib/features/athkar/presentation/screens/athkar_detail_screen.dart: clay-styled counter, progress elements, ClayButton for actions

**Checkpoint**: All Quran and Athkar screens fully restyled. Arabic readability preserved.

---

## Phase 8: US7 — Tasbih Counter & Settings Redesign (Priority: P3)

**Goal**: Restyle tasbih counter with clay press button and settings with clay card groups.

**Independent Test**: Open tasbih, tap counter (verify squish animation); open settings, toggle options (verify clay cards and violet toggles).

### Tests for US7

- [ ] T053 [P] [US7] Widget test for tasbih counter clay button press animation in test/widget/tasbih_screen_test.dart
- [ ] T054 [P] [US7] Widget test for settings screen clay card groups in test/widget/settings_screen_test.dart

### Implementation for US7

- [ ] T055 [US7] Redesign tasbih screen in lib/features/tasbih/presentation/screens/tasbih_screen.dart: add BackgroundBlobsLayer, large ClayButton for counter with squish animation, tasbihCounter typography (Nunito 64px 900), clay-styled reset/options controls
- [ ] T056 [US7] Redesign settings screen in lib/features/settings/presentation/screens/settings_screen.dart: add BackgroundBlobsLayer, wrap each settings group in ClayCard, violet accent toggles/switches, ClayInput for text fields
- [ ] T057 [US7] Redesign qibla screen in lib/features/qibla/presentation/screens/qibla_screen.dart: add BackgroundBlobsLayer, clay-styled compass container, clay typography

**Checkpoint**: All remaining screens (tasbih, settings, qibla) fully restyled.

---

## Phase 9: US8 — Animation & Motion System + Polish (Priority: P3)

**Goal**: Ensure all animations are consistent, blob animations run on all screens, reduced motion is respected, RTL shadows are correct.

**Independent Test**: Navigate all screens observing animations; enable reduced motion in device settings and verify suppression; switch to Arabic RTL and verify shadow mirroring.

### Tests for US8

- [ ] T058 [P] [US8] Widget test verifying reduced motion disables all decorative animations in test/widget/reduced_motion_test.dart
- [ ] T059 [P] [US8] Widget test verifying RTL shadow x-offset negation in test/widget/rtl_shadows_test.dart

### Implementation for US8

- [ ] T060 [US8] Audit all screens for consistent blob animation: verify BackgroundBlobsLayer present on all main screens (home, prayers, qibla, quran home, athkar home, tasbih, settings)
- [ ] T061 [US8] Audit all ClayCard and ClayButton usages for consistent tap/press animations across all screens
- [ ] T062 [US8] Verify all animations respect ClayAnimationUtil.shouldAnimate(context) — blob drift, card lift, button squish, breathing decorative elements
- [ ] T063 [US8] Verify RTL shadow mirroring on all screens when Arabic locale is active
- [ ] T064 [US8] Performance profiling: verify 60 FPS scrolling on surah index and athkar list (surfaceLite shadows), no jank from blob animations, cold start ≤ 2s
- [ ] T065 Verify WCAG AA contrast (4.5:1 minimum) for all text on canvas (#F4F1FA) and surface (#FFFFFF) backgrounds
- [ ] T066 Verify all interactive elements have 48dp minimum touch targets across all screens
- [ ] T067 Run full regression test: all existing features (prayer times calculation, Quran reader, athkar counters, tasbih, qibla compass, settings persistence) function identically after redesign
- [ ] T068 Clean up deprecated IslamicCard re-export in lib/core/widgets/islamic_card.dart (remove file if no remaining references)
- [ ] T069 Version bump in pubspec.yaml (MINOR bump for visual redesign)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational/US1 (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US2 (Phase 3)**: Depends on Foundational — components need design tokens
- **US3–US5 (Phases 4–6)**: Depend on US2 — screens need ClayCard/ClayButton/BackgroundBlobs
- **US6–US7 (Phases 7–8)**: Depend on US2 — can run in parallel with US3–US5
- **US8/Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Foundation — blocks everything
- **US2 (P1)**: Depends on US1 — blocks all screen redesigns
- **US3 (P2)**: Depends on US2 — independent of US4/US5
- **US4 (P2)**: Depends on US2 — independent of US3/US5
- **US5 (P2)**: Depends on US2 — independent of US3/US4
- **US6 (P3)**: Depends on US2 — independent of US3/US4/US5/US7
- **US7 (P3)**: Depends on US2 — independent of US3/US4/US5/US6
- **US8 (P3)**: Depends on ALL above — cross-cutting polish

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Design token constants before theme configuration
- Reusable components before screen-specific usage
- Core screen before sub-widgets

### Parallel Opportunities

- **Phase 1**: T002, T003 can run in parallel (different font files)
- **Phase 2**: T005–T009 tests in parallel; T010–T013 token files in parallel
- **Phase 3**: T018–T021 tests in parallel; T027–T029 utility widgets in parallel
- **Phases 4–6**: US3, US4, US5 can all run in parallel (different screens, no cross-dependencies)
- **Phases 7–8**: US6, US7 can run in parallel; US6 internal tasks T043–T049 in parallel
- **Phase 9**: T058, T059 tests in parallel

---

## Parallel Example: Foundational Phase (US1)

```bash
# Launch all tests in parallel:
Task: T005 "Widget test canvas background #F4F1FA"
Task: T006 "Widget test Nunito/DM Sans font rendering"
Task: T007 "Widget test Amiri Arabic font preserved"
Task: T008 "Unit test ClayColors token values"
Task: T009 "Unit test ClayShadow presets"

# Launch all token files in parallel:
Task: T010 "Replace colors in app_colors.dart"
Task: T011 "Create clay_shadows.dart"
Task: T012 "Create clay_radii.dart"
Task: T013 "Replace typography in app_text_styles.dart"
```

## Parallel Example: Screen Redesigns (US3 + US4 + US5)

```bash
# These three user stories can run in parallel after US2 completes:
Task: T032-T035 "Home screen redesign (US3)"
Task: T036-T037 "Navigation bar redesign (US4)"
Task: T038-T040 "Prayer times redesign (US5)"
```

---

## Implementation Strategy

### MVP First (US1 + US2)

1. Complete Phase 1: Setup (font bundling)
2. Complete Phase 2: Foundational/US1 (design tokens + theme)
3. Complete Phase 3: US2 (clay components)
4. **STOP and VALIDATE**: All components work, theme renders clay aesthetic
5. App is visually transformed even without screen-specific redesigns (tokens propagate automatically)

### Incremental Delivery

1. Setup + Foundational → App renders with clay colors/fonts globally
2. Add US2 (components) → ClayCard/ClayButton available, utility widgets restyled
3. Add US3 (home) → First screen fully redesigned → Demo
4. Add US4 + US5 (nav + prayers) → Core screens polished → Demo
5. Add US6 + US7 (quran + athkar + tasbih + settings) → All screens done
6. Add US8 (animation polish) → Final quality pass

### Parallel Team Strategy

With multiple developers after US2 completes:
- Developer A: US3 (home) + US5 (prayers)
- Developer B: US4 (nav) + US7 (tasbih + settings)
- Developer C: US6 (quran + athkar)
- All converge: US8 (animation audit + polish)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Constitution requires TDD: write tests first, verify they fail, then implement
- Touch targets: use 48dp (constitution) not 44px (clay spec minimum)
- Use surfaceLite (2-layer) shadows for list items in scrolling contexts (research R1)
- Use CustomPainter for blobs, not BackdropFilter (research R2)
- Bundle fonts locally for offline support (research R3)
- Commit after each task or logical group
- Profile performance before Phase 9 checkpoint
