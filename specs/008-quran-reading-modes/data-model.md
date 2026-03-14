# Data Model: Quran Reading Modes

**Branch**: `008-quran-reading-modes` | **Date**: 2026-03-13

## Existing Entities (Modified)

### Verse (verses table — existing, extended)

Current columns remain unchanged:
- `id` (PK, int) — global verse ID (1–6236)
- `surah_number` (int) — 1–114
- `ayah_number` (int) — verse number within surah
- `text_uthmani` (text) — Uthmani script with diacritics
- `text_simple` (text) — simplified Arabic for search
- `page` (int) — Mushaf page 1–604
- `juz` (int) — 1–30
- `hizb` (int) — 1–240

**Change**: Populate with full 6,236 verses (currently only 12 sample verses seeded).

Indexes: `page`, `surah_number` (existing)

### QuranReaderState (in-memory — existing, extended)

Current fields:
- `currentPage` (int) — 1–604
- `totalPages` (int) — 604
- `isOverlayVisible` (bool)

**New fields**:
- `readingMode` (enum: verseMode, fullQuranMode) — active reading mode

## New Entities

### Translation (new table: `translations`)

| Column | Type | Description |
|--------|------|-------------|
| `verse_id` | int, FK → verses.id | Links to verse |
| `language` | text | Language code (e.g., 'en') |
| `text` | text | Translation text |
| `translator` | text | Source identifier (e.g., 'sahih_international') |

**Primary Key**: (`verse_id`, `language`)
**Index**: `verse_id`

**Validation**: `text` must not be empty. `language` must be a valid ISO 639-1 code.

### TafsirCache (new table: `tafsir_cache`)

| Column | Type | Description |
|--------|------|-------------|
| `id` | int, PK | Auto-increment |
| `verse_id` | int, FK → verses.id | Links to verse |
| `source` | text | Tafsir source (e.g., 'ibn_kathir') |
| `text` | text | Cached tafsir content |
| `cached_at` | text (ISO 8601) | When cached for staleness check |

**Unique constraint**: (`verse_id`, `source`)
**Index**: `verse_id`

**Lifecycle**: Entries are created on first fetch, never auto-deleted. Cache can be cleared manually by user.

### KhatmaProgress (SharedPreferences — new keys)

| Key | Type | Description |
|-----|------|-------------|
| `khatma_highest_page` | int | Highest page number the user has visited (1–604) |
| `khatma_start_date` | String (ISO 8601) | Date the current khatma started |
| `khatma_completed` | bool | Whether the current khatma is complete |

**State transitions**:
- **New Khatma**: `highest_page=0`, `start_date=now`, `completed=false`
- **Reading**: `highest_page` increments as user visits new pages (max of current and visited page)
- **Completed**: When `highest_page == 604`, set `completed=true`
- **Reset**: All keys reset to initial state, `start_date=now`

### ReadingPreferences (SharedPreferences — new/extended keys)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `quran_last_read_page` | int | 1 | Last page in Full Quran mode (existing key, now wired up) |
| `quran_reading_mode` | String | 'fullQuran' | Last active reading mode (existing key) |
| `quran_verse_mode_surah` | int | 1 | Last surah in Verse Mode |
| `quran_verse_mode_ayah` | int | 1 | Last ayah in Verse Mode |
| `quran_font_size` | int | 2 | Font size level (1=small, 2=medium, 3=large, 4=xlarge) |
| `quran_night_mode` | bool | false | Reader-specific night mode |
| `quran_show_translation` | bool | false | Show/hide translation in Verse Mode |

### VersePosition (in-memory value object — new)

Represents a precise position in the Quran, used for mode switching and bookmarking.

| Field | Type | Description |
|-------|------|-------------|
| `surahNumber` | int | 1–114 |
| `ayahNumber` | int | verse number within surah |
| `page` | int | Mushaf page 1–604 |

**Derived from**: Any verse in the database. Used to translate between page-based (Full Quran) and verse-based (Verse Mode) positions.

## Entity Relationships

```
Verse (6,236 rows)
  ├── 1:1 Translation (per language)
  ├── 1:N TafsirCache (per source)
  ├── 1:0..1 Bookmark (existing)
  ├── 1:0..1 Highlight (existing)
  └── 1:0..N Note (existing)

Surah (114 rows, from JSON)
  └── 1:N Verse (by surah_number)

MushafPage (604 virtual pages)
  └── 1:N Verse (by page column)

KhatmaProgress (singleton, SharedPreferences)
  └── References pages 1–604

ReadingPreferences (singleton, SharedPreferences)
  └── References reading mode, positions, display settings
```

## Database Migration (v2 → v3)

The existing database is version 2. This feature requires version 3 migration:

1. Create `translations` table
2. Create `tafsir_cache` table
3. Seed `translations` table with English (Sahih International) data from bundled JSON asset

Existing tables (`verses`, `juz`, `bookmarks`, `notes`, `highlights`) remain unchanged.
