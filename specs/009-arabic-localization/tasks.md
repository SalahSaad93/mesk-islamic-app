# Tasks: Arabic Localization as Primary Language

**Input**: Design documents from `/specs/009-arabic-localization/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, contracts/ ✓

**Tests**: Tests are included as per Constitution II (comprehensive testing at three levels).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter project structure**: `lib/` for source, `test/` for tests
- **Localization**: `lib/l10n/app_*.arb` for translations
- **Core services**: `lib/core/services/`
- **Features**: `lib/features/*/`

---

## Phase 1: Setup (Infrastructure)

**Purpose**: Project configuration and tooling setup for localization

- [X] T001 Add `hijri` package to pubspec.yaml for Hijri calendar support
- [X] T002 [P] Configure ARB file generation in l10n.yaml (verify template file is app_en.arb)
- [X] T003 [P] Run `flutter gen-l10n` to verify localization pipeline works

**Checkpoint**: Localization infrastructure ready

---

## Phase 2: Foundational (Core Localization Changes)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 Update StorageService to add language preference methods in lib/core/services/storage_service.dart
- [X] T006 Update SettingsState to include language field in lib/features/settings/presentation/providers/settings_provider.dart
- [X] T007 Update SettingsNotifier to handle language switching in lib/features/settings/presentation/providers/settings_provider.dart
- [X] T008 Create LocalizedNumberFormatter utility in lib/core/utils/localized_number_formatter.dart
- [X] T009 Create HijriDateFormatter utility in lib/core/utils/hijri_date.dart
- [X] T010 Update MaterialApp in lib/app.dart to use explicit locale from SettingsProvider (not system locale)
- [X] T011 Add Arabic as first supported locale in lib/app.dart supportedLocales

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Arabic Default Experience (Priority: P1) 🎯 MVP

**Goal**: New users see Arabic UI immediately on first launch without configuration

**Independent Test**: Install app on fresh device/simulator, verify all screens show Arabic from first launch

**Acceptance Criteria**: FR-001 (default to Arabic), FR-007 (maintain after reinstall), SC-002, SC-009

### Tests for User Story 1

- [ ] T012 [P] [US1] Create unit test for StorageService.getLanguage() defaulting to 'ar' in test/unit/core/services/storage_service_test.dart
- [ ] T013 [P] [US1] Create widget test for fresh install showing Arabic UI in test/widget/app_locale_default_test.dart
- [ ] T014 [P] [US1] Create integration test for language persistence across restarts in test/integration/l10n/language_persistence_test.dart

### Implementation for User Story 1

- [X] T015 [US1] Set default language to 'ar' in StorageService.getLanguage() in lib/core/services/storage_service.dart
- [X] T016 [US1] Initialize SettingsState.language with 'ar' as default in lib/features/settings/presentation/providers/settings_provider.dart
- [X] T017 [US1] Update MaterialApp locale resolution to use SettingsProvider.language (ignore system locale) in lib/app.dart
- [X] T018 [US1] Verify supportedLocales has Arabic ('ar') listed first in lib/app.dart
- [X] T019 [US1] Add SemanticLabels for Arabic accessibility in all main navigation widgets

**Checkpoint**: User Story 1 complete - app defaults to Arabic on fresh install

---

## Phase 4: User Story 2 - Complete Arabic Translation Coverage (Priority: P1)

**Goal**: All user-facing text is properly translated into Arabic with Islamic terminology

**Independent Test**: Navigate all 6 tabs (Home, Prayer Times, Qibla, Quran, Athkar, Settings), verify Arabic text everywhere

**Acceptance Criteria**: FR-002, FR-008 to FR-014, FR-017, FR-018, FR-023, SC-001, SC-003, SC-006, SC-008

### Tests for User Story 2

- [ ] T020 [P] [US2] Create widget test for Home screen Arabic text in test/widget/home/home_screen_arabic_test.dart
- [ ] T021 [P] [US2] Create widget test for Prayer Times screen Arabic text in test/widget/prayer_times/prayer_times_screen_arabic_test.dart
- [ ] T022 [P] [US2] Create widget test for Qibla screen Arabic text in test/widget/qibla/qibla_screen_arabic_test.dart
- [ ] T023 [P] [US2] Create widget test for Quran screen Arabic text in test/widget/quran/quran_screen_arabic_test.dart
- [ ] T024 [P] [US2] Create widget test for Athkar screen Arabic text in test/widget/athkar/athkar_screen_arabic_test.dart
- [ ] T025 [P] [US2] Create widget test for Settings screen Arabic text in test/widget/settings/settings_screen_arabic_test.dart
- [ ] T026 [P] [US2] Create widget test for Tasbih screen Arabic text in test/widget/tasbih/tasbih_screen_arabic_test.dart

### Implementation for User Story 2

- [X] T027 [P] [US2] Complete all missing Arabic translations in lib/l10n/app_ar.arb
- [X] T028 [P] [US2] Add navigation labels translations (homeTitle, prayerTitle, qiblaTitle, quranTitle, athkarTitle, settingsTitle)
- [X] T029 [P] [US2] Add prayer names translations (prayerFajr, prayerSunrise, prayerDhuhr, prayerAsr, prayerMaghrib, prayerIsha)
- [X] T030 [P] [US2] Add settings labels translations (settingsLanguage, settingsTheme, settingsNotifications, etc.)
- [X] T031 [P] [US2] Add common button translations (commonSave, commonCancel, commonConfirm, commonShare, commonClose)
- [X] T032 [P] [US2] Add error message translations (errorLocation, errorNetwork, errorPermission, etc.)
- [X] T033 [P] [US2] Add permission dialog translations (permissionLocation, permissionNotification)
- [X] T034 [US2] Verify all @description metadata exists in lib/l10n/app_en.arb for every key
- [X] T035 [US2] Run `flutter gen-l10n` to regenerate localization files

**Checkpoint**: User Story 2 complete - all UI text in Arabic

---

## Phase 5: User Story 4 - RTL Layout Support (Priority: P1)

**Goal**: All screens display correctly with right-to-left layout in Arabic mode

**Independent Test**: Switch to Arabic, verify every screen has mirrored layout (navigation tabs RTL, text right-aligned, icons mirrored)

**Acceptance Criteria**: FR-003, FR-015, FR-016, SC-005

### Tests for User Story 4

- [ ] T037 [P] [US4] Create widget test for Home screen RTL layout in test/widget/home/home_screen_rtl_test.dart
- [ ] T038 [P] [US4] Create widget test for bottom navigation RTL order in test/widget/core/navigation/app_shell_rtl_test.dart
- [ ] T039 [P] [US4] Create widget test for text input RTL alignment in test/widget/common/text_input_rtl_test.dart

### Implementation for User Story 4

- [X] T040 [US4] Verify MaterialApp uses Directionality based on locale in lib/app.dart
- [X] T041 [US4] Audit and fix all screens for RTL text direction (Home, Prayer Times, Qibla) in lib/features/*/
- [X] T042 [US4] Audit and fix all screens for RTL text direction (Quran, Athkar, Settings, Tasbih) in lib/features/*/
- [X] T043 [US4] Add RTL-aware padding/margins using AppSpacing constants in lib/core/constants/app_spacing.dart
- [X] T044 [US4] Mirror directional icons (back arrow, forward arrow) for RTL in lib/core/widgets/
- [X] T045 [US4] Verify list items flow RTL in all ListView/GridView widgets
- [X] T046 [US4] Verify input fields start with right-aligned text in Arabic mode

**Checkpoint**: User Story 4 complete - all screens RTL-correct

---

## Phase 6: User Story 3 - Arabic Language Preference (Priority: P2)

**Goal**: User can switch between Arabic and English, preference persists across sessions

**Independent Test**: Go to Settings, switch language to English, restart app, verify English persists; switch back to Arabic, verify Arabic persists

**Acceptance Criteria**: FR-004, FR-005, FR-006, FR-020, SC-004, SC-009

### Tests for User Story 3

- [ ] T047 [P] [US3] Create unit test for language preference persistence in test/unit/core/services/language_persistence_test.dart
- [ ] T048 [P] [US3] Create widget test for language switcher UI in test/widget/settings/language_selector_test.dart
- [ ] T049 [P] [US3] Create integration test for language switching without restart in test/integration/l10n/language_switch_test.dart

### Implementation for User Story 3

- [X] T050 [US3] Implement setLanguage() method in StorageService in lib/core/services/storage_service.dart
- [X] T051 [US3] Add language field to SettingsState in lib/features/settings/presentation/providers/settings_provider.dart
- [X] T052 [US3] Create setLanguage() method in SettingsNotifier that persists and updates state in lib/features/settings/presentation/providers/settings_provider.dart
- [X] T053 [US3] Create language selector UI in Settings screen in lib/features/settings/presentation/screens/settings_screen.dart
- [X] T054 [US3] Add language option strings (العربية, English) to ARB files in lib/l10n/
- [X] T055 [US3] Ensure MaterialApp locale updates immediately when language changes in lib/app.dart
- [X] T056 [US3] Add radio buttons or dropdown for language selection (Arabic/English) in lib/features/settings/presentation/screens/settings_screen.dart

**Checkpoint**: User Story 3 complete - language switching works

---

## Phase 7: Hijri Calendar & Eastern Arabic Numerals (Cross-cutting)

**Purpose**: Number and date formatting for Arabic locale

**Acceptance Criteria**: FR-019, FR-021, FR-022, SC-007, SC-011

### Tests

- [ ] T057 [P] Create unit test for LocalizedNumberFormatter Eastern Arabic numerals in test/unit/core/utils/localized_number_formatter_test.dart
- [ ] T058 [P] Create unit test for HijriDateFormatter Arabic date formatting in test/unit/core/utils/hijri_date_formatter_test.dart
- [ ] T059 [P] Create widget test for prayer time numerals in test/widget/prayer_times/prayer_numerals_test.dart

### Implementation

- [X] T060 Implement Eastern Arabic numeral conversion in lib/core/utils/localized_number_formatter.dart
- [X] T061 Implement Hijri date formatting in lib/core/utils/hijri_date.dart
- [X] T062 [P] Update Prayer Times screen to use LocalizedNumberFormatter for times in lib/features/prayer_times/presentation/
- [X] T063 [P] Update Tasbih counter to use LocalizedNumberFormatter in lib/features/tasbih/presentation/
- [X] T064 [P] Update Home screen to use HijriDate for date display in lib/features/home/presentation/
- [X] T065 [P] Add Hijri date display with Gregorian reference where applicable

**Checkpoint**: Numbers and dates display correctly in Arabic mode

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, documentation, and cleanup

- [X] T066 Create translation coverage validation script and add to CI in tools/check_translations.dart
- [X] T067 [P] Add Arabic semantic labels for accessibility in all interactive widgets
- [X] T068 [P] Verify all hardcoded strings are extracted to ARB files (no hardcoded text in Dart files)
- [X] T069 Run full test suite: flutter test --coverage
- [X] T070 Run Arabic locale on physical device: flutter run --locale=ar
- [X] T071 Run English locale on physical device: flutter run --locale=en
- [X] T072 Manual QA: Navigate all 6 tabs in Arabic mode, verify no English text
- [X] T073 Manual QA: Verify RTL layout on all screens in Arabic mode
- [X] T074 Update CHANGELOG.md with Arabic localization feature
- [X] T075 Update version in pubspec.yaml (MINOR bump per Constitution V)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-6)**: All depend on Foundational phase completion
  - US1, US2, US4 can proceed in parallel (different files, no cross-dependencies)
  - US3 depends on US1 (needs SettingsProvider working)
- **Hijri/Numbers (Phase 7)**: Can start after Foundational, affects all screens
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

```
Phase 1 (Setup)
    │
    ▼
Phase 2 (Foundational) ← BLOCKS ALL
    │
    ├──────► Phase 3 (US1: Default Arabic) ──────┐
    │                                            │
    ├──────► Phase 4 (US2: Translations) ───────┤
    │                                            │
    ├──────► Phase 5 (US4: RTL Layout) ──────────┤──► Phase 6 (US3: Language Switcher)
    │                                            │         (depends on US1)
    └──────► Phase 7 (Hijri/Numbers) ────────────┘
                        │
                        ▼
               Phase 8 (Polish)
```

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Core changes before screen updates
- Screen updates before RTL verification
- User story complete before moving to next priority

### Parallel Opportunities

**After Foundational (Phase 2) completes:**
- T027-T033 [US2]: All translation additions can run in parallel (different ARB entries)
- T037-T039 [US4]: All RTL tests can run in parallel
- T057-T059 [Phase 7]: All number/date tests can run in parallel
- US2 and US4 can be worked on simultaneously by different developers

**Within User Story 3:**
- T047-T049: All tests can run in parallel

---

## Parallel Example: After Foundational

```bash
# Launch User Story 1 tasks together:
Task T015: "Set default language to 'ar' in StorageService"
Task T016: "Initialize SettingsState.language with 'ar'"
Task T017: "Update MaterialApp locale resolution"

# Launch User Story 2 translations together (different lines in ARB):
Task T028: "Add navigation labels translations"
Task T029: "Add prayer names translations"
Task T030: "Add settings labels translations"
Task T031: "Add common button translations"

# Launch User Story 4 RTL audits together:
Task T041: "Audit Home/Prayer/Qibla screens for RTL"
Task T042: "Audit Quran/Athkar/Settings/Tasbih for RTL"
```

---

## Implementation Strategy

### MVP First (User Story 1 + US2 + US4)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all)
3. Complete Phase 3: US1 (Arabic Default)
4. Complete Phase 4: US2 (Complete Translations)
5. Complete Phase 5: US4 (RTL Layout)
6. **STOP and VALIDATE**: Test Arabic mode end-to-end
7. Deploy/Demo MVP

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 → Test default Arabic → Deploy
3. Add US2 + US4 → Test translations + RTL → Deploy
4. Add US3 → Test language switching → Deploy
5. Add Phase 7 → Test Hijri/Numbers → Deploy
6. Polish → Final release

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- Verify tests fail before implementing (TDD per Constitution II)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Constitution III: Add SemanticLabels for accessibility in Arabic
- Constitution IV: Localization adds minimal overhead (< 1MB)
- All ARB keys must have @description metadata for translators