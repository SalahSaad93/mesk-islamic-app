# Feature Specification: Arabic Localization as Primary Language

**Feature Branch**: `009-arabic-localization`  
**Created**: 2025-03-13  
**Status**: Draft  
**Input**: User description: "fully translate all app in arabic and make it the main language"

## Clarifications

### Session 2025-03-13

- Q: Which numeral system should be used in Arabic mode? → A: Eastern Arabic Numerals (٠١٢٣٤٥٦٧٨٩)
- Q: Should Arabic mode display dates in Hijri calendar? → A: Hijri calendar primary, Gregorian as secondary
- Q: If translation key is missing in Arabic file, what displays? → A: Show the translation key as placeholder for debugging

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Arabic Default Experience (Priority: P1)

A new user installs the app for the first time. When they open it, the entire interface displays in Arabic with proper right-to-left layout, without requiring any configuration changes.

**Why this priority**: This is the core requirement - Arabic must be the default language for all users, ensuring the target audience (Arabic-speaking Muslims) has immediate access to the app in their native language.

**Independent Test**: Can be fully tested by installing the app on a fresh device/simulator and verifying all screens display Arabic text with RTL layout from first launch.

**Acceptance Scenarios**:

1. **Given** a new user installs the app, **When** they launch it for the first time, **Then** all UI text displays in Arabic
2. **Given** a new user launches the app, **When** viewing any screen, **Then** the layout flows right-to-left (RTL)
3. **Given** the app is freshly installed, **When** checking language settings, **Then** Arabic is shown as the selected/default language

---

### User Story 2 - Complete Arabic Translation Coverage (Priority: P1)

A user navigates through all features of the app (Home, Prayer Times, Qibla, Quran, Athkar, Settings, Tasbih) and finds every piece of user-facing text properly translated into Arabic with appropriate Islamic terminology.

**Why this priority**: Incomplete translations would create a poor user experience. Users expect a professional, fully-localized app in their primary language.

**Independent Test**: Can be tested by systematically visiting every screen, dialog, error message, and notification, verifying Arabic text appears correctly.

**Acceptance Scenarios**:

1. **Given** a user opens the Home screen, **When** viewing all elements, **Then** all labels, buttons, and text are in Arabic
2. **Given** a user opens Prayer Times screen, **When** viewing prayer names and times, **Then** all content displays in Arabic with correct Islamic terminology
3. **Given** a user opens Settings, **When** viewing all settings options, **Then** all labels and descriptions are in Arabic
4. **Given** a user triggers any error state or dialog, **When** the dialog appears, **Then** all error messages and buttons are in Arabic
5. **Given** a user views notification content, **When** a prayer reminder notification appears, **Then** all notification text is in Arabic

---

### User Story 3 - Arabic Language Preference (Priority: P2)

A user wants to switch between Arabic and English languages. They can change the app language from Settings, and their preference persists across app restarts and device reboots.

**Why this priority**: While Arabic is the default, supporting user choice ensures accessibility for bilingual users or those learning the language. This is a secondary but important user need.

**Independent Test**: Can be tested by navigating to Settings, changing language, restarting the app, and verifying the preference was saved.

**Acceptance Scenarios**:

1. **Given** a user is in Settings screen, **When** they select English language option, **Then** the entire app switches to English with LTR layout
2. **Given** a user is in Settings screen, **When** they select Arabic language option, **Then** the entire app switches to Arabic with RTL layout
3. **Given** a user has changed language preference, **When** they close and reopen the app, **Then** the app displays in the previously selected language
4. **Given** a user has selected Arabic as language, **When** they reinstall the app, **Then** the app defaults to Arabic (not system language)

---

### User Story 4 - RTL Layout Support (Priority: P1)

A user views any screen in Arabic mode. All UI elements (text direction, icon positions, navigation flow, form inputs) are mirrored appropriately for right-to-left reading direction.

**Why this priority**: Proper RTL support is essential for Arabic reading comfort. Misaligned text or icons would create usability issues.

**Independent Test**: Can be tested by switching to Arabic and verifying every screen has properly mirrored layout compared to English mode.

**Acceptance Scenarios**:

1. **Given** the app is in Arabic mode, **When** viewing the bottom navigation bar, **Then** tabs appear in RTL order (Home on right, More on left)
2. **Given** the app is in Arabic mode, **When** viewing any list or card layout, **Then** content flows from right to left
3. **Given** the app is in Arabic mode, **When** entering text in input fields, **Then** text is right-aligned and cursor starts on the right
4. **Given** the app is in Arabic mode, **When** viewing back navigation icons, **Then** arrows point left (reversed from English)

