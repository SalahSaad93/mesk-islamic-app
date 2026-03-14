# Quickstart Guide: Localization and Location Fixes

This quickstart explains how to verify the new localization and location flow introduced in feature `004-i18n-location-fixes`.

### Prerequisites

- A Flutter 3.10.4 environment (or later) connected to a real device or a fully functional Android/iOS emulator with Location Services enabled.

### Flow 1: Verifying Default Arabic Content

1. **Delete any old application data prior to testing:**
    - On Android, navigate to `Settings > Apps > Mesk Islamic App > Storage`, and clear both Data and Cache.
    - Alternatively, simply uninstall the app from the device and run a fresh `flutter run`.
2. **Launch the application:** Keep the system-wide settings in `English` before launching. Upon app entry, you will be directed to the main views (Prayers, Quran, Tasbih).
3. **Outcome:** Overlook the strings displayed on the UI. The application should now uniformly load its `app_ar.arb` layout translations. If there is English text lingering, there is a missing key.

### Flow 2: Testing the Location Prompt

1. Head to `Settings > Apps > Mesk Islamic App > Permissions` and ensure `Location` permission is set to "Ask Every Time" or "Not allowed".
2. Open the application and go to the `Prayers` tab (Or any feature triggering the `locationServiceProvider`).
3. **Outcome:** A localizable dialog should appear detailing the reason the application needs your location ("Using location to accurately calculate your daily prayers").
    - If you accept, the `Geolocator` requests the OS permission.
    - If you decline, a reasonable fallback is triggered ensuring the application doesn't completely break. Notice the "fallback error" is appropriately displayed in Arabic.
