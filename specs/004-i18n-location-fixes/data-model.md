# Data Model: Localization and Location Fixes

## 1. Local Storage

The application relies on SharedPreferences to persist local user settings and preferences. Key changes related to this feature involve adjusting the fallback.

**Relevant `StorageService` keys:**

*   `language`: (String)
    *   **Description**: Stores the locale code.
    *   **Type**: `String`
    *   **Validation**: Must be a valid ISO 639-1 language code supported by the app (e.g., `'en'` or `'ar'`).
    *   **Fallback Transition**: Initial accesses where the key doesn't exist will return `'ar'` instead of `'en'`.

## 2. Location Entities

The application retrieves location data based on user constraints. There is no persistent database schema change, but the domain layer deals with `LocationResult`.

**Entity**: `LocationResult`
*   **Attributes**:
    *   `latitude` (double)
    *   `longitude` (double)
    *   `name` (String, e.g. "Dubai, AE")
*   **State Transitions**: Handled by the Geocoding plugin. If permission is denied, it falls back to predefined default coordinates (e.g., Mecca instead of NY now that the app's default logic focuses on Arabic).

## 3. Translation Keys

The translation layer adds the requirement for comprehensive JSON/ARB keys.

**Relevant `.arb` additions (Shared across `app_en.arb` and `app_ar.arb`):**
*   `locationPermissionTitle`: Title of the rationale dialog.
*   `locationPermissionMessage`: Body of the rationale dialog explaining why location is needed.
*   `locationPermissionGrant`: Button to grant permission.
*   `locationPermissionDeny`: Button to deny.
*   `openSettingsMessage`: Instructions indicating the user must navigate to Device Settings to toggle the permission permanently.
