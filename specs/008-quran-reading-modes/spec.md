# Feature Specification: Quran Reading Modes

**Feature Branch**: `008-quran-reading-modes`
**Created**: 2026-03-13
**Status**: Draft
**Input**: Revamp the Quran reading screen to support two distinct reading modes: Verse Mode and Full Quran Mode.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Full Quran Mushaf Reading (Priority: P1)

A user wants to read the Quran continuously in a Mushaf-style layout, similar to the Khatma app. They open the Quran feature, select "Full Quran" mode, and begin scrolling through pages of Quran text displayed in authentic Mushaf typography. The interface is clean and distraction-free, allowing long uninterrupted reading sessions. When they close the app and return later, they resume exactly where they left off. Their reading progress toward completing a full Khatma is tracked and visible.

**Why this priority**: This is the core differentiating feature — the Khatma-style continuous reading experience is the primary value proposition and serves the majority use case of daily Quran reading.

**Independent Test**: Can be fully tested by opening the Quran, entering Full Quran mode, scrolling through multiple pages, closing and reopening the app, and verifying the reading position is restored.

**Acceptance Scenarios**:

1. **Given** a user opens the Quran feature, **When** they select Full Quran mode, **Then** they see a Mushaf-style page display where they can swipe between pages (like turning pages of a physical Quran).
2. **Given** a user is reading in Full Quran mode on page 200, **When** they close the app and reopen it later, **Then** they are returned to page 200 with their exact scroll position restored.
3. **Given** a user has read 150 out of 604 pages, **When** they view their progress, **Then** they see their Khatma completion percentage (approximately 25%) and pages remaining.
4. **Given** a user is reading in Full Quran mode, **When** they scroll through pages, **Then** the interface remains clean with no distracting UI elements — only the Quran text and minimal navigation controls are visible.

---

### User Story 2 - Verse-by-Verse Focused Reading (Priority: P2)

A user wants to study the Quran one ayah at a time. They select "Verse Mode" and navigate to a specific surah and ayah. The screen displays one verse prominently with clear Arabic typography. They can swipe left/right or tap arrows to move between verses. For each verse, they can optionally view the translation and listen to audio recitation.

**Why this priority**: Verse mode serves the study and memorization use case, complementing the continuous reading of Full Quran mode. It delivers significant value for users who want to deeply understand individual ayahs.

**Independent Test**: Can be fully tested by selecting a surah, entering Verse Mode, navigating between verses with swipe/tap, and toggling translation display.

**Acceptance Scenarios**:

1. **Given** a user selects a surah and enters Verse Mode, **When** the screen loads, **Then** they see a single ayah displayed prominently with clear Arabic typography, the surah name, and the ayah number.
2. **Given** a user is viewing ayah 5 of Al-Baqarah, **When** they swipe left, **Then** they see ayah 6. When they swipe right, they see ayah 4.
3. **Given** a user is viewing an ayah, **When** they tap the translation toggle, **Then** the translation text appears below the Arabic text.
4. **Given** a user is viewing an ayah, **When** they tap the audio play button, **Then** the audio recitation of that specific ayah plays.
5. **Given** a user is on the last ayah of a surah, **When** they swipe to the next verse, **Then** they transition to the first ayah of the next surah.

---

### User Story 3 - Mode Switching (Priority: P2)

A user is reading in Full Quran mode and encounters a verse they want to study more closely. They switch to Verse Mode using the mode toggle, and the app navigates to the same verse they were reading. Later, they switch back to Full Quran mode and continue from where they left off.

**Why this priority**: Seamless mode switching ties the two reading experiences together and enables natural workflow transitions between reading and studying.

**Independent Test**: Can be fully tested by reading in one mode, switching to the other, and verifying the reading position is preserved across the switch.

**Acceptance Scenarios**:

