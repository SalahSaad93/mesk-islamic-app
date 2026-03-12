# Tasks: Localization and Location Fixes

**Input**: Design documents from `/specs/004-i18n-location-fixes/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Tests are included under each user story to fulfill the Constitution's mandate of comprehensive testing.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Verify Flutter localization generation (flutter gen-l10n) works correctly with current ARB files in `lib/l10n/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

*(No foundational blockers for this feature, the core structure already exists)*

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - App defaults to Arabic (Priority: P1) 🎯 MVP

**Goal**: Ensure the app defaults to Arabic upon first launch regardless of the system language.

**Independent Test**: Fully tested by reinstalling the app on a device with an English locale and observing Arabic UI text upon first launch.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T002 [P] [US1] Add unit test for StorageService language fallback in tests/unit/core/services/storage_service_test.dart
- [X] T003 [P] [US1] Add widget test verifying Arabic text rendering on first launch in tests/widget/app_first_launch_test.dart

### Implementation for User Story 1

- [X] T004 [P] [US1] Update `language` getter fallback from 'en' to 'ar' in lib/core/services/storage_service.dart

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Smooth Location Permission Flow (Priority: P1)

**Goal**: Prompt the user clearly to grant location permissions via a custom rationale dialog before triggering the OS-level prompt.

**Independent Test**: Revoke location permissions for the app and then open a screen that requires location, verifying the prompt appears and functions correctly.

### Tests for User Story 2

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T005 [P] [US2] Add widget test for permission rationale dialog presentation and interaction in tests/widget/prayer_times/permission_dialog_test.dart

### Implementation for User Story 2

- [X] T006 [P] [US2] Create location rationale permission dialog UI component in lib/core/widgets/location_permission_dialog.dart
- [X] T007 [US2] Integrate `LocationPermissionDialog` into PrayerTimes feature flow (e.g. before getting location) in lib/features/prayer_times/presentation/screens/prayer_times_screen.dart
- [X] T008 [US2] Gracefully handle "deniedForever" states with instructions to open settings

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Comprehensive Translation Coverage (Priority: P2)

**Goal**: Full coverage of Arabic translations for all UI text, error states, and dialogs.

**Independent Test**: Navigate through edge cases (errors, empty states) and verify all text appears translated correctly.

### Implementation for User Story 3

- [X] T009 [P] [US3] Add all missing ARB keys (including location rationale) to lib/l10n/app_en.arb
- [X] T010 [P] [US3] Add identical ARB keys with Arabic translations to lib/l10n/app_ar.arb
- [X] T011 [US3] Replace any remaining hardcoded English text in UI codebase with new `AppLocalizations.of(context)` string queries (e.g., error placeholders, empty state messages).

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T012 [P] Run flutter gen-l10n to explicitly finalize ARB generation
- [X] T013 Run manual quickstart.md validation to ensure everything works end-to-end on device.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately
- **Foundational (Phase 2)**: Skip, none block this feature.
- **User Stories (Phase 3+)**: US1 and US2 can proceed in parallel. US3 should follow once the keys are needed by the permission dialog.
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### Parallel Opportunities

- ARB updates (T009, T010) and StorageService changes (T004) can run in parallel.
- All tests for a user story marked [P] can run in parallel.
