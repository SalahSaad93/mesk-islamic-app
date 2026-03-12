# Data Model & Storage Contracts

This file defines the structured payloads being passed through the features' `domain` and `data` layers when storing and restoring.

## Feature: 003-missing-features 

### NoteEntity

Stored locally inside `sqlite` database `notes` table or SharedPreferences array.
```dart
class NoteEntity {
  final String id; // UUID
  final int verseId; // Foreign reference to Quran table
  final String text; // Max Length: 2000
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### HighlightEntity

Stored locally inside `sqlite` database `highlights` table.
```dart
class HighlightEntity {
  final String id; // UUID
  final int verseId; 
  final String color; // e.g. '#FFD700'
  final DateTime createdAt;
}
```

### BookmarkEntity

```dart
class BookmarkEntity {
  final String id;
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String surahName; // UI convenience
  final String? title; 
  final String color;
  final DateTime createdAt;
}
```

### ReciterEntity

Read from `assets/data/reciters.json`.

```dart
class ReciterEntity {
  final String id; // 'ar.alafasy'
  final String nameArabic; 
  final String nameEnglish;
  final String style;
  final String audioBaseUrl; 
}
```