1. **Given** a user is reading in Full Quran mode at a specific verse, **When** they tap the mode toggle to switch to Verse Mode, **Then** the app displays that same verse in Verse Mode.
2. **Given** a user is in Verse Mode at ayah 10 of Surah Yasin, **When** they switch to Full Quran mode, **Then** they are taken to the Mushaf page containing that verse.
3. **Given** the mode toggle is visible, **When** the user taps it, **Then** the transition between modes feels smooth and immediate (no full-screen reload).

---

### User Story 4 - Reading Customization (Priority: P3)

A user wants to adjust the reading experience to their comfort. They increase the font size for better readability, enable night mode for evening reading, and adjust other display preferences. These preferences persist across sessions.

**Why this priority**: Customization enhances comfort for long reading sessions but is not essential for core functionality.

**Independent Test**: Can be fully tested by changing font size and night mode settings, verifying they apply immediately, and confirming they persist after app restart.

**Acceptance Scenarios**:

1. **Given** a user is reading in either mode, **When** they adjust the font size, **Then** the Quran text immediately reflects the new size.
2. **Given** a user enables night mode, **When** the display updates, **Then** the background becomes dark and the text becomes light, optimized for low-light reading.
3. **Given** a user sets font size to large and enables night mode, **When** they close and reopen the app, **Then** both settings are preserved.

---

### User Story 5 - Tafsir Access in Verse Mode (Priority: P3)

A user studying a verse wants to read its tafsir (exegesis/commentary). While in Verse Mode, they tap the tafsir button to view scholarly commentary for the current ayah.

**Why this priority**: Tafsir adds depth for serious study but depends on external data sources and is an enhancement to the core reading experience.

**Independent Test**: Can be fully tested by navigating to a verse in Verse Mode and tapping the tafsir button to view commentary.

**Acceptance Scenarios**:

1. **Given** a user is viewing a verse in Verse Mode, **When** they tap the tafsir button, **Then** the tafsir text for that verse is displayed in a readable panel or sheet.
2. **Given** a user views tafsir for a verse, **When** they dismiss the tafsir panel, **Then** they return to the verse view without losing their place.

---

### Edge Cases

- What happens when the user reaches the very first ayah of the Quran (Al-Fatiha:1) and swipes to the previous verse? The app should indicate they are at the beginning and not navigate further.
- What happens when the user reaches the last ayah of the Quran (An-Nas:6) and swipes to the next verse? The app should indicate they have completed the Quran.
- How does the system handle no internet connection when trying to load translation, tafsir, or audio? The app should display cached content if available or show a clear offline message.
- What happens when the user switches between modes while audio is playing? Audio should stop when switching modes.
- How does the system handle very long ayahs (e.g., Ayat al-Kursi, Al-Baqarah:282) in Verse Mode? The text should be scrollable within the verse display area.
- What happens when the user adjusts font size to the maximum? The layout should remain usable and not break.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide two distinct reading modes: Verse Mode (single ayah display) and Full Quran Mode (continuous Mushaf-style scrolling).
- **FR-002**: System MUST provide a clearly visible toggle or segmented control to switch between Verse Mode and Full Quran Mode.
- **FR-003**: In Full Quran Mode, system MUST display Quran text in a page-by-page swipeable layout where each swipe reveals the next Mushaf page, replicating the Khatma app experience.
- **FR-004**: In Full Quran Mode, system MUST persist the user's last reading position and restore it when the user returns.
- **FR-005**: In Full Quran Mode, system MUST track and display the user's Khatma (completion) progress as a percentage and/or pages read out of total pages. The system supports a single active Khatma at a time.
- **FR-005a**: When a user completes a full Khatma (all 604 pages), the system MUST display a completion celebration and offer the option to start a new Khatma (resetting progress to zero). Previous Khatma history is not retained.
- **FR-006**: In Verse Mode, system MUST display one ayah at a time with prominent Arabic typography, surah name, and ayah number.
- **FR-007**: In Verse Mode, system MUST support navigation between verses via swipe gestures (left/right) and tap-based navigation controls.
- **FR-008**: In Verse Mode, system MUST provide a toggle to show/hide an English translation for the current ayah.
- **FR-009**: In Verse Mode, system MUST provide audio playback controls to play the recitation of the current ayah.
- **FR-010**: In Verse Mode, system MUST provide access to tafsir (commentary) for the current ayah via a dedicated button.
- **FR-011**: When switching between modes, system MUST preserve the user's current reading position (same verse context carried across modes).
- **FR-012**: System MUST support adjustable font size for Quran text in both modes, with changes applied immediately.
- **FR-013**: System MUST support a night/dark reading mode optimized for low-light conditions in both modes.
- **FR-014**: System MUST persist all user reading preferences (font size, night mode, last mode used) across app sessions.
- **FR-015**: In Full Quran Mode, system MUST support smooth navigation to any surah via a surah selection mechanism (e.g., jump-to-surah).
- **FR-016**: In Verse Mode, verse transitions (swipe/tap) MUST cross surah boundaries automatically (last ayah of one surah leads to first ayah of the next).
- **FR-017**: System MUST maintain high readability with optimized typography, spacing, and layout for Arabic Quran text in both modes.
- **FR-018**: In Full Quran Mode, the interface MUST be distraction-free during reading, with controls hidden or minimal until the user interacts (e.g., taps to reveal controls).

