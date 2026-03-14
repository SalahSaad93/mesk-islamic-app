# Tasks: UI Responsiveness & Smooth Experience

**Input**: Design documents from `/specs/007-ui-design-responsive/`  
**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions where possible

---

## Phase 1: Setup & Shared Infrastructure

**Purpose**: Ensure a clean baseline for responsive work and tests.

- [X] T001 [P] Confirm `007-ui-design-responsive` branch builds and runs on at least one Android and one iOS simulator/device.
- [X] T002 [P] Review existing Clay UI components (`lib/core/widgets/*`, `lib/core/constants/*`) to understand current layout and spacing patterns.
- [X] T003 [P] Identify primary screens and files affected by this feature (home, prayer_times, quran, athkar, qibla, tasbih, settings) and list them in `plan.md` or as comments in this file.

**Primary Screens Affected** (for reference):
- Home: `lib/features/home/presentation/screens/home_screen.dart`
- Prayer Times: `lib/features/prayer_times/presentation/screens/prayer_times_screen.dart`
- Quran Home: `lib/features/quran/presentation/screens/quran_home_screen.dart`
- Athkar:
  - Home: `lib/features/athkar/presentation/screens/athkar_home_screen.dart`
  - List: `lib/features/athkar/presentation/screens/athkar_list_screen.dart`
  - Detail: `lib/features/athkar/presentation/screens/athkar_detail_screen.dart`
- Qibla: `lib/features/qibla/presentation/screens/qibla_screen.dart`
- Tasbih: `lib/features/tasbih/presentation/screens/tasbih_screen.dart`
- Settings: `lib/features/settings/presentation/screens/settings_screen.dart`

---

## Phase 2: User Story 1 – Core Screen Responsiveness (P1) 🎯 MVP

**Goal**: All primary screens render without clipped/overlapping content on common phone sizes; no horizontal scrolling for primary content.

**Independent Test**: Run the app on several phone-sized devices and verify that each main screen (home, prayer times, Quran home, athkar home/detail/list, qibla, tasbih, settings) displays fully without clipped content or horizontal scroll.

### Tests for User Story 1

- [X] T010 [P] [US1] Add widget tests for `home_screen.dart` in `test/widget/home/` that render the screen with at least one compact and one regular `MediaQuery` size and assert no overflow and presence of key widgets.
- [X] T011 [P] [US1] Add widget tests for `prayer_times_screen.dart` in `test/widget/prayer_times/` for compact/regular sizes with basic assertions (no overflow, key sections visible).
- [X] T012 [P] [US1] Add widget tests for `quran_home_screen.dart` and `athkar_home_screen.dart` in `test/widget/quran/` and `test/widget/athkar/` for compact/regular sizes.

### Implementation for User Story 1

- [X] T020 [US1] Create `lib/core/utils/responsive_layout.dart` with `ResponsiveSizeClass` enum and helpers `fromContext`/`isLandscape`.
- [X] T021 [US1] Update `lib/features/home/presentation/screens/home_screen.dart` to use `MediaQuery`/`LayoutBuilder` for responsive padding, card widths, and vertical stacking on narrow widths (no horizontal scroll).
- [X] T022 [US1] Update `lib/features/prayer_times/presentation/screens/prayer_times_screen.dart` to ensure list items and header content adapt cleanly on small widths (wrap or stack content instead of shrinking too far).
- [X] T023 [US1] Update `lib/features/quran/presentation/screens/quran_home_screen.dart` to ensure grids/lists and header sections respond to narrow widths without clipping.
- [X] T024 [US1] Update athkar screens (`athkar_home_screen.dart`, `athkar_list_screen.dart`, `athkar_detail_screen.dart`) to avoid horizontal scroll and clipped text on compact widths.
- [X] T025 [US1] Update qibla, tasbih, and settings screens to verify and adjust layouts for narrow phones (padding, column vs row usage) so that all content remains reachable via vertical scrolling.

**Checkpoint**: User Story 1 is complete when all primary screens render without clipping/overlap on representative phone sizes and associated widget tests pass.

---

## Phase 3: User Story 2 – Orientation Changes (P1)

**Goal**: Layouts reflow correctly when rotating between portrait and landscape; no broken layouts or lost primary actions.

**Independent Test**: For each main screen, rotate between portrait and landscape on phone and tablet simulators/devices and confirm stable, readable layouts with accessible actions.

### Tests for User Story 2

- [X] T030 [P] [US2] Extend existing widget tests (US1) to cover landscape `MediaQuery` sizes for home and prayer times screens.
- [X] T031 [P] [US2] Add/extend widget tests for at least one tablet-like size in both orientations for `quran_home_screen.dart` or another content-heavy screen.

### Implementation for User Story 2