---

### Edge Cases

- What happens when a user's device system language is set to a non-Arabic, non-English language (e.g., French, Spanish)? The app should default to Arabic, not follow system language.
- How does the app handle dynamic content from external sources (e.g., Quran text, Athkar content)? These should remain in their original Arabic script regardless of app language setting.
- What happens if translation strings are missing for a new feature? The missing translation keys should be displayed as placeholders (e.g., "home.prayer_times") to make gaps visible during QA/testing.
- How does the app handle numbers (prayer times, dates)? Arabic numerals should be used consistently throughout the Arabic interface.
- What happens when sharing content (e.g., sharing an Athkar)? The shared content should be in Arabic when the app is in Arabic mode.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: App MUST default to Arabic language on fresh installation, regardless of device system language
- **FR-002**: App MUST display all user interface text in Arabic when Arabic language is selected
- **FR-003**: App MUST apply right-to-left (RTL) layout direction when Arabic language is active
- **FR-004**: App MUST persist user's language preference across app sessions
- **FR-005**: App MUST provide language selection option in Settings screen
- **FR-006**: App MUST support both Arabic and English languages
- **FR-007**: App MUST maintain Arabic as the default language preference after reinstallation
- **FR-008**: App MUST translate all navigation labels (Home, Prayer Times, Qibla, Quran, Athkar, More/Settings)
- **FR-009**: App MUST translate all settings labels and descriptions
- **FR-010**: App MUST translate all permission request dialogs and explanations
- **FR-011**: App MUST translate all error messages and user-facing alerts
- **FR-012**: App MUST translate all notification content for prayer reminders
- **FR-013**: App MUST translate all button labels (Save, Cancel, Confirm, Share, etc.)
- **FR-014**: App MUST use proper Islamic terminology in Arabic (not literal translations of English Islamic terms)
- **FR-015**: App MUST handle RTL text alignment in all input fields and text displays
- **FR-016**: App MUST mirror all directional icons and navigation indicators for RTL
- **FR-017**: App MUST maintain Quranic text in original Arabic script regardless of app language selection
- **FR-018**: App MUST maintain Athkar content in Arabic regardless of app language selection (as supplications are in Arabic)
- **FR-019**: App MUST use Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) consistently throughout the interface when in Arabic mode
- **FR-020**: App MUST allow users to switch between Arabic and English without app restart
- **FR-021**: App MUST display Hijri (Islamic) calendar dates prominently in Arabic mode, with Gregorian dates shown as secondary reference
- **FR-022**: App MUST use Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) for Hijri dates and all date/time displays in Arabic mode
- **FR-023**: App MUST display missing translation keys as placeholders (not fall back to English) to ensure translation gaps are visible

### Key Entities

- **Language Preference**: User's selected language (Arabic or English), persisted in local storage
- **Translation String**: Key-value pairs mapping internal string identifiers to human-readable Arabic/English text
- **Locale Configuration**: App-level locale setting that determines text direction (LTR/RTL) and text content

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of user-facing strings have Arabic translations (verified by audit of all ARB file entries)
- **SC-002**: New users see Arabic interface immediately on first launch without any configuration
- **SC-003**: Users can navigate all 6 main tabs and find fully translated content in Arabic
- **SC-004**: Language preference persists correctly across 100% of app restarts (verified by automated testing)
- **SC-005**: RTL layout is applied consistently across all screens when Arabic is selected
- **SC-006**: Users can complete primary tasks (check prayer times, find Qibla, read Quran/Dua) entirely in Arabic interface
- **SC-007**: Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) appear in all numerical displays (prayer times, dates, counts) when in Arabic mode
- **SC-008**: Zero English strings visible in Arabic mode during manual QA testing of all screens
- **SC-009**: App correctly handles both Arabic-first users and bilingual users switching languages
- **SC-010**: All prayer notification content displays in Arabic when app language is Arabic
- **SC-011**: Hijri (Islamic) calendar dates display prominently in Arabic mode with accurate calculation

## Assumptions

- The existing ARB-based localization system will continue to be used (no major architectural changes needed)
- Arabic translations for ~65 existing English strings will need to be verified/completed
- The app already has RTL support framework in place (verified in exploration)
- New users are expected to be Arabic-speaking Muslims (primary target audience)
- Bilingual users who prefer English have the option to switch languages
- Islamic content (Quran verses, Athkar) remains in Arabic regardless of interface language
- Date/time formatting will follow Arabic conventions when in Arabic mode
- Currency/number formatting for any future features should use Arabic numerals in Arabic mode