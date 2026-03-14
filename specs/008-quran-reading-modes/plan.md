# Implementation Plan: Quran Reading Modes

**Branch**: `008-quran-reading-modes` | **Date**: 2026-03-13 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/008-quran-reading-modes/spec.md`

## Summary

Revamp the Quran reading experience to support two modes: **Full Quran Mode** (page-by-page Mushaf-style reading with Khatma progress tracking, similar to the Khatma app) and **Verse Mode** (single-ayah focused study with English translation, audio, and tafsir). The existing PageView-based reader becomes Full Quran Mode with persistence and progress tracking added. Verse Mode is a new screen with swipe navigation. A mode toggle enables seamless switching while preserving reading position. Reader customization (font size, night mode) applies to both modes.

## Technical Context

**Language/Version**: Dart 3.10.4 / Flutter 3.x
**Primary Dependencies**: flutter_riverpod ^2.6.1, sqflite (SQLite), just_audio ^0.9.40, shared_preferences ^2.3.4, google_fonts ^6.2.1, scrollable_positioned_list, confetti, share_plus, dio ^5.8.0+1
**Storage**: SQLite (mesk_quran.db, currently v2 → migrating to v3) + SharedPreferences
**Testing**: flutter test (unit in test/unit/, integration in test/integration/, widget in test/widget/)
**Target Platform**: Android & iOS mobile
**Project Type**: Mobile app (Flutter)
**Performance Goals**: 60 FPS scrolling, page transitions ≤300ms, mode switch <1s, resume <2s, surah load ≤200ms
**Constraints**: Offline-capable for core reading, Arabic RTL text support, ≤80MB idle RAM
**Scale/Scope**: 6,236 verses, 604 pages, 114 surahs, 30 juz, 8 reciters

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Phase 0 Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | PASS | Feature follows existing data/domain/presentation layers. New datasources (translation, tafsir) follow established patterns. |
| II. Comprehensive Testing | PASS | Plan includes unit tests for new providers/datasources, integration tests for DB migration and data queries, widget tests for both reading modes. |
| III. Consistent UX & Accessibility | PASS | Uses existing ClayCard, AppColors, AppSpacing, AppTextStyles. Arabic RTL support via existing Amiri font. Semantic labels required for new controls. |
| IV. Mobile Performance | PASS | PageView already handles 604 pages efficiently. Verse Mode uses single-item display (minimal memory). Translation/tafsir cached locally. Font size changes are in-memory state. |
| V. Versioning & Stability | PASS | DB migration v2→v3 with proper onCreate/onUpgrade. No breaking changes to existing features. SharedPreferences keys are additive. |

### Post-Phase 1 Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | PASS | New entities (Translation, TafsirCache) in domain layer. New datasources for translation and tafsir. Providers follow existing StateNotifier/FutureProvider patterns. |
| II. Comprehensive Testing | PASS | Data model designed for testability: translation table is query-friendly, tafsir cache has clear lifecycle, SharedPreferences keys are mockable. |
| III. Consistent UX & Accessibility | PASS | Mode toggle uses segmented control (standard pattern). Night mode is reader-scoped. Font size uses discrete levels (not continuous slider) for predictable layout. |
| IV. Mobile Performance | PASS | Translation data bundled (no runtime fetch). Tafsir cached after first fetch. No continuous background processes. |
| V. Versioning & Stability | PASS | DB v3 migration is additive only (new tables, no column changes). Existing bookmarks/notes/highlights unaffected. |

## Project Structure

### Documentation (this feature)

```text
specs/008-quran-reading-modes/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 research decisions
├── data-model.md        # Phase 1 data model
├── quickstart.md        # Phase 1 developer guide
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (via /speckit.tasks)
```

### Source Code (repository root)

```text
lib/features/quran/
├── data/
│   ├── datasources/
│   │   ├── quran_db_datasource.dart          # Extended: translation queries
│   │   ├── quran_local_datasource.dart       # Unchanged
│   │   ├── quran_audio_datasource.dart       # Unchanged
│   │   ├── quran_user_data_datasource.dart   # Unchanged
│   │   ├── quran_translation_datasource.dart # NEW: translation data access
│   │   ├── quran_tafsir_datasource.dart      # NEW: tafsir fetch + cache
│   │   └── reciter_datasource.dart           # Unchanged
│   ├── models/
│   │   ├── translation_model.dart            # NEW: translation DB mapping
│   │   └── tafsir_cache_model.dart           # NEW: tafsir cache DB mapping
│   ├── repositories/
│   │   └── quran_repository_impl.dart        # Extended: translation + tafsir
│   └── services/
│       └── quran_database_service.dart       # Extended: v3 migration + new tables
├── domain/
│   ├── entities/
│   │   ├── verse_entity.dart                 # Unchanged
│   │   ├── surah_entity.dart                 # Unchanged
│   │   ├── translation_entity.dart           # NEW
│   │   ├── tafsir_entity.dart                # NEW
│   │   ├── khatma_progress_entity.dart       # NEW: value object
│   │   ├── verse_position_entity.dart        # NEW: position value object
│   │   └── reading_preferences_entity.dart   # NEW: value object
│   └── repositories/
│       └── quran_repository.dart             # Extended: translation + tafsir contracts
├── presentation/
│   ├── providers/
│   │   ├── quran_provider.dart               # Extended: mode state, persistence
│   │   ├── quran_audio_provider.dart         # Unchanged
│   │   ├── quran_translation_provider.dart   # NEW: translation state
│   │   ├── quran_khatma_provider.dart        # NEW: khatma progress
│   │   ├── quran_preferences_provider.dart   # NEW: reading preferences
│   │   ├── reciter_provider.dart             # Unchanged
│   │   └── user_data_provider.dart           # Unchanged
│   ├── screens/
│   │   ├── quran_home_screen.dart            # Modified: mode toggle, updated navigation
│   │   ├── quran_reader_screen.dart          # Modified: persistence, khatma, preferences
│   │   ├── quran_verse_mode_screen.dart      # NEW: verse-by-verse reading
│   │   ├── surah_index_screen.dart           # Unchanged
│   │   ├── juz_index_screen.dart             # Unchanged
│   │   └── quran_search_screen.dart          # Unchanged
│   └── widgets/
│       ├── mushaf_page_view.dart             # Modified: font size, night mode support
│       ├── verse_widget.dart                 # Modified: font size support
│       ├── verse_mode_card.dart              # NEW: single-verse display widget
│       ├── reading_mode_toggle.dart          # NEW: segmented control for mode switch
│       ├── khatma_progress_widget.dart       # NEW: progress display
│       ├── reader_settings_sheet.dart        # NEW: font size + night mode controls
│       ├── tafsir_bottom_sheet.dart          # Modified: real data integration
│       ├── verse_actions_menu.dart           # Unchanged
│       └── reciter_picker_sheet.dart         # Unchanged

