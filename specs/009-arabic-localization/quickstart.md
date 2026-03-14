# Quickstart: Arabic Localization Implementation

**Feature**: 009-arabic-localization
**Date**: 2025-03-13

## Overview

This guide provides a rapid implementation path for making Arabic the primary language in the Mesk Islamic App.

---

## Prerequisites

- [ ] Flutter SDK 3.10.4+ installed
- [ ] Project dependencies up to date (`flutter pub get`)
- [ ] Familiarity with ARB localization format
- [ ] Understanding of Riverpod state management

---

## Quick Implementation Steps

### Step 1: Update Default Language (5 minutes)

**File**: `lib/core/services/storage_service.dart`

```dart
// Change default language to Arabic
String getLanguage() {
  return _prefs.getString(_languageKey) ?? 'ar'; // Default to Arabic
}
```

**File**: `lib/app.dart`

```dart
// Ensure Arabic is default locale
MaterialApp(
  locale: _getLocale(), // Implement to default to 'ar'
  // ...
)

Locale _getLocale() {
  final lang = ref.read(settingsProvider).language;
  return Locale(lang ?? 'ar'); // Default to Arabic
}
```

---

### Step 2: Set ARB File Template Language (2 minutes)

**File**: `l10n.yaml`

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb  # English remains template
output-localization-file: app_localizations.dart
output-class: AppLocalizations
# Ensure Arabic is listed first in supportedLocales
```

**File**: `lib/app.dart` (update supportedLocales order)

```dart
supportedLocales: const [
  Locale('ar'), // Arabic first (primary)
  Locale('en'), // English second
],
```

---

### Step 3: Add/Verify Arabic Translations (30-60 minutes)

**File**: `lib/l10n/app_ar.arb`

1. Compare keys between `app_en.arb` and `app_ar.arb`
2. Ensure every English key has an Arabic translation
3. Use Islamic terminology correctly (not literal translations)

**Example proper Islamic terms**:

| English Key | Arabic Translation |
|-------------|-------------------|
| `prayerFajr` | الفجر |
| `prayerSunrise` | الشروق |
| `prayerDhuhr` | الظهر |
| `prayerAsr` | العصر |
| `prayerMaghrib` | المغرب |
| `prayerIsha` | العشاء |

**Run**:
```bash
flutter gen-l10n
```

---

### Step 4: Implement Eastern Arabic Numerals (20 minutes)

**Create**: `lib/core/utils/localized_number_formatter.dart`

```dart
import 'package:intl/intl.dart';

class LocalizedNumberFormatter {
  static String format(int number, Locale locale) {
    if (locale.languageCode == 'ar') {
      // Eastern Arabic numerals
      return _toEasternArabic(number);
    }
    return number.toString();
  }
  
  static String _toEasternArabic(int number) {
    const easternArabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) {
      final digit = int.tryParse(d);
      return digit != null ? easternArabicNumerals[digit] : d;
    }).join();
  }
}
```

**Usage in widgets**:
```dart
Text(LocalizedNumberFormatter.format(prayerTime.minute, Localizations.localeOf(context)))
```

---

### Step 5: Add Hijri Date Support (15 minutes)

**Add dependency** (optional but recommended):
```yaml
# pubspec.yaml
dependencies:
  hijri: ^3.0.0
```

**Create**: `lib/core/utils/hijri_date_formatter.dart`

```dart
import 'package:hijri/hijri.dart';

class HijriDateFormatter {
  static String format(DateTime gregorian, Locale locale) {
    if (locale.languageCode != 'ar') {
      // English uses Gregorian
      return DateFormat.yMMMd('en').format(gregorian);
    }
    
    // Arabic uses Hijri
    final hijri = HijriCalendar.fromDate(gregorian);
    return '${_toEasternArabic(hijri.hDay)} ${_hijriMonthName(hijri.month)} ${_toEasternArabic(hijri.hYear)}';
  }
  
  static String _hijriMonthName(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    return months[month - 1];
  }
}
```

---

### Step 6: Verify RTL Layout (15 minutes)

**Test each screen**:

```bash
# Run app in Arabic
flutter run --locale=ar
```

**Checklist per screen**:
- [ ] TextDirection.rtl applied
- [ ] Navigation icons mirrored (back arrow points left)
- [ ] Lists flow from right to left
- [ ] Cards and padding reversed
- [ ] Form inputs right-aligned

**Fix RTL issues**:
```dart
// Use Directionality widget where needed
Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
)
```

---

### Step 7: Add Language Switcher UI (10 minutes)

**File**: `lib/features/settings/presentation/settings_screen.dart`

```dart
// Add language selector
ListTile(
  title: Text(AppLocalizations.of(context)!.settingsLanguage),
  subtitle: Text(_getLanguageName(ref.watch(settingsProvider).language)),
  onTap: () => _showLanguageDialog(context, ref),
),

void _showLanguageDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.settingsLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('العربية'),
            value: 'ar',
            groupValue: ref.read(settingsProvider).language,
            onChanged: (v) => _setLanguage(context, ref, v!),
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: ref.read(settingsProvider).language,
            onChanged: (v) => _setLanguage(context, ref, v!),
          ),
        ],
      ),
    ),
  );
}

void _setLanguage(BuildContext context, WidgetRef ref, String langCode) {
  ref.read(settingsProvider.notifier).setLanguage(langCode);
  Navigator.pop(context);
}
```

---

## Testing Commands

```bash
# Generate localization files
flutter gen-l10n

# Run all tests
flutter test

# Run specific localization tests
flutter test test/unit/core/utils/localized_number_formatter_test.dart

# Run widget tests with Arabic locale
flutter test --locale=ar test/widget/

# Integration test for language switching
flutter test test/integration/l10n/language_switch_test.dart
```

---

## Verification Checklist

- [ ] Fresh install shows Arabic UI
- [ ] All 6 navigation tabs show Arabic labels
- [ ] Prayer times display in Eastern Arabic numerals
- [ ] Hijri dates appear in Arabic mode
- [ ] Language switcher works without restart
- [ ] RTL layout correct on all screens
- [ ] Language preference persists after app restart
- [ ] No English text visible in Arabic mode

---

## Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| Still seeing English on fresh install | Check `StorageService.getLanguage()` default |
| Numbers still showing 0-9 | Verify `LocalizedNumberFormatter` is used |
| RTL not applied | Add `Directionality` widget or check MaterialApp locale |
| Translation key shown instead of text | Add missing translation to `app_ar.arb` |
| Hijri date incorrect | Verify `hijri` package version and calendar calculation |

---

## Estimated Time

| Task | Duration |
|------|----------|
| Default language setup | 5 min |
| ARB file updates | 30-60 min |
| Eastern Arabic numerals | 20 min |
| Hijri date support | 15 min |
| RTL verification | 15 min |
| Language switcher UI | 10 min |
| Testing | 20 min |
| **Total** | **2-2.5 hours** |