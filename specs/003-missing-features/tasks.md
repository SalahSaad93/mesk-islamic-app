# Implementation Tasks: Implement Remaining Features from Plan

This document outlines the actionable tasks to implement the `003-missing-features` branch.

## Execution Strategy

*   **TDD Focus**: The project constitution mandates TDD. Tests must be written before implementations.
*   **Separation of Concerns**: Each task typically stays within one architectural layer (data, domain, presentation).
*   **Phase Independence**: Each User Story Phase produces a testable release increment.

---

## Phase 1: Setup & Data Foundation

This phase prepares the shared dependencies and base entities required for the subsequent user stories. 

- [X] T001 Add `share_plus: ^10.1.4` to `pubspec.yaml` and run `flutter pub get`.
- [X] T002 Update `lib/features/quran/domain/entities/note_entity.dart` with `NoteEntity` definition (id, verseId, text, timestamps).
- [X] T003 Update `lib/features/quran/domain/entities/highlight_entity.dart` with `HighlightEntity` definition (id, verseId, color, createdAt).
- [X] T004 Update `lib/features/quran/domain/entities/bookmark_entity.dart` with `BookmarkEntity` definition.
- [X] T005 Update `lib/features/quran/domain/entities/reciter_entity.dart` with `ReciterEntity` definition.
- [X] T006 [P] Add unit tests for entity JSON serialization/deserialization mapping in `test/unit/quran/entities_test.dart`.

---

## Phase 2: User Story 1 - Quran Personalization (P1)

*Goal*: Enable users to bookmark, highlight, and write notes on verses, with persistence to SQLite.

- [X] T007 [US1] Create integration tests for SQLite CRUD operations for Notes, Highlights, and Bookmarks in `test/integration/quran/user_data_datasource_test.dart`.
- [X] T008 [US1] Update `lib/features/quran/data/datasources/quran_user_data_datasource.dart` to implement SQLite tables and CRUD methods for `NoteEntity`, `HighlightEntity`, and `BookmarkEntity`. Ensure note length constraint (2000 chars) is validated before insert.
- [X] T009 [US1] Update `lib/features/quran/domain/repositories/quran_repository.dart` to abstract the new user data methods.
- [X] T010 [US1] Implement `lib/features/quran/presentation/providers/user_data_provider.dart` to expose states (list of notes, active bookmarks, active highlights) to the UI.
- [X] T011 [US1] Create widget test `test/widget/quran/notes_screen_test.dart` asserting chronological list rendering and edit/delete actions.
- [X] T012 [US1] Build `lib/features/quran/presentation/screens/notes_screen.dart` displaying notes and handling edit/delete states.
- [X] T013 [US1] Update `lib/features/quran/presentation/widgets/verse_actions_menu.dart` to wire up the "Bookmark", "Highlight", and "Add Note" UI triggers to the `UserDataProvider`.

---

## Phase 3: User Story 2 - Audio Reciter Selection (P2)

*Goal*: Allow users to change the active audio reciter from a local JSON list, seamlessly redirecting subsequent audio playbacks.

- [X] T014 [US2] Create raw data assets file `assets/data/reciters.json` containing the application's supported reciters. Ensure it's declared in `pubspec.yaml`.
- [X] T015 [P] [US2] Create integration test `test/integration/quran/reciter_datasource_test.dart` verifying local JSON parsing.
- [X] T016 [US2] Implement `lib/features/quran/data/datasources/reciter_datasource.dart` to load `ReciterEntity` list from the JSON asset.
- [X] T017 [US2] Add audio reciter preference state management to `lib/features/quran/presentation/providers/quran_audio_provider.dart` (saving selected reciter to `StorageService`).
- [X] T018 [US2] Create widget test `test/widget/quran/reciter_picker_sheet_test.dart` to ensure list renders correctly and selection updates the provider. 
- [X] T019 [US2] Build `lib/features/quran/presentation/widgets/reciter_picker_sheet.dart` to display the list of reciters in a distinct bottom sheet UI.
- [X] T020 [US2] Update `lib/features/quran/presentation/screens/quran_reader_screen.dart` to display current reciter name and open `ReciterPickerSheet` on tap.

---

## Phase 4: User Story 3 - Social Sharing (P3)

*Goal*: Launch native OS sharing sheets populated with plain text verse formats containing Arabic and Translation.

- [X] T021 [US3] Implement refined sharing logic in `MushafPageView` using `share_plus` to include proper Islamic context (Arabic + Translation + Branding).
- [X] T022 [US4] Implement Pull-to-Refresh in `lib/features/quran/presentation/screens/notes_screen.dart`.
- [X] T023 [US4] Trigger "Surprise & Delight" confetti animation on `MushafPageView` when a user successfully adds their first note, bookmark, or highlight.

---

## Phase 5: User Story 4 - App Polish & UX Enhancements (P4)

*Goal*: Implement Pull-to-Refresh for data freshness, daily verse rotations, and Athkar milestone animations.

- [X] T024 [US4] Update `lib/features/home/presentation/widgets/daily_inspiration_widget.dart` to fetch a rotating verse from `daily_verses.json` instead of a static placeholder.
- [X] T025 [P] [US4] Add widget tests for pull-to-refresh on `test/widget/prayer_times/prayer_times_screen_test.dart` and `test/widget/athkar/athkar_list_screen_test.dart`.
- [X] T026 [US4] Wrap the scroll body in `lib/features/prayer_times/presentation/screens/prayer_times_screen.dart` with a `RefreshIndicator` wired to the prayer fetch provider.
- [X] T027 [US4] Wrap the scroll body in `lib/features/athkar/presentation/screens/athkar_list_screen.dart` with a `RefreshIndicator` wired to the athkar fetch provider.
- [X] T028 [US4] Create unit test for athkar completion logic in `test/unit/athkar/athkar_completion_test.dart` verifying the "overall category sum" condition.
- [X] T029 [US4] Update `lib/features/athkar/presentation/providers/athkar_progress_provider.dart` to emit a completion event when the category Dhikr counts equal the category target sums.
- [X] T030 [US4] Implement `lib/features/athkar/presentation/widgets/celebration_animation.dart` using an implicit `TweenAnimationBuilder` scaling a `goldAccent` indicator, triggered by the `AthkarProgressProvider` completion event.

---

## Phase 6: Optimization & Profiling

*Goal*: Final assurance against memory leaks, stutter, or specification misses.

- [X] T031 Run `flutter analyze` and resolve any warnings introduced. 
- [ ] T032 Profile the application on a physical device. Confirm memory remains stable (≤ 80MB) while opening `NotesScreen` and scrolling through heavily highlighted `QuranReaderScreen`. Validate 60 FPS scrolling.
- [X] T033 Verify RTL text alignment remains correct within the new `ReciterPickerSheet` and `NotesScreen`.