assets/data/
├── quran_verses.json                         # Extended: full 6,236 verses
├── quran_translation_en.json                 # NEW: Sahih International translation
├── surahs.json                               # Unchanged
└── reciters.json                             # Unchanged

test/
├── unit/quran/
│   ├── quran_khatma_provider_test.dart       # NEW
│   ├── quran_preferences_provider_test.dart  # NEW
│   └── verse_position_test.dart              # NEW
├── integration/quran/
│   ├── quran_db_migration_test.dart          # NEW
│   ├── quran_translation_datasource_test.dart # NEW
│   └── quran_tafsir_datasource_test.dart     # NEW
└── widget/quran/
    ├── quran_home_screen_test.dart           # Extended
    ├── quran_verse_mode_screen_test.dart     # NEW
    ├── reading_mode_toggle_test.dart         # NEW
    └── khatma_progress_widget_test.dart      # NEW
```

**Structure Decision**: Follows existing clean architecture pattern under `lib/features/quran/`. New files are added within the established layer hierarchy. No new top-level directories needed.

## Complexity Tracking

No constitution violations. All new code follows established patterns:
- New datasources mirror existing `QuranDbDatasource` pattern
- New providers mirror existing `StateNotifierProvider` / `FutureProvider.family` patterns
- New entities mirror existing `VerseEntity` / `BookmarkEntity` patterns
- DB migration follows existing v1→v2 pattern in `QuranDatabaseService`
- SharedPreferences keys follow existing naming convention (`quran_*`)