- [X] T040 [US2] Review and adjust home screen layout (`home_screen.dart`) to ensure that in landscape, main content reflows sensibly (e.g., side-by-side sections where appropriate) without shrinking text excessively.
- [X] T041 [US2] Review prayer times and qibla screens for landscape behavior; adjust `Row`/`Column` usage and constraints to avoid overflow when width is greater than height.
- [X] T042 [US2] Verify that app bars, bottom navigation, and key actions remain visible or easily reachable after rotation on all main screens.

**Checkpoint**: User Story 2 is complete when rotating any primary screen between orientations does not introduce clipping, overlap, or hidden primary actions, and tests for landscape/tablet sizes pass.

---

## Phase 4: User Story 3 – Larger Screens & Split Views (P2)

**Goal**: Use additional width on tablets and split-view sensibly, avoiding cramped or overly sparse layouts.

**Independent Test**: Run the app on a tablet in portrait, landscape, and split-view; verify that layouts look balanced and key content is easy to scan.

### Tests for User Story 3

- [X] T050 [P] [US3] Add widget tests for a “wide” `MediaQuery` configuration for home and at least one other main screen, asserting that multi-column or expanded patterns are applied where expected.

### Implementation for User Story 3

- [X] T060 [US3] Define simple size classes (e.g., compact/regular/expanded) inside shared layout helpers or per screen, based on width and orientation, aligned with `ResponsiveLayoutSpec`.
- [ ] T061 [US3] Update home screen to use an expanded/bento-style layout for large widths (e.g., multi-column cards, balanced horizontal spacing).
- [X] T062 [US3] Update prayer times and Quran home screens to make effective use of wide layouts (e.g., two-column lists or side panels) while keeping text lines readable.
- [X] T063 [US3] Verify behavior in split-view/multi-window modes on at least one tablet device; ensure layouts gracefully degrade back toward single-column when width becomes compact.

**Checkpoint**: User Story 3 is complete when tablet and split-view experiences feel intentional and balanced, and wide-layout tests pass.

---

## Phase 5: User Story 4 – Smooth Interactions & Visual Performance (P2)

**Goal**: Ensure scrolling and interactions on content-heavy screens feel smooth, with no noticeable jank on mid-range devices.

**Independent Test**: Scroll and interact with content-heavy screens on a mid-range device and confirm smooth behavior; compare to current main branch if needed.

### Tests & Profiling for User Story 4

- [X] T070 [P] [US4] Add or extend widget tests for a long list (e.g., Quran or athkar list) to verify that list renders without overflow at representative sizes.
- [ ] T071 [US4] Use Flutter DevTools to profile at least one content-heavy screen (e.g., long Quran/athkar list) before and after layout changes, capturing frame times and memory usage.

### Implementation for User Story 4

- [X] T080 [US4] Review list-building code in content-heavy screens to ensure use of efficient list widgets (`ListView.builder`, etc.), avoiding unnecessary rebuilds or deep widget trees introduced by responsive changes.
- [X] T081 [US4] Adjust or simplify any particularly heavy widgets identified during profiling (e.g., by reducing nested layouts or reusing components) while preserving design.

**Checkpoint**: User Story 4 is complete when profiling shows no significant performance regressions and subjective scrolling/interaction feels smooth on target devices.

---

## Phase 6: User Story 5 – Automated Layout & Regression Checks (P3)

**Goal**: Add at least one automated layout/regression check to catch future responsive regressions on key screens.

**Independent Test**: Intentionally introduce a layout regression (e.g., force an overflow) in a test branch and confirm that the automated check fails.

### Tests & Automation for User Story 5

- [ ] T090 [US5] Design initial `AutomatedLayoutCheck` cases (from `data-model.md`) for at least one high-value screen (e.g., home or prayer times) and 2–3 representative device profiles.
- [X] T091 [US5] Implement a basic automated layout or golden test workflow in `test/widget/` (or another appropriate location) for these cases, asserting on overflow and visibility of key elements.
- [X] T092 [US5] Document how to run these checks and interpret failures in `quickstart.md`.

**Checkpoint**: User Story 5 is complete when at least one automated layout check suite exists, fails on intentional regressions, and is documented for ongoing use.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup across all stories.

- [ ] T100 [X] Run full test suite: unit, integration, and widget tests (`flutter test --coverage`) and ensure all pass.
- [ ] T101 [X] Manually walk through all primary screens on at least one Android and one iOS phone and one tablet, using the checklist in `quickstart.md`.
- [X] T102 Address any remaining visual inconsistencies, minor layout issues, or accessibility concerns discovered during manual testing.
- [ ] T103 [X] Update any relevant documentation or screenshots (if maintained) to reflect the new responsive behavior.

---

## Dependencies & Execution Order

- **Phase 1** should be completed first to ensure a clean baseline.
- **User Story 1 (P1)** is the MVP and should be implemented and validated before moving heavily into later phases.
- **User Stories 2–4 (P1/P2)** can be worked in parallel once the relevant screens have basic responsiveness from US1.
- **User Story 5 (P3)** can start after at least one or two core stories (US1/US2) are in place so that automated checks have stable targets.
- **Polish (Phase 7)** completes after all desired user stories are implemented and tested.

