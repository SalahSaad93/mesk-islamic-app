# Research: Arabic Localization as Primary Language

**Feature**: 009-arabic-localization
**Date**: 2025-03-13
**Status**: Complete

## Summary

This research resolves all NEEDS CLARIFICATION items and documents technical decisions for implementing Arabic as the primary language in the Mesk Islamic App.

---

## Research Areas

### 1. Arabic Numerals: Eastern vs Western

**Question**: Which Arabic numeral system to use?

**Decision**: Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩)

**Rationale**:
- Primary audience is Arabic-speaking Muslims in Gulf, Levant, and most Arab countries
- More culturally authentic for an Islamic app
- Consistent with Hijri calendar presentation
- Eastern Arabic numerals are standard in religious/dates contexts

**Alternatives Considered**:
- Western Arabic numerals (0-9): Common in North Africa and tech contexts, but less authentic for religious content
- Mixed approach: Adds complexity without clear benefit

**Implementation**:
- Use `Intl.numberFormat('ar', symbols: <Eastern Arabic symbols>)` for number formatting
- Custom formatter for prayer times and counts
- Verify rendering in all numerical displays

---

### 2. Hijri Calendar Implementation

**Question**: Should Arabic mode use Hijri calendar, and how?

**Decision**: Hijri calendar as primary with Gregorian as secondary reference

**Rationale**:
- Hijri calendar is essential for Islamic religious observance
- Prayer times, religious dates, and Islamic events are Hijri-based
- Target audience expects Hijri dates in a religious app

**Alternatives Considered**:
- Gregorian only: Loses religious context
- Hijri only: May confuse users for civil/date scheduling
- Side-by-side dual: Takes more screen space

**Implementation**:
- Flutter's `Intl` package supports Hijri calendar via `Intl.dateFormat('ar', 'yMMMd', isHijri: true)`
- Alternatively use `hijri` package (pub.dev/packages/hijri) for accurate Islamic date calculation
- Display format: "15 Ramadān 1446 | March 5, 2025" in Arabic mode
- Use Eastern Arabic numerals for Hijri dates

**Dependencies**:
- `intl` package (already in pubspec.yaml: ^0.20.0)
- Consider adding `hijri` package for accurate Hijri conversion

---

### 3. Missing Translation Key Behavior

**Question**: What displays when a translation key is missing?

**Decision**: Display the translation key as placeholder (e.g., "home.prayer_times")

**Rationale**:
- Makes missing translations immediately visible during QA/testing
- Forces proper translation coverage before release
- Prevents silent fallback to English which hides gaps
- Aligns with Constitution CI gate: "all hardcoded strings extracted to .arb files"

**Alternatives Considered**:
- Fallback to English: Hides missing translations, creates inconsistent UX
- Empty space: Confusing for users, hard to debug

**Implementation**:
- ARB files are the source of truth
- No fallback chain (Arabic is primary, not secondary)
- Flutter's `Localizations` widget will show key if translation missing
- Pre-release validation script to check all keys have Arabic translations

---

### 4. RTL Layout Verification

**Question**: What screens need RTL layout verification?

**Research**: Analyzed all 6 main navigation screens and their sub-screens.

**Decision**: All screens require RTL verification with checklist

**Screens to Verify**:

| Screen | RTL Considerations |
|--------|-------------------|
| Home | Cards flow right-to-left, prayer times alignment, quick actions |
| Prayer Times | Time labels, method selection, location display |
| Qibla | Compass direction text, degree display |
| Quran | Surah list, verse numbers (Eastern Arabic), reading direction |
| Athkar | Text alignment, counter digits, progress indicators |
| Settings | Language selector, toggles, back arrow direction |
| Tasbih | Counter digits, button positions |

**Implementation Checklist**:
- [ ] Verify `TextDirection.rtl` applied in Arabic locale
- [ ] Verify navigation icons mirrored (back arrow points left)
- [ ] Verify list items flow start-to-end correctly
- [ ] Verify card padding/margins reversed
- [ ] Verify form inputs right-aligned

---

### 5: Language Preference Persistence

**Question**: Where and how to persist language preference?

**Decision**: Use existing `StorageService` with SharedPreferences

**Rationale**:
- Pattern already established for theme, prayer method, etc.
- SharedPreferences is cross-platform (Android/iOS)
- Persisted across app restarts and reinstalls (if backup enabled)

**Implementation**:
```dart
// In StorageService
static const String _languageKey = 'language_code';

Future<void> setLanguage(String langCode) async {
  await _prefs.setString(_languageKey, langCode);
}

String getLanguage() {
  return _prefs.getString(_languageKey) ?? 'ar'; // Default to Arabic
}
```

**Key Default**: Always return `'ar'` as default if not set, making Arabic the primary language.

---

### 6. Default Locale on Fresh Install

**Question**: How to ensure Arabic is default on fresh install?

**Decision**: Override system locale detection, default to Arabic

**Rationale**:
- Target audience is Arabic-speaking Muslims
- System locale might be English, French, or other languages
- FR-001: "MUST default to Arabic language on fresh installation, regardless of device system language"

**Implementation**:
```dart
// In app.dart MaterialApp
MaterialApp(
  locale: _locale ?? const Locale('ar'), // Explicit Arabic default
  supportedLocales: const [Locale('ar'), Locale('en')],
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...other config
)
```

**SettingsProvider Change**:
- Initialize `_locale` from StorageService
- If null/empty, default to `'ar'` (Arabic)
- Do NOT use `WidgetsBinding.instance.platformDispatcher.locale`

---

### 7: Language Switching Without App Restart

**Question**: How to switch language without restarting app?

**Decision**: Use Riverpod state management to rebuild UI with new locale

**Rationale**:
- FR-020: "MUST allow users to switch between Arabic and English without app restart"
- Flutter supports hot locale switching via `setState` or state management

**Implementation**:
```dart
// In SettingsNotifier
void setLanguage(String langCode) {
  _storage.setLanguage(langCode);
  state = state.copyWith(language: langCode);
  // SettingsProvider rebuilds MaterialApp with new locale
}

// In MaterialApp
App(
  locale: ref.watch(settingsProvider).language == 'ar' 
    ? const Locale('ar') 
    : const Locale('en'),
  // ...
)
```

**Session Behavior**:
- Language switch is instant (no restart required)
- All visible text updates immediately
- RTL/LTR layout updates immediately

---

## Dependencies Matrix

| Dependency | Current Version | Purpose | Change Needed |
|------------|-----------------|---------|---------------|
| flutter_localizations | SDK | l10n support | None |
| intl | ^0.20.0 | Date/number formatting | None |
| flutter_riverpod | ^2.6.1 | State management | None |
| shared_preferences | ^2.3.3 | Persistent storage | None |
| hijri | (optional) | Hijri calendar | Consider adding |

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Missing Arabic translations | Pre-release validation script + CI gate |
| RTL layout bugs | Widget tests for each screen in Arabic |
| Eastern Arabic numeral rendering | Integration tests for prayer times/counts |
| Hijri date accuracy | Use established `hijri` package or validate calculations |
| Regression after changes | Maintain English ARB as template, sync keys |

---

## Acceptance Criteria from Research

1. Fresh install shows Arabic UI immediately
2. All screens render correctly in RTL
3. Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) display in all numerical contexts
4. Hijri dates show prominently with Gregorian reference
5. Language preference persists across restarts
6. Language switches instantly without app restart
7. Missing translation keys show as visible placeholders
8. Widget tests verify RTL and Arabic text rendering