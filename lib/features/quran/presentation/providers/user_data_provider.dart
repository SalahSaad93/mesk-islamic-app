import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/note_entity.dart';
import 'quran_repository_provider.dart';

// --- Bookmarks ---

final bookmarksProvider = AsyncNotifierProvider<BookmarksNotifier, List<BookmarkEntity>>(() {
  return BookmarksNotifier();
});

class BookmarksNotifier extends AsyncNotifier<List<BookmarkEntity>> {
  @override
  Future<List<BookmarkEntity>> build() {
    return ref.watch(quranRepositoryProvider).getAllBookmarks();
  }

  Future<void> toggleBookmark(BookmarkEntity bookmark) async {
    final repo = ref.read(quranRepositoryProvider);
    final existing = await repo.getBookmarkForVerse(bookmark.verseId);

    if (existing != null) {
      await repo.deleteBookmark(existing.id);
    } else {
      await repo.addBookmark(bookmark);
    }
    ref.invalidateSelf();
  }
}

// --- Highlights ---

final highlightsProvider = AsyncNotifierProvider<HighlightsNotifier, List<HighlightEntity>>(() {
  return HighlightsNotifier();
});

class HighlightsNotifier extends AsyncNotifier<List<HighlightEntity>> {
  @override
  Future<List<HighlightEntity>> build() {
    return ref.watch(quranRepositoryProvider).getAllHighlights();
  }

  Future<void> addHighlight(HighlightEntity highlight) async {
    await ref.read(quranRepositoryProvider).addHighlight(highlight);
    ref.invalidateSelf();
  }

  Future<void> deleteHighlightForVerse(int verseId) async {
    await ref.read(quranRepositoryProvider).deleteHighlightForVerse(verseId);
    ref.invalidateSelf();
  }
}

// --- Notes ---

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<NoteEntity>>(() {
  return NotesNotifier();
});

class NotesNotifier extends AsyncNotifier<List<NoteEntity>> {
  @override
  Future<List<NoteEntity>> build() {
    return ref.watch(quranRepositoryProvider).getAllNotes();
  }

  Future<void> saveNote(NoteEntity note) async {
    final repo = ref.read(quranRepositoryProvider);
    final existing = await repo.getNoteForVerse(note.verseId);

    if (existing != null) {
      await repo.updateNote(note.copyWith(id: existing.id));
    } else {
      await repo.addNote(note);
    }
    ref.invalidateSelf();
  }

  Future<void> deleteNote(String id) async {
    await ref.read(quranRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
  }
}

final highlightsForPageProvider =
    FutureProvider.family<Map<int, HighlightEntity>, int>((ref, page) async {
  return ref.read(quranRepositoryProvider).getHighlightsForPage(page);
});
