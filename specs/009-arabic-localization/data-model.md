# Data Model: Arabic Localization

**Feature**: 009-arabic-localization
**Date**: 2025-03-13

## Overview

This feature primarily modifies configuration and content rather than introducing new entities. The data model focuses on language preference storage and localization file structure.

---

## Entities

### LanguagePreference

User's selected language, persisted locally.

| Field | Type | Description | Validation |
|-------|------|-------------|-------------|
| `languageCode` | String | ISO 639-1 language code | Must be 'ar' or 'en' |
| `lastUpdated` | DateTime | When preference was last changed | Auto-set on change |

**Storage**: SharedPreferences key `language_code`

**Default Value**: `'ar'` (Arabic)

**State Management**: Held in `SettingsState.language` via Riverpod `NotifierProvider`

---

### LocaleConfiguration

App-level locale configuration (runtime only, derived from LanguagePreference).

| Field | Type | Description |
|-------|------|-------------|
| `locale` | Locale | Current Flutter locale object |
| `textDirection` | TextDirection | LTR or RTL |
| `numeralSystem` | NumeralSystem | Eastern Arabic or Western |

**Derived Values**:

| languageCode | locale | textDirection | numeralSystem |
|--------------|--------|---------------|---------------|
| `ar` | Locale('ar') | TextDirection.rtl | NumeralSystem.easternArabic |
| `en` | Locale('en') | TextDirection.ltr | NumeralSystem.western |

---

### TranslationString

Key-value pair in ARB (Application Resource Bundle) format.

**File Structure**:

```
lib/l10n/
├── app_en.arb    # Template file (English)
├── app_ar.arb    # Arabic translations
└── app_localizations*.dart  # Generated Dart files
```

**Entry Format** (in ARB file):

```json
{
  "homeTitle": "الرئيسية",
  "@homeTitle": {
    "description": "Home screen title",
    "type": "text"
  }
}
```

**Key Naming Convention**:

| Prefix | Screen/Feature | Examples |
|--------|----------------|----------|
| `home` | Home screen | `homeTitle`, `homePrayerTimes` |
| `prayer` | Prayer Times | `prayerFajr`, `prayerSunrise` |
| `qibla` | Qibla | `qiblaTitle`, `qiblaDegrees` |
| `quran` | Quran | `quranTitle`, `quranSurah` |
| `athkar` | Athkar | `athkarTitle`, `athkarMorning` |
| `settings` | Settings | `settingsTitle`, `settingsLanguage` |
| `common` | Shared | `commonSave`, `commonCancel` |
| `error` | Errors | `errorLocation`, `errorNetwork` |

---

## State Transitions

### Language Switch Flow

```
[Current Language] --setLanguage('ar'/'en')--> [New Language]
                                               |
                                               v
                                    [Update SettingsState]
                                               |
                                               v
                                    [Persist to SharedPreferences]
                                               |
                                               v
                                    [Rebuild MaterialApp with new Locale]
                                               |
                                               v
                                    [All widgets rebuild with new translations]
```

### Fresh Install Flow

```
[App Launch] --> [Check SharedPreferences for language_code]
                              |
                              v
                        [Key exists?]
                       /            \
                      NO            YES
                      |              |
                      v              v
              [Default to 'ar']  [Use stored value]
                      |              |
                      \            /
                       \          /
                        v
                  [Set Locale in MaterialApp]
                        |
                        v
                  [Load AppLocalizations]
                        |
                        v
                  [Render UI in selected language]
```

---

## Validation Rules

### ARB File Validation

| Rule | Description |
|------|-------------|
| All keys have translations | Every key in `app_en.arb` must have corresponding value in `app_ar.arb` |
| No empty values | Translation values cannot be empty strings |
| Placeholders preserved | Placeholders like `{count}`, `{name}` must exist in all language variants |
| Proper escaping | Quotes, newlines properly escaped in JSON |

### Language Preference Validation

| Rule | Description |
|------|-------------|
| Valid codes only | `languageCode` must be 'ar' or 'en' |
| Persistence required | Preference must persist across app restarts |
| Default on fresh install | Must default to 'ar' when no preference stored |

---

## Data Volume Estimates

| Data | Count | Size |
|------|-------|------|
| Translation strings | ~65-80 | ~15 KB per language |
| Language preference | 1 key | ~20 bytes |
| Generated Dart | ~5 files | ~50 KB |

**Total Localization Data**: < 100 KB (negligible storage impact)

---

## Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                      SettingsState                          │
│  - language: String ('ar' | 'en')                          │
│  - isDarkMode: bool                                         │
│  - ...                                                      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ persisted via
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    StorageService                          │
│  - SharedPreferences instance                               │
│  - getLanguage(): String                                    │
│  - setLanguage(code): Future<void>                         │
└────────────────────────┘
                         │
                         │ provides locale to
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      MaterialApp                           │
│  - locale: Locale(LanguagePreference.language)            │
│  - localizationsDelegates: [AppLocalizations, ...]         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ loads
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   AppLocalizations                         │
│  - Generated from app_*.arb files                          │
│  - Provides .homeTitle, .prayerFajr, etc.                   │
└─────────────────────────────────────────────────────────────┘
```