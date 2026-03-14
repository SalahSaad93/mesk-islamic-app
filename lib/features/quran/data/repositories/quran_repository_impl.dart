import '../../domain/entities/bookmark_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_user_data_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranUserDataDatasource _userDataDatasource;

  QuranRepositoryImpl(this._userDataDatasource);

  @override
  Future<List<BookmarkEntity>> getAllBookmarks() => _userDataDatasource.getAllBookmarks();

  @override
  Future<BookmarkEntity?> getBookmarkForVerse(int verseId) =>
      _userDataDatasource.getBookmarkForVerse(verseId);

  @override
  Future<void> addBookmark(BookmarkEntity bookmark) => _userDataDatasource.addBookmark(bookmark);

  @override
  Future<void> deleteBookmark(String id) => _userDataDatasource.deleteBookmark(id);

  @override
  Future<List<NoteEntity>> getAllNotes() => _userDataDatasource.getAllNotes();

  @override
  Future<NoteEntity?> getNoteForVerse(int verseId) => _userDataDatasource.getNoteForVerse(verseId);

  @override
  Future<void> addNote(NoteEntity note) => _userDataDatasource.addNote(note);

  @override
  Future<void> updateNote(NoteEntity note) => _userDataDatasource.updateNote(note);

  @override
  Future<void> deleteNote(String id) => _userDataDatasource.deleteNote(id);

  @override
  Future<List<HighlightEntity>> getAllHighlights() => _userDataDatasource.getAllHighlights();

  @override
  Future<HighlightEntity?> getHighlightForVerse(int verseId) =>
      _userDataDatasource.getHighlightForVerse(verseId);

  @override
  Future<Map<int, HighlightEntity>> getHighlightsForPage(int page) =>
      _userDataDatasource.getHighlightsForPage(page);

  @override
  Future<void> addHighlight(HighlightEntity highlight) => _userDataDatasource.addHighlight(highlight);

  @override
  Future<void> deleteHighlight(String id) => _userDataDatasource.deleteHighlight(id);

  @override
  Future<void> deleteHighlightForVerse(int verseId) =>
      _userDataDatasource.deleteHighlightForVerse(verseId);
}
