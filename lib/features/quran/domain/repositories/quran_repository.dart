import '../entities/bookmark_entity.dart';
import '../entities/highlight_entity.dart';
import '../entities/note_entity.dart';

abstract class QuranRepository {
  // Bookmarks
  Future<List<BookmarkEntity>> getAllBookmarks();
  Future<BookmarkEntity?> getBookmarkForVerse(int verseId);
  Future<void> addBookmark(BookmarkEntity bookmark);
  Future<void> deleteBookmark(String id);

  // Notes
  Future<List<NoteEntity>> getAllNotes();
  Future<NoteEntity?> getNoteForVerse(int verseId);
  Future<void> addNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String id);

  // Highlights
  Future<List<HighlightEntity>> getAllHighlights();
  Future<HighlightEntity?> getHighlightForVerse(int verseId);
  Future<Map<int, HighlightEntity>> getHighlightsForPage(int page);
  Future<void> addHighlight(HighlightEntity highlight);
  Future<void> deleteHighlight(String id);
  Future<void> deleteHighlightForVerse(int verseId);
}
