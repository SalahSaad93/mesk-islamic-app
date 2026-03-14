# Research: Quran Reading Modes

**Branch**: `008-quran-reading-modes` | **Date**: 2026-03-13

## R-001: Full Quran Verse Data Completeness

**Decision**: Import complete Quran text (6,236 verses) from alquran.cloud API into a bundled JSON asset, seeded into SQLite on first launch.

**Rationale**: The current `quran_verses.json` contains only 12 sample verses (Al-Fatiha + partial Al-Baqarah). Both reading modes require the full Quran text. Bundling as a JSON asset ensures offline-first capability and avoids runtime API dependency for core content. The existing `QuranDatabaseService` already supports batch-insert seeding from this file.

**Alternatives considered**:
- Fetch verses on-demand from API → rejected: unreliable for offline reading, poor UX for page-by-page mode
- Bundle a pre-built SQLite database → rejected: larger APK size, platform-specific DB format issues
- Use a third-party package (quran_text) → rejected: adds dependency, less control over text variants

## R-002: English Translation Data Source

**Decision**: Use Sahih International English translation from alquran.cloud API (`en.sahih`), bundled as a separate JSON asset and stored in a new `translations` SQLite table.

**Rationale**: Sahih International is the most widely used English Quran translation, with clear modern English. Storing translations in a separate table (not in the `verses` table) keeps the data model clean and allows adding more languages later without schema changes.

**Alternatives considered**:
- Embed translation in verses table → rejected: couples Arabic and translation data, makes multi-language harder
- Fetch translations on-demand → rejected: Verse Mode needs instant toggle, can't depend on network
- Multiple translations bundled → rejected: scope creep for initial release; single translation per spec clarification

## R-003: Tafsir Data Source

**Decision**: Use Tafsir Ibn Kathir (Arabic) from an external API (api.quran.com or similar), fetched on-demand and cached locally in a `tafsir_cache` SQLite table.

**Rationale**: Tafsir texts are large (several MB per complete tafsir). Bundling would significantly increase APK size. On-demand fetch with local caching provides the best balance: first access requires network, subsequent access is instant. Ibn Kathir is the most popular and authoritative tafsir.

**Alternatives considered**:
- Bundle full tafsir → rejected: 20-50MB additional APK size
- No caching (always fetch) → rejected: poor offline experience
- Multiple tafsir sources → rejected: initial release uses single default per spec

## R-004: Page Position Persistence

**Decision**: Use the existing `StorageService` with the already-defined `quran_last_read_page` key. Extend with additional keys for Verse Mode position and reading preferences.

**Rationale**: `StorageService` already has `setLastReadPage(int)` and `lastReadPage` getter, but the `QuranReaderNotifier` doesn't use them. The fix is straightforward: load from storage on init, save on page change. The key already exists — it's just not wired up.

**Alternatives considered**:
- SQLite table for reading state → rejected: overkill for simple key-value preferences
- Hive box → rejected: adds unnecessary dependency when SharedPreferences suffices

## R-005: Khatma Progress Tracking

**Decision**: Track Khatma progress using a set of SharedPreferences keys: highest page reached, start date, and completion status. A page is considered "read" when the user navigates to it (page change event).

**Rationale**: Simple key-value storage is sufficient for single-khatma tracking (per spec clarification). No need for a database table since there's no history to query. "Read" is defined by page visit, not time spent — this is the standard approach used by Khatma and similar apps.

**Alternatives considered**:
- Track by time spent on page → rejected: complex, battery-draining, and doesn't match user expectations
- Track individual verse reads → rejected: overly granular for page-based Full Quran mode
- SQLite table with history → rejected: spec says no history tracking for khatma

## R-006: Night Mode Implementation

**Decision**: Implement as a Quran-reader-specific dark theme override, independent of the app-wide dark mode toggle. Uses a dedicated `quran_night_mode` SharedPreferences key.

**Rationale**: The app already has a global dark mode (`isDarkMode` in SettingsState). The Quran reader night mode serves a different purpose — optimized for extended reading with specific contrast ratios for Arabic text. Users may want the app in light mode but the reader in dark mode (common pattern in reading apps).

**Alternatives considered**:
- Reuse app-wide dark mode → rejected: doesn't allow independent control, spec explicitly lists it as a reader feature
- Sepia/warm mode option → rejected: not in spec, can be added later
