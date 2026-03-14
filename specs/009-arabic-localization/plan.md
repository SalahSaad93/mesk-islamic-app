# Implementation Plan: Arabic Localization as Primary Language

**Branch**: `009-arabic-localization` | **Date**: 2025-03-13 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/009-arabic-localization/spec.md`

## Summary

Make Arabic the primary/default language for the Mesk Islamic App with complete translation coverage, Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩), Hijri calendar support, and proper RTL layout. The app already has a localization framework (ARB-based with flutter_localizations); this feature ensures Arabic is the default on fresh install, all strings are translated, and the user experience is fully localized for Arabic-speaking Muslims.

## Technical Context

**Language/Version**: Dart SDK ^3.10.4, Flutter (latest compatible)
**Primary Dependencies**: flutter_riverpod (^2.6.1), flutter_localizations (SDK), intl (^0.20.0), google_fonts (^6.2.1)
**Storage**: SharedPreferences for language preference persistence, SQLite (sqflite) for Quran data
**Testing**: flutter_test (SDK), mocktail (^1.0.4), widget/unit/integration test structure in test/
**Target Platform**: Android (minSdk via Flutter SDK, Java17), iOS (standard Flutter config), Portrait-only
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Cold start ≤ 2s, screen transitions ≤ 300ms, 60 FPS scrolling (per constitution)
**Constraints**: RTL layout support required, Eastern Arabic numerals, Hijri calendar calculation ≤ 50ms, offline-capable localization
**Scale/Scope**: ~65+ translatable strings, 6 main navigation tabs (Home, Prayer Times, Qibla, Quran, Athkar, More)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Planning Gate Check

| Principle | Requirement | Status | Notes |
|-----------|-------------|--------|-------|
| **I. Clean Architecture** | Feature follows data/domain/presentation | ✅ PASS | Localization touches all features; changes follow existing patterns |
| **II. Testing** | 80%+ coverage, TDD approach | ✅ PASS | Widget tests must verify RTL rendering and Arabic text |
| **III. UX & Accessibility** | RTL support, SemanticLabels, WCAG AA contrast | ✅ PASS | Spec requires RTL, Eastern Arabic numerals, Hijri dates |
| **IV. Performance** | Cold start ≤ 2s, transitions ≤ 300ms | ✅ PASS | Localization adds minimal overhead; locale lookup is O(1) |
| **V. Versioning** | MINOR version bump for new feature | ✅ PASS | Minor version for language default change |

### Constitution Requirements for This Feature

| Requirement | Implementation |
|-------------|----------------|
| RTL support (Principle III) | Already in place via flutter_localizations; verify all screens |
| Arabic text rendering (Principle III) | Use Amiri font via google_fonts for Arabic body text |
| SemanticLabels (Principle III) | Add Arabic + English semantic labels for accessibility |
| Text contrast (Principle III) | Already WCAG AA compliant; verify Arabic text maintains contrast |
| No hardcoded strings (CI Gate) | All strings must be in ARB files; CI enforces extraction |
| Memory baseline ≤ 80MB (Principle IV) | Localization files are small; no memory impact |

**Gate Status**: ✅ All principles satisfied. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/009-arabic-localization/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (via /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── l10n/                        # Localization files (primary change area)
│   ├── app_en.arb              # English translations (template)
│   ├── app_ar.arb              # Arabic translations (target)
│   ├── app_localizations.dart  # Generated
│   ├── app_localizations_en.dart
│   └── app_localizations_ar.dart
├── core/
│   ├── constants/               # AppConstants, AppColors, AppSpacing
│   ├── services/               # StorageService (language preference)
│   ├── navigation/             # AppShell (locale handling)
│   ├── theme/                  # AppTheme (RTL-aware text themes)
│   └── utils/                  # HijriDate utility (new/modified)
├── features/                   # All features reference AppLocalizations
│   ├── home/
│   ├── prayer_times/
│   ├── qibla/
│   ├── quran/
│   ├── athkar/
│   ├── settings/               # Language switcher UI
│   └── tasbih/
└── app.dart                    # MaterialApp locale configuration

test/
├── unit/
│   └── core/utils/hijri_date_test.dart  # Hijri date tests
├── widget/
│   └── [all features]/         # RTL + Arabic text rendering tests
└── integration/
    └── l10n/                    # Locale switching integration tests
```

**Structure Decision**: Use existing single-project structure. All localization changes are confined to `lib/l10n/` and consume through the existing `AppLocalizations` generated class. Each feature's presentation layer references localized strings via `AppLocalizations.of(context)!`.

## Complexity Tracking

> No constitution violations. Feature follows established patterns.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |