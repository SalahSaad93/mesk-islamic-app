# Feature Specification: Implement Remaining Features from Plan

**Feature Branch**: `003-missing-features`  
**Created**: 2026-03-11  
**Status**: Draft  
**Input**: User description: "what is left not implemented from plan piped-petting-kay.md"

## Clarifications

### Session 2026-03-11

- Q: Should we build a dynamic image generator for sharing verses, or stick strictly to plain text sharing for this phase? → A: Text Only (Only share plain string text).
- Q: Should we impose length or character set constraints on user notes? → A: Reasonable Constraint (Impose a reasonable character limit per note, e.g., 2000 characters).
- Q: How should the system determine that an Athkar category is "complete" and trigger the celebration animation? → A: Overall Category Count (The total sum of dhikr reached matches the total sum required for that category).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Quran Personalization: Notes, Bookmarks, and Highlights (Priority: P1)

As a user studying the Quran, I want to be able to bookmark specific verses, apply colored highlights to verses, and write personal notes on verses, so that I can easily find and review my reflections later. I also want to browse all my notes in a dedicated screen.

**Why this priority**: Personalizing the reading experience with notes, highlights, and bookmarks transforms the app from a simple reader to a study tool.

**Independent Test**: Can be fully tested by selecting a verse, applying a highlight/note, and confirming it persists across app restarts and is visible in the Notes screen.

**Acceptance Scenarios**:

1. **Given** the user is viewing a Quran verse, **When** they tap the verse and select "Highlight" and pick a color, **Then** the verse background color changes to the selected color and persists.
2. **Given** the user has added notes to verses, **When** they navigate to the "Notes Screen", **Then** they see a chronological list of their notes with verse previews, and can edit or delete them.
3. **Given** the user is in the Verse Actions Menu, **When** they add or toggle a bookmark, **Then** the bookmark state updates and reflects correctly across the UI.

---

### User Story 2 - Quran Audio Reciter Selection (Priority: P2)

As a user listening to Quran recitation, I want to be able to pick my preferred reciter from a list, so that I can listen to the voice I connect with most.

**Why this priority**: Users have strong preferences for specific Qaris (reciters); giving them choices greatly enhances the listening experience.

**Independent Test**: Can be fully tested by tapping the reciter name, viewing the list of options, selecting a new reciter, and validating the audio playback switches to the new reciter.

**Acceptance Scenarios**:

1. **Given** the user is in the Quran reader audio controls, **When** they tap the current reciter's name, **Then** a bottom sheet (`reciter_picker_sheet`) opens showing available reciters.
2. **Given** the reciter picker sheet is open, **When** the user selects a new reciter, **Then** the selection is saved, the sheet closes, and any subsequent audio playback uses the newly selected reciter.

---

### User Story 3 - Social Sharing of Verses (Priority: P3)

As a user, I want to share or copy specific Quran verses (with or without translation), so that I can send them to friends or post them on social media.

**Why this priority**: Social sharing encourages app growth and allows users to disseminate knowledge.

**Independent Test**: Can be fully tested by tapping the share button on a verse and observing the native share dialog appear with the correct verse text.

**Acceptance Scenarios**:

1. **Given** a user has opened the Verse Actions Menu, **When** they tap "Share", **Then** the native OS share sheet appears, pre-filled with the Arabic text and its translation.
2. **Given** a user has opened the Verse Actions Menu, **When** they tap "Copy", **Then** the verse text is copied to their clipboard and they receive a confirmation snackbar.

---

### User Story 4 - App Polish & UX Enhancements (Priority: P4)

As a user, I want to experience a polished app where data is fresh (pull-to-refresh), reaching goals is celebrated (Athkar completion animation), and the daily inspiration verse changes regularly.

**Why this priority**: These enhancements elevate the app from "functional" to "premium."

**Independent Test**: Can be fully tested by pulling down on Prayer Times/Athkar to refresh, finishing an Athkar category to see the animation, and checking that the daily verse rotates using local JSON data.

**Acceptance Scenarios**:

1. **Given** the user is on the Prayer Times or Athkar screen, **When** they perform a pull-to-refresh gesture, **Then** the data naturally refreshes.
2. **Given** the user completes the final Dhikr in an Athkar category, **When** it reaches 100%, **Then** a celebration animation plays.
3. **Given** the user opens the Home screen, **When** they view the Daily Inspiration, **Then** it randomly or sequentially selects a verse from `daily_verses.json`.

### Edge Cases

- What happens when the user tries to share a very long set of verses or a whole page? (Share should limit text size or send a link/reference instead).
- How does the system handle notes that contain enormous amounts of text? (UI should scroll and truncate gracefully).
- What if the user is completely offline while changing reciters? (The app should fallback to available cached audio or show an offline banner).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide persistent storage capability for user-generated data (notes, highlights, and bookmarks) related to Quran verses.
- **FR-002**: System MUST add a dedicated screen to manage, edit, and delete user-created verse notes, with input validation ensuring notes do not exceed 2000 characters.
- **FR-003**: System MUST provide an interface to allow selecting from multiple predefined reciters, updating the active audio playback.
- **FR-004**: System MUST integrate native OS sharing capabilities for sharing verse text externally (plain text only, no image generation for this feature phase).
- **FR-005**: System MUST provide a daily inspiration mechanism to populate the Daily Inspiration widget with rotating quotes/verses.
- **FR-006**: System MUST implement Pull-to-Refresh on the Prayer Times and Athkar list screens.
- **FR-007**: System MUST display a celebration animation upon completing an Athkar category (measured when the sum of all dhikr counts reaches the overall category target sum).

### Key Entities

- **NoteEntity**: Associated with a specific verse ID, contains the user's plain text note and a timestamp.
- **HighlightEntity**: Associated with a specific verse ID, stores the selected highlight color hex code.
- **ReciterEntity**: Represents an available audio reciter (e.g., Alafasy, Sudais) with associated audio endpoint bases.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully persist and retrieve notes, highlights, and bookmarks across app restarts.
- **SC-002**: Users can seamlessly switch between reciters, and audio requests adapt directly to the selected reciter.
- **SC-003**: Pull-to-refresh mechanisms correctly fetch updated state without crashing.
- **SC-004**: The share sheet correctly populates with text (Arabic + Translation) when triggered from a verse.
