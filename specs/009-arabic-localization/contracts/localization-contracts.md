# Localization Contracts

**Feature**: 009-arabic-localization
**Date**: 2025-03-13

## Overview

This document defines the contracts for the localization system. Since this is a mobile app (not a library or API), contracts focus on the translation file format and the localization access API.

---

## Contract 1: ARB File Format

The Application Resource Bundle (ARB) format is the contract between translators and the application code.

### File Locations

| File | Purpose |
|------|---------|
| `lib/l10n/app_en.arb` | Template file (English) - source of truth |
| `lib/l10n/app_ar.arb` | Arabic translations |

### Entry Schema

Each translation entry follows this structure:

```json
{
  "translationKey": "Translated text {placeholder}",
  "@translationKey": {
    "description": "Human-readable description for translators",
    "type": "text | plural | select",
    "placeholders": {
      "placeholder": {
        "type": "String | int | DateTime",
        "example": "example value"
      }
    }
  }
}
```

### Required Fields

| Field | Required | Description |
|-------|----------|-------------|
| `translationKey` | Yes | The translated string value |
| `@translationKey.description` | Yes | Description for translators |
| `@translationKey.type` | No | Defaults to "text" |
| `@translationKey.placeholders` | No | Required if string contains `{}` |

### Example Entries

```json
{
  "homeTitle": "الرئيسية",
  "@homeTitle": {
    "description": "Home screen title in bottom navigation"
  },
  
  "prayerTimeMethod": "طريقة الحساب: {method}",
  "@prayerTimeMethod": {
    "description": "Prayer time calculation method label",
    "placeholders": {
      "method": {
        "type": "String",
        "example": "أم القرى"
      }
    }
  },
  
  "settingsLanguage": "اللغة",
  "@settingsLanguage": {
    "description": "Language setting label"
  }
}
```

---

## Contract 2: AppLocalizations API

The generated `AppLocalizations` class provides type-safe access to translations.

### Access Pattern

```dart
// In widget code
final l10n = AppLocalizations.of(context)!;

// Access translation
Text(l10n.homeTitle)

// With placeholder
Text(l10n.prayerTimeMethod(methodName))
```

### Generated Class Interface

```dart
class AppLocalizations {
  // Get instance from context
  static AppLocalizations? of(BuildContext context);
  
  // Locale for this instance
  Locale get locale;
  
  // Translation getters (generated from ARB)
  String get homeTitle;
  String get settingsTitle;
  String get prayerTitle;
  String prayerTimeMethod(String method);
  String qiblaDegrees(num degrees);
  // ... all other translations
  
  // LocalizationsDelegate for MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate;
}
```

---

## Contract 3: Language Preference Storage

The storage contract for persisting user's language preference.

### StorageService Interface

```dart
abstract class LanguageStorage {
  /// Gets the stored language code.
  /// Returns 'ar' (Arabic) if no preference is stored.
  Future<String> getLanguage();
  
  /// Persists the language preference.
  /// Must be 'ar' or 'en'.
  Future<void> setLanguage(String languageCode);
}
```

### SharedPreferences Keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `language_code` | String | `'ar'` | User's language preference |

---

## Contract 4: Locale Resolution

How the app determines which locale to use.

### Resolution Priority

1. **Stored preference**: If user has previously set language, use that
2. **Default**: If no preference, use Arabic (`'ar'`)

### Resolution Logic

```dart
Locale _resolveLocale(String? storedLanguage) {
  final language = storedLanguage ?? 'ar'; // Default to Arabic
  return Locale(language);
}
```

### NOT Using System Locale

**Important**: The app does NOT follow the device's system language. It defaults to Arabic and only changes based on explicit user preference.

```dart
// DO NOT use:
// locale: WidgetsBinding.instance.platformDispatcher.locale

// USE:
// locale: _resolveLocale(storageService.getLanguage())
```

---

## Contract 5: Numeral Formatting

Contract for displaying numbers in different locales.

### Numeral System Rules

| Locale | Numeral System | Characters |
|--------|-----------------|------------|
| Arabic (`ar`) | Eastern Arabic | ٠ ١ ٢ ٣ ٤ ٥ ٦ ٧ ٨ ٩ |
| English (`en`) | Western Arabic | 0 1 2 3 4 5 6 7 8 9 |

### Formatter Interface

```dart
class LocalizedNumberFormatter {
  /// Formats an integer for display.
  /// Uses Eastern Arabic numerals for Arabic locale.
  String format(int number, Locale locale);
  
  /// Formats a decimal for display.
  String formatDecimal(double number, Locale locale);
  
  /// Formats a count with appropriate numerals.
  String formatCount(int count, Locale locale);
}
```

---

## Contract 6: Hijri Date Formatting

Contract for displaying dates in Hijri calendar for Arabic locale.

### Date Display Rules

| Locale | Calendar | Format |
|--------|----------|--------|
| Arabic (`ar`) | Hijri (primary) | "15 رمضان 1446" |
| Arabic (`ar`) | Gregorian (secondary) | "5 مارس 2025" |
| English (`en`) | Gregorian | "March 5, 2025" |

### Date Formatter Interface

```dart
class LocalizedDateFormatter {
  /// Formats date for display.
  /// Arabic: Hijri calendar
  /// English: Gregorian calendar
  String formatDate(DateTime date, Locale locale);
  
  /// Formats date with both calendars (Arabic only).
  /// Returns null for English locale.
  String? formatDualDate(DateTime date, Locale locale);
}
```

---

## Contract 7: RTL Layout Direction

Contract for text direction based on locale.

### Direction Rules

| Locale | TextDirection | Layout Direction |
|--------|---------------|------------------|
| Arabic (`ar`) | RTL | Right-to-left |
| English (`en`) | LTR | Left-to-right |

### Direction Provider

```dart
TextDirection getTextDirection(Locale locale) {
  return locale.languageCode == 'ar' 
    ? TextDirection.rtl 
    : TextDirection.ltr;
}
```

---

## Validation Commands

### Pre-Commit Validation

```bash
# Check all keys exist in both languages
flutter gen-l10n

# Verify no missing translations (script)
dart run tools/check_translations.dart
```

### ARB Key Coverage Check

All keys in `app_en.arb` must exist in `app_ar.arb`:

```json
// app_en.arb
{
  "newFeatureTitle": "New Feature"
}

// app_ar.arb must have:
{
  "newFeatureTitle": "ميزة جديدة"
}
```

If a key is missing in Arabic:
- Build will succeed
- Runtime will display the key name (e.g., `"newFeatureTitle"`)
- This is intentional to surface missing translations