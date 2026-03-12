# Mesk Islamic App — Comprehensive Implementation Plan

## Context

The app has a solid foundation with ~24 Dart files. Home, Prayer Times, Tasbih, and Navigation are functional. However, the Quran reader is a UI mockup, Qibla is a placeholder, settings don't persist, no notifications exist, and the data/domain layers are empty shells.

This updated plan incorporates features inspired by **Quran Kareem** (tech.massyve.quran) — particularly its rich Quran reading experience with multiple reading modes, verse-synced audio highlighting, tafsir, search, and translations. It also adds **full app localization** (Arabic/English).

---

## 1. Tech Stack Assessment

### Keep As-Is
| Package | Version | Role |
|---------|---------|------|
| `flutter_riverpod` | ^2.6.1 | State management (manual providers) |
| `adhan` | ^2.0.0+1 | Prayer times + Qibla direction |
| `geolocator` + `geocoding` | ^13.0.2 / ^3.0.0 | Location |
| `shared_preferences` | ^2.3.4 | App settings, lightweight KV storage |
| `just_audio` | ^0.9.40 | Quran recitation audio |
| `google_fonts` | ^6.2.1 | Amiri (Arabic) + Inter (English) |
| `dio` | ^5.8.0+1 | HTTP (audio caching, API calls) |
| `flutter_svg` | ^2.0.16 | SVG decorations |
| `vibration` | ^2.0.0 | Haptic feedback |
| `permission_handler` | ^11.3.1 | Runtime permissions |
| `path_provider` | ^2.1.5 | File paths for caches |
| `intl` | ^0.20.0 | Date/number formatting + i18n |

### Add
| Package | Version | Phase | Purpose |
|---------|---------|-------|---------|
| `sqflite` | ^2.4.1 | 5 | Structured Quran DB (verses, tafsir, translations, bookmarks, notes, highlights) |
| `flutter_local_notifications` | ^17.0.0 | 7 | Prayer/athkar notifications |
| `flutter_compass` | ^0.8.0 | 8 | Device compass heading for Qibla |
| `scrollable_positioned_list` | ^0.3.8 | 5 | Efficient scrollable verse list with jump-to-verse |
| `share_plus` | ^10.1.4 | 5 | Share verses / ayah images |

### Remove (unused, add build overhead)
| Package | Reason |
|---------|--------|
| `riverpod_annotation` | Code-gen unused — staying manual |
| `riverpod_generator` | Same |
| `build_runner` | Only needed for code-gen |
| `json_serializable` | Manual fromJson works at this scale |

### Key Constraint
> `hive_generator` conflicts with `riverpod_generator` (source_gen clash). We're removing riverpod_generator and NOT adding Hive. Using `shared_preferences` for settings + `sqflite` for Quran data.

---

## 2. Architecture Decisions

### Stay Lean — No Full Repository/UseCase Pattern
- **Service classes** in `lib/core/services/` for cross-cutting concerns
- **Providers call datasources directly** (current working pattern)
- **Entities remain pure Dart**

### Storage Strategy (Updated)
- **`shared_preferences`** for app settings, simple flags, last-read page, theme preference
- **`sqflite`** for Quran-specific structured data: 6236 verses, translations, tafsir text, verse-level bookmarks, user notes, text highlights, search indexing. This data is too complex and query-heavy for shared_preferences.

### Quran Data: Bundled SQLite Database
Pre-build a `quran.db` SQLite database (~15-20MB) bundled in assets containing:
- All 6236 verses in Uthmani Arabic script
- Page mapping (which verses appear on each of 604 Mushaf pages)
- **5 translations**: English (Sahih International), French (Hamidullah), Urdu (Jalandhry), Turkish (Diyanet), Indonesian (Kemenag)
- Arabic tafsir: Al-Muyassar (التفسير الميسر)
- Verse audio timing data per reciter (for synced highlighting)
- Surah + Juz metadata
- FTS5 search indexes for Arabic text, translations, and tafsir

**Data source**: Quran.com API v4 (free, well-documented). A build-time script fetches all data and assembles the DB.

This DB is copied from assets to app documents on first launch, then queried via sqflite.

### Localization: Full Arabic + English
Use Flutter's built-in `flutter_localizations` + `intl` (already in pubspec) with ARB files for all UI strings. The app locale follows user's settings toggle. Quran text/translations are separate from UI localization.

---

## 3. Current Bugs & Issues

| # | File | Issue |
|---|------|-------|
| 1 | `home_screen.dart` ~L165 | Countdown StreamBuilder never uses stream snapshot — shows stale value |
| 2 | `home_screen.dart` ~L281-297 | Quick Access card `onTap` handlers are no-ops |
| 3 | `home_screen.dart` + `prayer_times_screen.dart` | Duplicate Hijri date calculation — extract to utility |
| 4 | `tasbih_screen.dart` ~L310 | `_saveSession()` only shows SnackBar, nothing persisted |
| 5 | `tasbih_screen.dart` ~L287 | History sheet always shows "No sessions yet" |
| 6 | `settings_screen.dart` | All toggles are local `setState` — lost on restart |
| 7 | `prayer_times_screen.dart` ~L274 | Per-prayer notification toggle not persisted |
| 8 | `quran_home_screen.dart` ~L424 | `_getVersesList()` returns hardcoded Al-Fatiha only |
| 9 | `athkar_home_screen.dart` | Search bar and filter chips are no-ops |
| 10 | `app_theme.dart` ~L116 | Deprecated `MaterialStateProperty` → `WidgetStateProperty` |
| 11 | `athkar_detail_screen.dart` ~L259 | `GoogleFontsWorkaround` hack |
| 12 | `islamic_card.dart` | InkWell ink effect doesn't render (Container decoration on top) |

