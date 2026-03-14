# Research & Decisions: Localization and Location Fixes

## 1. Default Language Settings

**Decision**: Change the fallback language in `StorageService` to `'ar'`.

**Rationale**: The `StorageService` currently defines `String get language => _prefs.getString('language') ?? 'en';`. To fulfill FR-001 (App defaults to Arabic), this fallback must simply be changed to `'ar'`. Since new installations won't have the `'language'` key set in `SharedPreferences`, they will immediately default to Arabic.

**Alternatives considered**:
- Checking the device system locale via `WidgetsBinding.instance.window.locale` and keeping it if it's Arabic, otherwise defaulting to Arabic. Decided against because the spec explicitly states "regardless of the device's system language".
- Creating an onboarding screen. Overkill for this specific requirement, which just requires the default to be set to Arabic.

## 2. Comprehensive Translation Coverage

**Decision**: Audit and update `app_en.arb` and `app_ar.arb` with all required translation keys, including those for location permission dialogs, error states, and empty states.

**Rationale**: `app_ar.arb` lacks several keys and there are hardcoded English strings in some areas of the app. Missing translations must be identified and added to ensure 100% Arabic coverage as required by SC-001.

**Alternatives considered**: N/A, this is a standard localization task following the `flutter_localizations` pattern already present in the codebase.

## 3. Location Permission Flow

**Decision**: Introduce a localized rationale dialog in the application flow before triggering the OS-level `Geolocator.requestPermission()`. 

**Rationale**: The current `LocationService` handles permission requests internally (`getCurrentLocation`). Since `LocationService` is a domain service, it does not have access to the `BuildContext` required to show an explanatory rationale dialog (FR-004). We must separate the permission rationale check into the presentation layer (e.g., `PrayerTimesScreen` or a dedicated onboarding/permission widget) that checks `Geolocator.checkPermission()`. If permission is denied, the UI shows the rationale dialog. Upon user agreement, it calls the `Geolocator.requestPermission()`. If denied forever, we show instructions on how to enable it from settings.

**Alternatives considered**:
- Passing a `BuildContext` to `LocationService`. Rejected because passing UI context to domain services violates Clean Architecture principles (Rule I).
- Using a global navigator key to show dialogs. Rejected as it's an anti-pattern and often leads to context issues.

## 4. Unresolved "Needs Clarification"
*All initial uncertainties surrounding the implementation of the UI rationale dialog and default language have been resolved.*
