# Implementation Plan: Localization and Location Fixes

**Branch**: `004-i18n-location-fixes` | **Date**: 2026-03-11 | **Spec**: [Link to Spec](./spec.md)
**Input**: Feature specification from `/specs/004-i18n-location-fixes/spec.md`

## Summary

Update the default language mechanism in `StorageService` to prioritize Arabic over English. Identify and add missing structural keys inside `.arb` translation files for all areas of the application. Add a dedicated UI presentation flow for capturing location permission rationally before issuing `Geolocator.requestPermission()`.

## Technical Context

**Language/Version**: Dart 3.10.4 / Flutter 3.10.4
**Primary Dependencies**: `flutter_localizations`, `flutter_riverpod`, `geolocator`, `permission_handler`
**Storage**: `shared_preferences`
**Testing**: `flutter_test` (Unit/Integration/Widget)
**Target Platform**: Android, iOS
**Project Type**: Mobile App
**Performance Goals**: N/A for these minimal UI checks and initialization files.
**Constraints**: Location request rationale must block `getCurrentLocation` until UI interaction completes.
**Scale/Scope**: Localization update affects entire UI text. Location flow affects mainly initial setup or `PrayerTimesScreen`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Clean Architecture with Separation of Concerns**: Yes. The location dialog will be handled in the presentation layer and `LocationService` domain service remains decoupled from UI.
- **Comprehensive Testing at Three Levels**: Yes. Widget tests will need to accommodate the new dialog step, but can be sufficiently verified.
- **Consistent User Experience & Accessibility**: Yes. The rationale prompt improves transparency, and Arabic default guarantees correct RTL behaviors for our target users right off the bat.
- **Mobile Performance & Resource Constraints**: Yes.
- **Stability & Versioning Discipline**: Yes.

## Project Structure

### Documentation (this feature)

```text
specs/004-i18n-location-fixes/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── services/
│       ├── location_service.dart
│       └── storage_service.dart
├── features/
│   └── quran/
│       └── presentation/
│           └── widgets/
│               └── ...
└── l10n/
    ├── app_en.arb
    └── app_ar.arb
```

**Structure Decision**: The project uses a Flutter mobile app structure. Modifications will be contained inside the existing `core/services` directory (for location and storage behavior) and the `l10n/` resource files. The presentation layer of the affected screens will also be adjusted.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *None* | | |
