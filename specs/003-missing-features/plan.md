# Implementation Plan: Implement Remaining Features from Plan

**Branch**: `003-missing-features` | **Date**: 2026-03-11 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/003-missing-features/spec.md`

## Summary

Implementing the final polish and secondary features derived from the initial app architecture. These include persisting Quran notes/highlights/bookmarks to SQLite, UI components for selecting audio reciters, verse social sharing via native OS sharing (text-only), athkar celebration animations, and pull-to-refresh. These changes require wiring together the `quran_user_data_datasource`, `quran_audio_datasource`, and various app providers to actual UI implementations.

## Technical Context

**Language/Version**: Dart 3.x / Flutter  
**Primary Dependencies**: `flutter_riverpod`, `sqflite`, `share_plus`, `just_audio`  
**Storage**: `sqflite` (Quran Data), `shared_preferences` (Settings/Athkar)  
**Testing**: `test`, `flutter_test` (Unit/Widget/Integration)  
**Target Platform**: iOS / Android  
**Project Type**: Mobile Application  
**Performance Goals**: < 200ms Quran Data fetch, 60fps scrolling  
**Constraints**: Notes capped at 2000 chars, no dynamic image rendering  
**Scale/Scope**: Local-first architecture  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Clean Architecture**: YES. Uses existing `domain` entities and maps to `quran_user_data_datasource` in `data`. UI will interface with standard `Presentation`/Providers.
- **Three-Level Testing**: YES. Requires integration tests for notes/highlights datastores and Widget tests for the new UIs (`ReciterPickerSheet`, `NotesScreen`).
- **Consistent UX**: YES. Will follow the `AppSpacing` and Color guidelines. The celebration animations will be light, non-intrusive elements.
- **Performance**: YES. SQLite FTS5 queries should return in <100ms. No expensive image generation happens during sharing.
- **Versioning**: YES. This constitutes a MINOR release feature addition (v1.1.0).

## Project Structure

### Documentation (this feature)

```text
specs/003-missing-features/
├── plan.md              # This file
├── research.md          # Output: Research on sharing text formats & animation
├── data-model.md        # Output: User storage entities
├── contracts/           # Not applicable for local app
└── quickstart.md        # Output: Dev configuration for new packages
```

### Source Code Context

```text
lib/
├── core/
├── features/
│   ├── athkar/
│   ├── prayer_times/
│   └── quran/
│       ├── data/datasources/
│       ├── domain/entities/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
```

**Structure Decision**: Will adhere seamlessly to the existing Clean Architecture layout defined in earlier architecture plans. New visual components will be placed within their respective `presentation/widgets` and `presentation/screens` folders under `features/[feature-name]`.
