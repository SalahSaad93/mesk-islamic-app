class BookmarkEntity {
  final String id;
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String? title;
  final String color;
  final DateTime createdAt;

  const BookmarkEntity({
    required this.id,
    required this.verseId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    this.title,
    this.color = '#FFD700',
    required this.createdAt,
  });

  factory BookmarkEntity.fromMap(Map<String, dynamic> map) => BookmarkEntity(
    id: map['id'] as String,
    verseId: map['verse_id'] as int,
    surahNumber: map['surah_number'] as int? ?? 0,
    ayahNumber: map['ayah_number'] as int? ?? 0,
    surahName: map['surah_name'] as String? ?? '',
    title: map['title'] as String?,
    color: map['color'] as String? ?? '#FFD700',
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'verse_id': verseId,
    'surah_number': surahNumber,
    'ayah_number': ayahNumber,
    'surah_name': surahName,
    'title': title,
    'color': color,
    'created_at': createdAt.toIso8601String(),
  };

  BookmarkEntity copyWith({
    String? id,
    int? verseId,
    int? surahNumber,
    int? ayahNumber,
    String? surahName,
    String? title,
    String? color,
    DateTime? createdAt,
  }) {
    return BookmarkEntity(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      surahName: surahName ?? this.surahName,
      title: title ?? this.title,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
