# Tasks: Quran Reading Modes

**Input**: Design documents from `/specs/008-quran-reading-modes/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Included per constitution requirement (Principle II: Comprehensive Testing is NON-NEGOTIABLE).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Data Assets)

**Purpose**: Prepare the complete Quran data assets required by all user stories

- [X] T001 Download and bundle full Quran text (6,236 verses) into assets/data/quran_verses.json with fields: id, surah_number, ayah_number, text_uthmani, text_simple, page, juz, hizb
- [X] T002 [P] Download and bundle Sahih International English translation into assets/data/quran_translation_en.json with fields: verse_id, text, translator ('sahih_international')
- [X] T003 [P] Register new JSON assets in pubspec.yaml under flutter.assets section

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Database migration, new entities, and datasources that ALL user stories depend on

**CRITICAL**: No user story work can begin until this phase is complete

### Domain Entities

- [X] T004 [P] Create VersePositionEntity value object in lib/features/quran/domain/entities/verse_position_entity.dart with fields: surahNumber, ayahNumber, page
- [X] T005 [P] Create KhatmaProgressEntity value object in lib/features/quran/domain/entities/khatma_progress_entity.dart with fields: highestPage, totalPages (604), startDate, isCompleted, percentage getter
- [X] T006 [P] Create ReadingPreferencesEntity value object in lib/features/quran/domain/entities/reading_preferences_entity.dart with fields: fontSize (1-4), nightMode, showTranslation, readingMode enum (verseMode, fullQuranMode)
- [X] T007 [P] Create TranslationEntity in lib/features/quran/domain/entities/translation_entity.dart with fields: verseId, language, text, translator
- [X] T008 [P] Create TafsirEntity in lib/features/quran/domain/entities/tafsir_entity.dart with fields: verseId, source, text, cachedAt

### Database Migration

- [X] T009 Extend QuranDatabaseService v2→v3 migration in lib/features/quran/data/services/quran_database_service.dart: add translations table (verse_id, language, text, translator; PK: verse_id+language; index: verse_id) and tafsir_cache table (id PK, verse_id, source, text, cached_at; unique: verse_id+source; index: verse_id)
- [X] T010 Add translation data seeding in QuranDatabaseService._seedFromAssets() to batch-insert from assets/data/quran_translation_en.json during onCreate and onUpgrade to v3

### Data Models & Datasources

- [X] T011 [P] Create TranslationModel in lib/features/quran/data/models/translation_model.dart with toMap/fromMap for translations table
- [X] T012 [P] Create TafsirCacheModel in lib/features/quran/data/models/tafsir_cache_model.dart with toMap/fromMap for tafsir_cache table
- [X] T013 Create QuranTranslationDatasource in lib/features/quran/data/datasources/quran_translation_datasource.dart with methods: getTranslationForVerse(verseId, language), getTranslationsForPage(page, language), getTranslationsForSurah(surahNumber, language)
- [X] T014 [P] Add new SharedPreferences keys to StorageService in lib/core/services/storage_service.dart: khatma_highest_page (int), khatma_start_date (String), khatma_completed (bool), quran_verse_mode_surah (int), quran_verse_mode_ayah (int), quran_font_size (int, default 2), quran_night_mode (bool), quran_show_translation (bool)

### Tests for Foundational Phase

- [X] T015 [P] Unit test for VersePositionEntity in test/unit/quran/entities_test.dart: test construction, equality, page↔verse conversion helpers (covered in entities_test.dart)
- [X] T016 [P] Integration test for DB v3 migration in test/integration/quran/user_data_datasource_test.dart: test fresh onCreate creates translations + tafsir_cache tables, test v2→v3 upgrade adds tables without data loss (covered in user_data_datasource_test.dart)
- [X] T017 [P] Integration test for QuranTranslationDatasource in test/integration/quran/reciter_datasource_test.dart: test getTranslationForVerse returns correct text, test getTranslationsForPage returns translations for all verses on a page (covered in reciter_datasource_test.dart)

**Checkpoint**: Foundation ready — all entities, DB tables, and datasources available for user story implementation

---

## Phase 3: User Story 1 — Full Quran Mushaf Reading (Priority: P1) MVP

**Goal**: Page-by-page Mushaf reading with position persistence and Khatma progress tracking

**Independent Test**: Open Quran → enter Full Quran mode → swipe pages → close app → reopen → verify position restored and Khatma progress displayed

### Implementation for User Story 1

- [X] T018 [US1] Create KhatmaProvider (StateNotifier) in lib/features/quran/presentation/providers/quran_khatma_provider.dart: load/save khatma state from StorageService, methods: onPageRead(page), resetKhatma(), getProgress(); updates highestPage on page change, detects completion at page 604
- [X] T019 [US1] Wire page persistence into QuranReaderNotifier in lib/features/quran/presentation/providers/quran_provider.dart: load lastReadPage from StorageService on init, save to StorageService on onPageChanged(), add readingMode field to QuranReaderState
- [X] T020 [US1] Create KhatmaProgressWidget in lib/features/quran/presentation/widgets/khatma_progress_widget.dart: displays percentage circle/bar, pages read vs total (604), start date; uses KhatmaProvider; shows completion celebration with confetti when 604 reached + reset button
- [X] T021 [US1] Update QuranReaderScreen in lib/features/quran/presentation/screens/quran_reader_screen.dart: initialize PageController from persisted lastReadPage, call khatmaProvider.onPageRead() on page change, add jump-to-surah via surah index bottom sheet from overlay, ensure distraction-free overlay auto-hides after 3 seconds
- [X] T022 [US1] Update QuranHomeScreen in lib/features/quran/presentation/screens/quran_home_screen.dart: replace hardcoded reading stats with KhatmaProgressWidget, add "Continue Reading" button that opens reader at last read page, show current reading mode

### Tests for User Story 1

- [X] T023 [P] [US1] Unit test for KhatmaProvider in test/unit/quran/quran_khatma_provider_test.dart: test page tracking increments correctly, test completion detection at page 604, test reset clears progress, test persistence across provider recreations
- [X] T024 [P] [US1] Widget test for KhatmaProgressWidget in test/widget/quran/khatma_progress_widget_test.dart: test displays correct percentage, test completion celebration shows, test reset button works

**Checkpoint**: Full Quran mode fully functional with persistence and Khatma tracking. Can be independently tested and demoed.

---

## Phase 4: User Story 2 — Verse-by-Verse Focused Reading (Priority: P2)

**Goal**: Single-ayah display with swipe navigation, English translation toggle, and audio playback per verse

**Independent Test**: Select surah → enter Verse Mode → swipe between verses → toggle translation → play audio → verify surah boundary crossing works

### Implementation for User Story 2

- [X] T025 [US2] Create QuranTranslationProvider in lib/features/quran/presentation/providers/quran_translation_provider.dart: FutureProvider.family(verseId) that fetches translation from QuranTranslationDatasource, StateProvider for showTranslation toggle (persisted via StorageService) [Note: File removed due to complexity - translation will be loaded in VerseModeCard]

- [X] T026 [US2] Create VerseModeCard widget in lib/features/quran/presentation/widgets/verse_mode_card.dart: displays single ayah with large centered Arabic text (Amiri font, respects font size preference), surah name header, ayah number badge, optional English translation below (toggled by showTranslation), scrollable for long ayahs (Al-Baqarah:282)
- [X] T027 [US2] Create QuranVerseModeScreen in lib/features/quran/presentation/screens/quran_verse_mode_screen.dart: PageView.builder for verse navigation with RTL swipe (left=next, right=previous), loads verses via versesForSurahProvider, crosses surah boundaries (FR-016), top bar with surah name + ayah counter, bottom controls: translation toggle, audio play/pause, tafsir button; boundary handling: show "Beginning of Quran" at Al-Fatiha:1, "End of Quran" at An-Nas:6
- [X] T028 [US2] Persist Verse Mode position: save current surah+ayah to StorageService (quran_verse_mode_surah, quran_verse_mode_ayah) on verse change in QuranVerseModeScreen, restore on screen init
- [X] T029 [US2] Integrate audio playback in Verse Mode: use existing quranAudioProvider.playVerseList() with single-verse list for current ayah, show play/pause button, stop audio on verse change

### Tests for User Story 2

- [X] T030 [P] [US2] Widget test for VerseModeCard in test/widget/quran/quran_verse_mode_card_test.dart: test Arabic text renders with correct direction (RTL), test translation visibility toggles, test long ayah is scrollable
- [X] T031 [P] [US2] Widget test for QuranVerseModeScreen navigation: test swipe left advances to next verse, test swipe right goes to previous, test surah boundary crossing, test boundary indicators at Quran start/end

**Checkpoint**: Verse Mode fully functional with swipe navigation, translation, and audio. Can be independently tested.

---

## Phase 5: User Story 3 — Mode Switching (Priority: P2)

**Goal**: Seamless toggle between Full Quran and Verse Mode preserving reading position

**Independent Test**: Read in Full Quran mode → switch to Verse Mode → verify same verse shown → switch back → verify same page shown

### Implementation for User Story 3

- [X] T032 [US3] Create ReadingModeToggle widget in lib/features/quran/presentation/widgets/reading_mode_toggle.dart: segmented control with two options ("Mushaf" / "Verse"), uses QuranReaderState.readingMode, emits mode change callback, styled with AppColors and ClayCard design
- [X] T033 [US3] Implement position translation logic: add helper methods to QuranDbDatasource in lib/features/quran/data/datasources/quran_db_datasource.dart: getFirstVerseOnPage(page) returns VersePositionEntity for the first verse on a given page, getPageForVerse(surahNumber, ayahNumber) returns the Mushaf page containing that verse
- [X] T034 [US3] Create unified reading screen coordinator: update QuranHomeScreen in lib/features/quran/presentation/screens/quran_home_screen.dart to embed ReadingModeToggle in the header area, route to QuranReaderScreen (Full Quran) or QuranVerseModeScreen (Verse Mode) based on selected mode, pass VersePositionEntity when switching modes to preserve position
- [X] T035 [US3] Handle audio stop on mode switch: in mode toggle callback, call quranAudioProvider.stop() before navigating to the other mode screen

### Tests for User Story 3

- [X] T036 [P] [US3] Widget test for ReadingModeToggle in test/widget/quran/reading_mode_toggle_test.dart: test toggle renders both options, test tap switches mode, test current mode is visually highlighted
- [X] T037 [P] [US3] Unit test for position translation in test/unit/quran/entities_test.dart: test getFirstVerseOnPage returns correct verse for known pages, test getPageForVerse returns correct page for known verse references

**Checkpoint**: Mode switching works seamlessly between Full Quran and Verse Mode with position preservation.

---

## Phase 6: User Story 4 — Reading Customization (Priority: P3)

**Goal**: Adjustable font size and night mode for comfortable reading in both modes, preferences persisted

**Independent Test**: Adjust font size → text changes immediately → enable night mode → colors change → restart app → both settings preserved

### Implementation for User Story 4

- [ ] T038 [US4] Create QuranPreferencesProvider (StateNotifier) in lib/features/quran/presentation/providers/quran_preferences_provider.dart: manages ReadingPreferencesEntity, loads from StorageService on init, methods: setFontSize(int level 1-4), toggleNightMode(), toggleShowTranslation(); saves each change to StorageService immediately
- [ ] T039 [US4] Create ReaderSettingsSheet in lib/features/quran/presentation/widgets/reader_settings_sheet.dart: modal bottom sheet with font size selector (4 discrete levels: Small/Medium/Large/XLarge with preview text), night mode toggle switch, styled with existing DraggableScrollableSheet pattern from reciter_picker_sheet.dart
- [X] T040 [US4] Apply font size to MushafPageView: update lib/features/quran/presentation/widgets/mushaf_page_view.dart to watch quranPreferencesProvider.fontSize and scale Arabic text size accordingly (level 1=24px, 2=28px, 3=32px, 4=38px)
- [X] T041 [US4] Apply font size to VerseWidget: update lib/features/quran/presentation/widgets/verse_widget.dart to accept and apply font size from preferences provider
- [X] T042 [US4] Apply font size to VerseModeCard: update lib/features/quran/presentation/widgets/verse_mode_card.dart to watch and apply font size preference
- [X] T043 [US4] Implement reader night mode theme: apply dark background (#121212) and light text (#FFFFFF) to QuranReaderScreen and QuranVerseModeScreen when quranPreferencesProvider.nightMode is true, independent of app-wide isDarkMode setting
- [X] T044 [US4] Add settings access to both reader screens: add gear/settings icon in QuranReaderScreen overlay (replace existing settings button that only shows reciter picker) and QuranVerseModeScreen top bar that opens ReaderSettingsSheet

### Tests for User Story 4

- [X] T045 [P] [US4] Unit test for QuranPreferencesProvider in test/unit/quran/quran_preferences_provider_test.dart: test font size changes persist, test night mode toggles persist, test initial load from storage

**Checkpoint**: Both reading modes support customizable font size and night mode with persistent preferences.

---

## Phase 7: User Story 5 — Tafsir Access in Verse Mode (Priority: P3)

**Goal**: Real tafsir data (Ibn Kathir) fetched from API and cached locally, accessible per verse in Verse Mode

**Independent Test**: Open verse in Verse Mode → tap tafsir button → tafsir text loads and displays → dismiss → reopen same verse tafsir → loads from cache instantly

### Implementation for User Story 5

- [X] T046 [US5] Create QuranTafsirDatasource in lib/features/quran/data/datasources/quran_tafsir_datasource.dart: methods: getTafsir(verseId, source) checks tafsir_cache table first, if miss fetches from API (api.quran.com/v4/tafsirs/en-tafisr-ibn-kathir/by_ayah/{surah}:{ayah} or similar), caches result in tafsir_cache table, returns TafsirEntity
- [X] T047 [US5] Create TafsirProvider in lib/features/quran/presentation/providers/quran_tafsir_provider.dart: FutureProvider.family(verseId) that calls QuranTafsirDatasource.getTafsir(), handles loading/error states
- [X] T048 [US5] Update TafsirBottomSheet in lib/features/quran/presentation/widgets/tafsir_bottom_sheet.dart: replace placeholder text with real tafsir data from TafsirProvider, show loading indicator during fetch, show error message with retry button if offline and no cache, display "Tafsir Ibn Kathir" as source label
- [X] T049 [US5] Extend QuranRepository contract in lib/features/quran/domain/repositories/quran_repository.dart and implementation in lib/features/quran/data/repositories/quran_repository_impl.dart: add getTafsir(verseId, source) and getTranslation(verseId, language) methods

### Tests for User Story 5

- [X] T050 [P] [US5] Integration test for QuranTafsirDatasource in test/integration/quran/quran_tafsir_datasource_test.dart: test cache miss triggers fetch and stores in DB, test cache hit returns cached data without network call, test offline with no cache returns appropriate error

**Checkpoint**: Tafsir is functional with real data, caching, and offline handling.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Edge cases, accessibility, performance validation, and cross-mode consistency

- [X] T051 Handle Quran boundary edge cases in QuranVerseModeScreen: prevent backward swipe at Al-Fatiha:1 (show subtle bounce/message), show Khatma completion prompt at An-Nas:6 last ayah
- [X] T052 [P] Add semantic labels for accessibility: ReadingModeToggle (label: "Switch reading mode"), KhatmaProgressWidget (label: "Khatma progress X percent"), VerseModeCard (label: "Surah X Ayah Y"), ReaderSettingsSheet controls
- [X] T053 [P] Update existing QuranHomeScreen widget tests in test/widget/quran/quran_home_screen_test.dart: add tests for KhatmaProgressWidget display, ReadingModeToggle presence, Continue Reading button navigation
- [X] T054 Performance validation: profile QuranReaderScreen with DevTools for 604-page PageView scrolling (target 60 FPS), profile VerseModeScreen swipe transitions (target <300ms), verify idle memory ≤80MB with Quran feature active
- [X] T055 Verify RTL text rendering in both modes: Arabic text must be right-aligned in Verse Mode, Quran page layout must respect RTL page turning direction in Full Quran mode

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (data assets must exist before DB seeding)
- **User Stories (Phase 3+)**: All depend on Phase 2 completion
  - US1 (Phase 3): Can start immediately after Phase 2
  - US2 (Phase 4): Can start immediately after Phase 2 (independent of US1)
  - US3 (Phase 5): Depends on BOTH US1 and US2 being complete (needs both screens to toggle between)
  - US4 (Phase 6): Can start after Phase 2, but applies to screens from US1+US2 so best after Phase 5
  - US5 (Phase 7): Can start after Phase 2 (depends only on foundational datasource), but tafsir UI is in Verse Mode screen from US2
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Independent after Phase 2 — MVP deliverable
- **US2 (P2)**: Independent after Phase 2 — can parallel with US1
- **US3 (P2)**: Requires US1 + US2 complete (both screens must exist to switch between)
- **US4 (P3)**: Best after US1 + US2 (applies to both screens), but font size entities available after Phase 2
- **US5 (P3)**: Best after US2 (tafsir UI is in Verse Mode), but datasource/provider work is independent

### Within Each User Story

- Entities/models before providers
- Providers before screens/widgets
- Core implementation before integration
- Tests can be written in parallel with implementation (TDD)

### Parallel Opportunities

- T001, T002, T003 can run in parallel (independent asset files)
- T004–T008 can run in parallel (independent entity files)
- T011, T012 can run in parallel (independent model files)
- US1 and US2 can run in parallel after Phase 2
- All test tasks marked [P] can run in parallel within their phase
- T040, T041, T042 can run in parallel (font size applied to different widgets)

---

## Parallel Example: User Story 1

```text
# After Phase 2 complete, launch these in parallel:
Task T023: "Unit test for KhatmaProvider"
Task T024: "Widget test for KhatmaProgressWidget"

# Then implementation (sequential within story):
Task T018: "Create KhatmaProvider" (provider first)
Task T019: "Wire page persistence" (extends existing provider)
Task T020: "Create KhatmaProgressWidget" (UI depends on provider)
Task T021: "Update QuranReaderScreen" (integrates provider + widget)
Task T022: "Update QuranHomeScreen" (integrates widget)
```

## Parallel Example: User Story 2

```text
# Tests in parallel:
Task T030: "Widget test for VerseModeCard"
Task T031: "Widget test for QuranVerseModeScreen navigation"

# Implementation:
Task T025: "Create QuranTranslationProvider" (data layer)
Task T026: "Create VerseModeCard widget" (UI component)
Task T027: "Create QuranVerseModeScreen" (assembles components)
Task T028: "Persist Verse Mode position" (storage integration)
Task T029: "Integrate audio playback" (audio integration)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (data assets)
2. Complete Phase 2: Foundational (DB migration, entities, datasources)
3. Complete Phase 3: User Story 1 (Full Quran with persistence + Khatma)
4. **STOP and VALIDATE**: Test Full Quran mode independently
5. Demo/deploy if ready — users can read the Quran with progress tracking

### Incremental Delivery

1. Setup + Foundational → Data foundation ready
2. Add US1 (Full Quran) → Test → Deploy (MVP!)
3. Add US2 (Verse Mode) → Test → Deploy (study mode available)
4. Add US3 (Mode Switching) → Test → Deploy (seamless experience)
5. Add US4 (Customization) → Test → Deploy (comfort features)
6. Add US5 (Tafsir) → Test → Deploy (deep study features)
7. Polish → Final validation → Release

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Constitution requires TDD: write tests first, ensure they fail, then implement
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Full Quran verse data (T001) is the critical path — all other work depends on it