---

## 4. Missing Features

### Quran (Major — inspired by Quran Kareem app)
- [ ] Actual verse text rendering (currently placeholder)
- [ ] **Three reading modes**: Mushaf (page-by-page), Scrolling (continuous), Vertical Pagination
- [ ] **Verse-synced audio highlighting** (karaoke-style — verse highlights as reciter reads)
- [ ] Multiple reciters with streaming + caching
- [ ] **Tafsir panel** (at least 1 tafsir, slide-up or side panel)
- [ ] **Translation overlay** (toggle English translation under each verse)
- [ ] **Advanced search** across Quran text and tafsir
- [ ] **Verse-level bookmarks** (not just page-level)
- [ ] **User notes** on verses
- [ ] **Text highlighting** (color-mark verses for study)
- [ ] **Copy & share** verses (text or image)
- [ ] **Auto-scroll** with adjustable speed
- [ ] Last read page persistence
- [ ] Khatmah (reading plan) tracking
- [ ] Juz index screen
- [ ] **Inline word meanings** (tap a word for definition) — stretch goal
- [ ] **Daily random verse notification**

### Localization
- [ ] Full Arabic UI translation (all screens, buttons, labels, messages)
- [ ] Full English UI (current default)
- [ ] RTL layout support when Arabic is selected
- [ ] Language switcher in settings that persists and applies immediately

### Athkar
- [ ] Disk persistence of progress (reset daily)
- [ ] Data for 6 of 8 categories
- [ ] Search and filter functionality
- [ ] Completion animation

### Tasbih
- [ ] Session persistence to disk
- [ ] Real session history
- [ ] Lifetime count tracking

### Settings
- [ ] All toggle persistence
- [ ] Dark mode
- [ ] Calculation method change
- [ ] Language switching (Arabic/English)

### Qibla
- [ ] Compass sensor + Qibla angle calculation + compass UI

### Notifications
- [ ] Prayer time notifications
- [ ] Athkar reminders
- [ ] Daily random verse notification

### Core
- [ ] `app_spacing.dart`, `app_assets.dart` constants
- [ ] `storage_service.dart`, `location_service.dart`, `audio_service.dart`, `notification_service.dart`
- [ ] Shared Hijri date utility
- [ ] Core widgets: loading_indicator, error_view, empty_state, section_header
- [ ] Dark theme

---

## 5. Step-by-Step Execution Phases

---

### Phase 1: Core Infrastructure
**Goal:** Shared services and constants that all subsequent phases depend on.

#### 1.1 `lib/core/constants/app_spacing.dart`
- Constants: `xs=4`, `sm=8`, `md=12`, `lg=16`, `xl=20`, `xxl=24`, `xxxl=32`, `screenPadding=16`

#### 1.2 `lib/core/constants/app_assets.dart`
- String constants for all asset paths

#### 1.3 `lib/core/utils/hijri_date.dart`
- Extract duplicate Hijri calculation from `home_screen.dart` and `prayer_times_screen.dart`
- `HijriDate.format(DateTime)` and `HijriDate.calculate(DateTime)`

#### 1.4 `lib/core/services/storage_service.dart`
- Riverpod Provider wrapping `SharedPreferences`
- Typed getters/setters:
  - **Settings:** `isDarkMode`, `language`, `calculationMethod`
  - **Tasbih:** `getTasbihSessions()`, `saveTasbihSession(session)`
  - **Quran:** `lastReadPage`, `selectedReciterId`, `readingMode`
  - **Athkar:** `getAthkarProgress(category)`, `saveAthkarProgress(category, map)`, `getAthkarLastReset(category)`
  - **Notifications:** per-prayer toggles, reminder times
- Initialized in `main.dart` with `ProviderScope` override

#### 1.5 `lib/core/services/location_service.dart`
- Extract from `prayer_times_provider.dart`
- `getCurrentLocation()` → `LocationResult(lat, lng, name)`

#### 1.6 `lib/core/services/audio_service.dart`
- Wrapper around `just_audio` `AudioPlayer`
- Methods: `playUrl`, `pause`, `stop`, `seek`, `dispose`
- Streams: `playerStateStream`, `positionStream`, `durationStream`
- **Verse-level callback support**: `onVerseChanged(int verseIndex)` for synced highlighting

#### 1.7 Core widgets
- `lib/core/widgets/loading_indicator.dart`
- `lib/core/widgets/error_view.dart`
- `lib/core/widgets/empty_state.dart`
- `lib/core/widgets/section_header.dart`

#### 1.8 Update `lib/main.dart`
- Initialize `SharedPreferences` before `runApp`
- Override `storageServiceProvider` in `ProviderScope`

#### 1.9 Fix `lib/core/widgets/islamic_card.dart`
- Wrap with `Material` so `InkWell` splash renders

#### 1.10 Fix `lib/core/theme/app_theme.dart`
- `MaterialStateProperty` → `WidgetStateProperty`

---

### Phase 2: Localization (Arabic + English)
**Goal:** Full bilingual UI. Every user-visible string externalized.
**Depends on:** Phase 1

#### 2.1 Setup localization infrastructure
- Create `lib/l10n/` directory
- Create `lib/l10n/app_en.arb` — all English strings (keys like `prayerTimesTitle`, `athkarMorning`, `settingsDarkMode`, etc.)
- Create `lib/l10n/app_ar.arb` — all Arabic translations
- Configure `flutter.generate: true` in `pubspec.yaml`
- Create `l10n.yaml` config:
  ```yaml
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: app_localizations.dart
  output-class: AppLocalizations
  ```

#### 2.2 Update `lib/app.dart`
- Add `localizationsDelegates`: `AppLocalizations.localizationsDelegates`
- Add `supportedLocales`: `[Locale('en'), Locale('ar')]`
- Set `locale` from `settingsProvider.language`

#### 2.3 Systematically replace all hardcoded strings
- Every screen: replace literal strings with `AppLocalizations.of(context)!.keyName`
- Covers: Home, Prayer Times, Athkar, Quran, Tasbih, Settings, Navigation labels
- Estimated: ~200-300 string keys total

#### 2.4 RTL support
- When Arabic is selected, `MaterialApp.locale` = `Locale('ar')` which auto-enables RTL for Material widgets
- Verify all custom layouts handle RTL correctly (padding, alignment, icons)
- Quran text is always RTL regardless of app locale

#### 2.5 Update Settings screen
- Language picker writes to `settingsProvider` → triggers app rebuild with new locale
- Show language names in their own script: "English", "العربية"

---

### Phase 3: Settings Persistence + Dark Mode
**Goal:** All settings persist and dark mode works.
**Depends on:** Phase 1, Phase 2

#### 3.1 `lib/features/settings/presentation/providers/settings_provider.dart`
- `SettingsState`: `isDarkMode`, `locale` (String), `calculationMethod`, `readingMode`, all reminder toggles
- `SettingsNotifier extends Notifier<SettingsState>`: loads from StorageService, persists on mutation

#### 3.2 Add `AppTheme.dark` in `lib/core/theme/app_theme.dart`
- Dark surface: `#121212`, dark cards: `#1E1E1E`
- Keep green primary and gold accent
- Invert text colors

#### 3.3 Update `lib/app.dart`
- Watch `settingsProvider` for both theme mode and locale
- Apply `ThemeMode.dark` / `ThemeMode.light`

#### 3.4 Refactor `lib/features/settings/presentation/screens/settings_screen.dart`
- `StatefulWidget` → `ConsumerWidget`
- All toggles read/write through `settingsProvider`

---

### Phase 4: Athkar Completion
**Goal:** Persistence, all categories, search, filter, daily reset.
**Depends on:** Phase 1

#### 4.1 Create 6 additional athkar JSON files
- `athkar_after_fajr.json`, `athkar_sleep.json`, `athkar_ayat_kursi.json`, `athkar_istighfar.json`, `athkar_tasbih.json`, `athkar_after_maghrib.json`
- Same schema as existing files

#### 4.2 Refactor `athkar_local_datasource.dart`
- Generic `_loadCategory(String assetPath)` with per-category caching

#### 4.3 Add persistence to `athkar_provider.dart`
- Load/save progress from StorageService
- Daily reset logic (morning reset at Dhuhr, evening at Fajr)

#### 4.4 Wire search + filter in `athkar_home_screen.dart`

#### 4.5 Fix `athkar_detail_screen.dart`
- Remove `GoogleFontsWorkaround`, use `AppTextStyles`

---

### Phase 5: Quran Reader (Largest Phase — Inspired by Quran Kareem)
**Goal:** Rich Quran reading experience with multiple modes, audio sync, tafsir, translation, search, bookmarks, notes, highlights.
**Depends on:** Phase 1 (storage_service, audio_service)

This is the heart of the app. Break into sub-phases.

#### Sub-phase 5A: Quran Database

##### 5A.1 Create pre-built `assets/data/quran.db` (SQLite)

**Data source:** Quran.com API v4 (https://api.quran.com/api/v4/) — free, well-documented, has Uthmani text + 50+ translations + multiple tafsir. Fetch all data at build time via a Dart/Python script, assemble into `quran.db`, bundle in assets.

**Build script:** `tools/build_quran_db.dart` (or `.py`)
- Fetch verses: `GET /quran/verses/uthmani?chapter_number={1-114}`
- Fetch translations: `GET /resources/translations` → pick IDs, then `GET /quran/translations/{id}?chapter_number={1-114}`
- Fetch tafsir: `GET /quran/tafsirs/{id}?chapter_number={1-114}`
- Fetch verse timings: `GET /recitations/{recitation_id}/by_chapter/{chapter}` for audio sync data
- Insert all into SQLite tables below

Schema:
```sql
-- Core Quran text
CREATE TABLE verses (
  id INTEGER PRIMARY KEY,          -- 1-6236
  surah_number INTEGER NOT NULL,
  ayah_number INTEGER NOT NULL,
  text_uthmani TEXT NOT NULL,       -- Uthmani Arabic script
  text_simple TEXT NOT NULL,        -- Simplified Arabic (for search)
  page INTEGER NOT NULL,            -- Mushaf page 1-604
  juz INTEGER NOT NULL,             -- Juz 1-30
  hizb INTEGER NOT NULL,            -- Hizb 1-60
  UNIQUE(surah_number, ayah_number)
);

-- Translations (5 languages)
CREATE TABLE translations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  verse_id INTEGER NOT NULL REFERENCES verses(id),
  language TEXT NOT NULL,            -- 'en', 'fr', 'ur', 'tr', 'id'
  translator TEXT NOT NULL,          -- 'Sahih International', 'Muhammad Hamidullah', etc.
  text TEXT NOT NULL,
  UNIQUE(verse_id, language)
);
-- Translation sources:
--   English:    Sahih International (quran.com resource_id: 20)
--   French:     Muhammad Hamidullah (resource_id: 136)
--   Urdu:       Fateh Muhammad Jalandhry (resource_id: 54)
--   Turkish:    Diyanet İşleri (resource_id: 77)
--   Indonesian: Kemenag (resource_id: 33)

-- Arabic tafsir (Al-Muyassar)
CREATE TABLE tafsir (
  verse_id INTEGER PRIMARY KEY REFERENCES verses(id),
  text TEXT NOT NULL                 -- Al-Muyassar (resource_id: 16)
);

-- Verse audio timings (for synced highlighting)
CREATE TABLE verse_timings (
  verse_id INTEGER NOT NULL REFERENCES verses(id),
  reciter_id TEXT NOT NULL,          -- e.g. 'ar.alafasy'
  timestamp_from INTEGER NOT NULL,   -- milliseconds from surah start
  timestamp_to INTEGER NOT NULL,     -- milliseconds
  PRIMARY KEY(verse_id, reciter_id)
);

-- Surah metadata
CREATE TABLE surahs (
  number INTEGER PRIMARY KEY,
  name_arabic TEXT NOT NULL,
  name_english TEXT NOT NULL,
  verses_count INTEGER NOT NULL,
  start_page INTEGER NOT NULL,
  end_page INTEGER NOT NULL,
  revelation_type TEXT NOT NULL,    -- 'Meccan' or 'Medinan'
  juz_number INTEGER NOT NULL
);

-- Juz metadata
CREATE TABLE juz (
  number INTEGER PRIMARY KEY,
  name_arabic TEXT NOT NULL,
  start_page INTEGER NOT NULL,
  end_page INTEGER NOT NULL,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL
);

-- User bookmarks (verse-level)
CREATE TABLE bookmarks (
  id TEXT PRIMARY KEY,              -- UUID
  verse_id INTEGER NOT NULL REFERENCES verses(id),
  title TEXT,
  color TEXT DEFAULT '#FFD700',
  created_at TEXT NOT NULL
);

-- User notes
CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  verse_id INTEGER NOT NULL REFERENCES verses(id),
  text TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- User highlights
CREATE TABLE highlights (
  id TEXT PRIMARY KEY,
  verse_id INTEGER NOT NULL REFERENCES verses(id),
  color TEXT NOT NULL,              -- hex color
  created_at TEXT NOT NULL
);

-- Full-text search index
CREATE VIRTUAL TABLE verses_fts USING fts5(
  text_simple, text_uthmani, content=verses, content_rowid=id
);
CREATE VIRTUAL TABLE translations_fts USING fts5(
  text, content=translations, content_rowid=verse_id
);
CREATE VIRTUAL TABLE tafsir_fts USING fts5(
  text, content=tafsir, content_rowid=verse_id
);
```

Data sources (all public domain / free):
- Verses: Tanzil.net Uthmani text (scholar-verified)
- Translation: Sahih International via quran.com API or tanzil data
- Tafsir: Al-Muyassar (التفسير الميسر) from King Fahd Complex
- Page mapping: Standard Madani Mushaf 604-page layout

##### 5A.2 `lib/core/services/quran_database_service.dart`
- On first launch: copy `quran.db` from assets to app documents directory
- Provide `Database` instance via Riverpod Provider
- Version check for DB upgrades (add translations/tafsir later)
```dart
final quranDatabaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await _initDatabase();
  return openDatabase(dbPath, readOnly: false);
});
```

##### 5A.3 `lib/features/quran/data/datasources/quran_db_datasource.dart`
Core query methods:
- `getVersesForPage(int page)` → `List<VerseEntity>`
- `getVersesForSurah(int surahNumber)` → `List<VerseEntity>`
- `getVersesForJuz(int juzNumber)` → `List<VerseEntity>`
- `getTranslation(int verseId)` → `String`
- `getTafsir(int verseId)` → `String`
- `searchVerses(String query)` → `List<SearchResult>` (FTS5 search)
- `searchTranslations(String query)` → `List<SearchResult>`
- `searchTafsir(String query)` → `List<SearchResult>`
- `getSurahForPage(int page)` → `SurahEntity`
- `getAllSurahs()` → `List<SurahEntity>`
- `getAllJuz()` → `List<JuzEntity>`

##### 5A.4 `lib/features/quran/data/datasources/quran_user_data_datasource.dart`
User data CRUD (writes to same DB):
- `getBookmarks()`, `addBookmark(verseId, title, color)`, `removeBookmark(id)`
- `getNotes()`, `addNote(verseId, text)`, `updateNote(id, text)`, `deleteNote(id)`
- `getHighlights()`, `addHighlight(verseId, color)`, `removeHighlight(id)`
- `getHighlightsForPage(int page)` → for rendering highlighted verses

#### Sub-phase 5B: Quran Entities

##### 5B.1 `lib/features/quran/domain/entities/verse_entity.dart`
```dart
class VerseEntity {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String textUthmani;
  final String textSimple;
  final int page;
  final int juz;
  final int hizb;
}
```

##### 5B.2 `lib/features/quran/domain/entities/bookmark_entity.dart`
```dart
class BookmarkEntity {
  final String id;
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String? title;
  final String color;
  final DateTime createdAt;
}
```

##### 5B.3 `lib/features/quran/domain/entities/note_entity.dart`
##### 5B.4 `lib/features/quran/domain/entities/highlight_entity.dart`
##### 5B.5 `lib/features/quran/domain/entities/search_result_entity.dart`
```dart
class SearchResultEntity {
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String matchedText;  // snippet with match highlighted
  final String source;       // 'quran', 'translation', 'tafsir'
  final int page;
}
```

#### Sub-phase 5C: Quran Audio System

##### 5C.1 Update `lib/features/quran/data/datasources/quran_audio_datasource.dart`
- Load reciters from `reciters.json` (8 reciters already defined)
- **Surah-level audio**: `{reciter.audioBaseUrl}{surahNumber.padLeft(3,'0')}.mp3`
- **Verse-level audio** (for sync): Use `cdn.islamic.network/quran/audio/128/{reciterId}/{verseGlobalId}.mp3` — individual ayah audio files
- Cache management: download with `dio`, store in `path_provider` documents dir
- `isAudioCached(reciterId, surahNumber)`, `getCachedPath(...)`, `downloadAndCache(...)`

##### 5C.2 Verse-synced audio highlighting (surah-level audio + timing data)
- Play full surah MP3 from CDN (one file per surah per reciter)
- Verse timing data stored in `verse_timings` table in quran.db (fetched from quran.com API at build time)
- During playback: listen to `positionStream`, compare position (ms) against `timestamp_from`/`timestamp_to` for current reciter
- When position enters a verse's time range → emit `activeVerseId` → UI highlights that verse
- On verse boundary crossing → trigger smooth highlight transition animation
- Timing data fetched via: `GET /recitations/{recitation_id}/by_chapter/{chapter}` from quran.com API

##### 5C.3 `lib/features/quran/presentation/providers/audio_player_provider.dart`
```dart
class QuranAudioState {
  final AudioPlaybackStatus status; // idle, loading, playing, paused, error
  final ReciterEntity currentReciter;
  final int currentSurahNumber;
  final int? activeVerseId;         // currently playing verse (for highlight sync)
  final Duration position;
  final Duration duration;
  final bool isBuffering;
  final bool autoAdvanceSurah;      // auto-play next surah when done
}
```
Methods:
- `playSurah(int surahNumber)` — stream or play cached surah audio
- `playFromVerse(int surahNumber, int ayahNumber)` — start from specific verse
- `pause()`, `resume()`, `stop()`
- `selectReciter(ReciterEntity)` — persist choice, stop current
- `seekTo(Duration)` / `seekToVerse(int ayahNumber)`
- Listen to position stream → emit `activeVerseId` changes for UI highlighting

#### Sub-phase 5D: Reading Modes & Reader Screen

##### 5D.1 Reading Mode Enum
```dart
enum QuranReadingMode {
  mushafPage,        // Page-by-page like physical Mushaf (604 pages)
  scrolling,         // Continuous vertical scroll of verses
  verticalPagination // Vertical page-by-page (one screen of verses at a time)
}
```

##### 5D.2 `lib/features/quran/presentation/screens/quran_reader_screen.dart`
Full-screen `Scaffold` with `extendBodyBehindAppBar: true`.

**Body**: `Stack` containing:
1. **Reading view** (switches based on mode):
   - **Mushaf mode**: `PageView.builder(itemCount: 604, reverse: true)` — each page renders verses for that page in Mushaf layout (centered, Uthmani font, surah headers with bismillah). This is the default and most important mode.
   - **Scrolling mode**: `ScrollablePositionedList` of all verses in current surah/juz, each as a `VerseWidget`. Continuous scrolling, no page breaks.
   - **Vertical pagination**: `PageView` where each "page" is a screen's worth of verses (auto-calculated by available height).
2. **Top overlay bar** (toggle on tap):
   - Current surah name (Arabic) + page number
   - Close button
   - Search icon → opens search screen
   - Reading mode switcher icon
   - Bookmark indicator (filled if current verse/page bookmarked)
3. **Bottom overlay bar** (toggle on tap):
   - Page slider (drag to jump — Mushaf mode)
   - Audio controls: play/pause, skip verse, reciter name (tap to open picker)
   - Translation toggle (show/hide English below each verse)
   - Tafsir button (opens bottom sheet)
   - Bookmark add button
4. **Audio player mini-bar** (visible when audio is active, docked above bottom bar):
   - Reciter name, surah name, play/pause, progress bar
5. **Verse highlight overlay**: When audio plays, the currently-recited verse gets a colored background tint

**Tap interactions:**
- Tap center → toggle overlay visibility
- Tap a verse → show verse action menu (bookmark, note, highlight, copy, share, tafsir)
- Long-press verse → select multiple verses for copy/share
- Pinch-to-zoom (Mushaf mode) for font size
- Double-tap → toggle full-screen (hide status bar)

**Constructor**: accepts `initialPage`, `initialSurah`, `initialVerse`, `readingMode`

##### 5D.3 `lib/features/quran/presentation/widgets/mushaf_page_view.dart`
Renders a single Mushaf page:
- Query `getVersesForPage(pageNumber)` from DB
- Layout: centered Arabic text (Uthmani, Amiri font, ~22-26sp)
- Surah header: decorative banner with surah name when surah starts on this page
- Bismillah line between surahs (except At-Tawbah)
- Verse number markers (۝١, ۝٢...) inline with text
- Active verse highlight (golden tint background) when audio is playing
- Highlighted verses (user highlights) shown with colored underline
- Bookmarked verses show small ribbon icon

##### 5D.4 `lib/features/quran/presentation/widgets/verse_widget.dart`
Used in scrolling and vertical pagination modes:
- Arabic text (Uthmani, large, RTL)
- Optional translation text below (English, smaller, LTR)
- Verse number badge
- Highlight color strip (if user-highlighted)
- Bookmark ribbon (if bookmarked)
- Tap → verse actions menu
- Active state (audio sync highlight)

##### 5D.5 `lib/features/quran/presentation/widgets/verse_actions_menu.dart`
Popup or bottom sheet when user taps a verse:
- **Bookmark** — add/remove bookmark for this verse
- **Note** — add/edit note on this verse
- **Highlight** — pick a color (5 colors: yellow, green, blue, pink, orange)
- **Tafsir** — show tafsir for this verse in bottom sheet
- **Copy** — copy verse text (Arabic, translation, or both)
- **Share** — share verse as text via share_plus

##### 5D.6 Auto-scroll feature
- When enabled: smooth auto-scroll at adjustable speed (1x, 1.5x, 2x, 0.5x)
- Speed slider in bottom overlay
- Works in scrolling mode and vertical pagination mode
- Pause auto-scroll on user touch, resume after 3 seconds

#### Sub-phase 5E: Tafsir & Translation

##### 5E.1 `lib/features/quran/presentation/widgets/tafsir_bottom_sheet.dart`
- `DraggableScrollableSheet` showing tafsir for current verse or page
- Tabs at top if multiple tafsir available (v1: just Al-Muyassar)
- Arabic text, scrollable
- "Next verse" / "Previous verse" buttons to navigate without closing

##### 5E.2 Translation toggle & language picker
- State in `quranReaderProvider`: `showTranslation` (bool), `translationLanguage` (String: 'en'|'fr'|'ur'|'tr'|'id')
- 5 bundled translations: English (Sahih International), French (Hamidullah), Urdu (Jalandhry), Turkish (Diyanet), Indonesian (Kemenag)
- When enabled: each verse renders with selected translation below it
- In Mushaf mode: translation appears as a bottom overlay for the tapped verse
- In scrolling/pagination mode: translation inline under each verse
- Language picker in reader bottom bar or settings — persisted in shared_preferences
- Translation text queried from `translations` table filtered by language code

#### Sub-phase 5F: Search

##### 5F.1 `lib/features/quran/presentation/screens/quran_search_screen.dart`
- Search bar with auto-search (debounced 300ms)
- Tab bar: "Quran" | "Translation" | "Tafsir" — search scope
- Results list: each result shows surah name, ayah number, matched snippet with highlight
- Tap result → navigate to `QuranReaderScreen(initialVerse: ...)`
- Uses FTS5 virtual tables for fast full-text search
- Recent searches list (stored in shared_preferences)

#### Sub-phase 5G: Bookmarks, Notes, Highlights Management

##### 5G.1 `lib/features/quran/presentation/screens/bookmarks_screen.dart`
- List of all bookmarks sorted by creation date
- Each tile: colored ribbon, surah name, ayah number, user title, date
- Swipe to delete, tap to navigate to verse
- Filter by color

##### 5G.2 `lib/features/quran/presentation/screens/notes_screen.dart`
- List of all user notes
- Each tile: verse reference, note preview, date
- Tap to view/edit, swipe to delete

##### 5G.3 Providers for user data
`lib/features/quran/presentation/providers/bookmark_provider.dart`
`lib/features/quran/presentation/providers/notes_provider.dart`
`lib/features/quran/presentation/providers/highlights_provider.dart`
- Each is an `AsyncNotifier` that loads from DB and exposes CRUD methods
- Cache in memory for fast lookups during reading

#### Sub-phase 5H: Navigation Screens

##### 5H.1 Update `lib/features/quran/presentation/screens/quran_home_screen.dart`
- Replace hardcoded text with real data
- Show last-read position with "Continue Reading" button
- Khatmah progress card (if active)
- Quick browse: By Surah, By Juz, Bookmarks, Search
- Reading stats: last page, streak, total pages read

##### 5H.2 Update `lib/features/quran/presentation/screens/surah_index_screen.dart`
- Search bar at top (filter by Arabic/English name)
- Each tile: surah number (decorative), Arabic name, English name, verse count, revelation type
- `onTap` → `QuranReaderScreen(initialSurah: surah.number)`

##### 5H.3 Create `lib/features/quran/presentation/screens/juz_index_screen.dart`
- List 30 juz from DB
- Each tile: juz number, Arabic name, page range
- `onTap` → `QuranReaderScreen(initialPage: juz.startPage)`

##### 5H.4 Create `lib/features/quran/presentation/widgets/reciter_picker_sheet.dart`
- `DraggableScrollableSheet` with all 8 reciters
- Arabic + English name, style tag
- Selected reciter highlighted
- On select → update provider, persist

#### Sub-phase 5I: Quran Reader Provider

##### 5I.1 `lib/features/quran/presentation/providers/quran_reader_provider.dart`
```dart
class QuranReaderState {
  final int currentPage;           // 1-604
  final int currentSurahNumber;
  final String currentSurahName;
  final QuranReadingMode readingMode;
  final bool isOverlayVisible;
  final bool showTranslation;
  final bool isAutoScrolling;
  final double autoScrollSpeed;    // 0.5, 1.0, 1.5, 2.0
  final int? activeVerseId;        // verse being recited (audio sync)
  final Set<int> bookmarkedVerseIds;  // cached for fast lookup
  final Set<int> highlightedVerseIds; // cached
}
```
Methods:
- `goToPage(int)`, `goToSurah(int)`, `goToVerse(int surah, int ayah)`
- `onPageChanged(int)` — update surah name, persist last-read
- `toggleOverlay()`, `toggleTranslation()`, `setReadingMode(mode)`
- `toggleAutoScroll()`, `setAutoScrollSpeed(double)`
- `onAudioVerseChanged(int verseId)` — update active verse for highlighting

---

### Phase 6: Tasbih Persistence
**Goal:** Sessions saved to disk, real history display.
**Depends on:** Phase 1

#### 6.1 `lib/features/tasbih/domain/entities/tasbih_session.dart`
- Fields: `dhikrArabic`, `dhikrTransliteration`, `count`, `target`, `timestamp`
- `toJson()` / `fromJson()`

#### 6.2 `lib/features/tasbih/presentation/providers/tasbih_provider.dart`
- `TasbihNotifier`: `increment()`, `reset()`, `saveSession()`, `getHistory()`, `selectDhikr()`
- Persists sessions as JSON list in StorageService

#### 6.3 Refactor `tasbih_screen.dart`
- `ConsumerStatefulWidget` (needs AnimationController)
- Real save + real history display

---

### Phase 7: Notifications
**Goal:** Prayer time and athkar reminder notifications + daily verse.
**Depends on:** Phase 1, Phase 3

#### 7.1 Add `flutter_local_notifications: ^17.0.0`
- Platform-specific setup (Android channels, iOS permissions)

#### 7.2 `lib/core/services/notification_service.dart`
- `schedulePrayerNotification(prayerName, time, minutesBefore)`
- `scheduleAthkarReminder(category, timeOfDay)`
- `scheduleDailyVerseNotification(timeOfDay)` — picks random verse, shows as notification
- `cancelPrayer(name)`, `cancelAll()`

#### 7.3 Integrate with Prayer Times + Settings

---

### Phase 8: Qibla Feature
**Goal:** Working Qibla compass.
**Depends on:** Phase 1

#### 8.1 Add `flutter_compass: ^0.8.0`

#### 8.2 `lib/features/qibla/presentation/providers/qibla_provider.dart`
- Uses `adhan` package's `Qibla(Coordinates(lat, lng)).direction`
- Combines with `FlutterCompass.events` stream

#### 8.3 `lib/features/qibla/presentation/screens/qibla_screen.dart`
- `CustomPainter` compass with Qibla arrow
- Smooth rotation animation

#### 8.4 Update `app_shell.dart` — replace placeholder

---

### Phase 9: UI Polish + Bug Fixes
**Goal:** Fix all bugs, wire loose ends, polish UX.

#### 9.1 Fix Home Screen countdown — use stream snapshot properly
#### 9.2 Wire Quick Access cards — create `tabIndexProvider`, use in AppShell + Home
#### 9.3 Daily verse rotation — `assets/data/daily_verses.json` (30+ verses)
#### 9.4 Pull-to-refresh on Prayer Times and Athkar
#### 9.5 Athkar completion celebration animation
#### 9.6 Quran verse copy/share via `share_plus`

---

## 6. File Creation Order

```
Phase 1 — Core (13 files):
 1. lib/core/constants/app_spacing.dart                    (new)
 2. lib/core/constants/app_assets.dart                     (new)
 3. lib/core/utils/hijri_date.dart                         (new)
 4. lib/core/services/storage_service.dart                  (new)
 5. lib/core/services/location_service.dart                 (new)
 6. lib/core/services/audio_service.dart                    (new)
 7-10. lib/core/widgets/{loading,error,empty,section}       (new)
 11. lib/main.dart                                          (update)
 12. lib/core/widgets/islamic_card.dart                     (fix)
 13. lib/core/theme/app_theme.dart                          (fix)

Phase 2 — Localization (3+ files):
 14. lib/l10n/app_en.arb                                   (new)
 15. lib/l10n/app_ar.arb                                   (new)
 16. l10n.yaml                                             (new)
 17. lib/app.dart                                          (update)
 18-24. All screens                                        (update — replace hardcoded strings)

Phase 3 — Settings (4 files):
 25. lib/features/settings/providers/settings_provider.dart (new)
 26. lib/core/theme/app_theme.dart                          (add dark theme)
 27. lib/app.dart                                           (update)
 28. lib/features/settings/screens/settings_screen.dart     (refactor)

Phase 4 — Athkar (9 files):
 29-34. assets/data/athkar_*.json                           (6 new)
 35. athkar_local_datasource.dart                           (refactor)
 36. athkar_provider.dart                                   (refactor)
 37. athkar_home_screen.dart + list + detail                (update)

Phase 5 — Quran (20+ files):
 38. assets/data/quran.db                                   (new — pre-built SQLite)
 39. lib/core/services/quran_database_service.dart           (new)
 40. quran_db_datasource.dart                               (new)
 41. quran_user_data_datasource.dart                        (new)
 42. quran_audio_datasource.dart                            (new)
 43. verse_entity.dart + bookmark + note + highlight + search_result  (5 new)
 44. quran_reader_provider.dart                             (new)
 45. audio_player_provider.dart                             (new)
 46. bookmark_provider.dart                                 (new)
 47. notes_provider.dart                                    (new)
 48. highlights_provider.dart                               (new)
 49. quran_reader_screen.dart                               (new — main reader)
 50. mushaf_page_view.dart                                  (new)
 51. verse_widget.dart                                      (new)
 52. verse_actions_menu.dart                                (new)
 53. tafsir_bottom_sheet.dart                               (new)
 54. reciter_picker_sheet.dart                              (new)
 55. quran_search_screen.dart                               (new)
 56. bookmarks_screen.dart                                  (new)
 57. notes_screen.dart                                      (new)
 58. juz_index_screen.dart                                  (new)
 59. quran_home_screen.dart                                 (update)
 60. surah_index_screen.dart                                (update)

Phase 6 — Tasbih (3 files):
 61. tasbih_session.dart                                    (new)
 62. tasbih_provider.dart                                   (new)
 63. tasbih_screen.dart                                     (refactor)

Phase 7 — Notifications (2 files):
 64. notification_service.dart                              (new)
 65. Platform configs                                       (update)

Phase 8 — Qibla (3 files):
 66. qibla_provider.dart                                    (new)
 67. qibla_screen.dart                                      (new)
 68. app_shell.dart                                         (update)

Phase 9 — Polish (5+ files):
 69-73. Bug fixes across home, prayer, navigation screens
 74. assets/data/daily_verses.json                          (new)
```

**Total: ~74 file operations (new + updates)**

---

## 7. Verification Plan

| Phase | Test |
|-------|------|
| 1 | `flutter run` — app launches, StorageService reads/writes |
| 2 | Switch language to Arabic — all UI strings change, layout flips RTL |
| 3 | Toggle dark mode, restart — theme persists. All settings survive restart |
| 4 | Complete morning athkar, restart — progress persists. All 8 categories work |
| 5A | Open Quran reader — real Arabic text on all 604 pages |
| 5B | Switch reading modes — Mushaf, scrolling, vertical pagination all work |
| 5C | Play audio — verse highlights in sync with recitation |
| 5D | Tap verse → bookmark, note, highlight, copy, share all work |
| 5E | Open tafsir → Arabic explanation shows for current verse |
| 5F | Search "الرحمن" → finds all matching verses + translations + tafsir |
| 6 | Save tasbih session, restart — appears in history |
| 7 | Enable prayer notification — fires at correct time |
| 8 | Open Qibla — compass rotates, arrow points toward Mecca |
| 9 | Countdown updates every second. Quick access navigates. Daily verse rotates |

**Final:** Full cold-start test on clean device — all features end-to-end.