### Key Entities

- **Reading Position**: Represents the user's current place in the Quran — includes surah, ayah, page number, and scroll offset. Used for resuming and mode-switching.
- **Khatma Progress**: Tracks the user's single active Quran reading completion — includes pages read, total pages (604), completion percentage, start date, and completed status. Resettable upon completion to begin a new Khatma.
- **Reading Preferences**: User's display settings — font size level, night mode state, last selected reading mode.
- **Verse**: A single ayah with its Arabic text, English translation text, associated audio reference, and tafsir reference.
- **Mushaf Page**: A page of Quran text as it appears in the traditional printed Mushaf — includes page number and the verses contained on that page.

## Clarifications

### Session 2026-03-13

- Q: Full Quran navigation model — page-by-page swipe or continuous scroll? → A: Page-by-page swipe (like Khatma app), each swipe reveals the next Mushaf page.
- Q: Khatma progress lifecycle — single, resettable, or multiple concurrent? → A: Single active khatma with reset. User completes and can start a new one; no history tracking.
- Q: Translation language for Verse Mode? → A: English translation only for initial release. Additional languages can be added later.

## Assumptions

- The Quran text data source (Arabic text, translations, page mappings) is available either bundled with the app or via a reliable external service. The existing app already uses an API for Quran text.
- Audio recitation files are streamed from an external service (the app already uses cdn.islamic.network for reciters).
- Tafsir content will be sourced from an external service or bundled dataset. The specific tafsir source (e.g., Ibn Kathir, Al-Tabari) is assumed to be a single default tafsir initially.
- The Mushaf page layout in Full Quran mode does not need to be pixel-identical to any specific printed Mushaf edition — it should provide a similar continuous reading feel.
- The total Quran page count is based on the standard Madani Mushaf (604 pages).
- The existing surah data (surahs.json with page numbers) will be used as the foundation for navigation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can switch between Verse Mode and Full Quran Mode in under 1 second with no perceptible loading delay.
- **SC-002**: Users who close and reopen the app resume reading within 2 seconds at the exact position they left off.
- **SC-003**: Continuous scrolling in Full Quran Mode maintains smooth performance (no jank or frame drops) during extended reading sessions of 30+ minutes.
- **SC-004**: Users can adjust font size and toggle night mode with changes reflected immediately (under 500ms).
- **SC-005**: Khatma progress is accurately tracked and displayed, updating in real-time as the user reads.
- **SC-006**: In Verse Mode, swiping between verses feels responsive and natural, completing the transition in under 300ms.
- **SC-007**: 90% of users can discover and use the mode toggle without external guidance on their first session.
