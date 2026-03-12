class NoteEntity {
  final String id;
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteEntity({
    required this.id,
    required this.verseId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteEntity.fromMap(Map<String, dynamic> map) => NoteEntity(
    id: map['id'] as String,
    verseId: map['verse_id'] as int,
    surahNumber: map['surah_number'] as int? ?? 0,
    ayahNumber: map['ayah_number'] as int? ?? 0,
    surahName: map['surah_name'] as String? ?? '',
    text: map['text'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'verse_id': verseId,
    'surah_number': surahNumber,
    'ayah_number': ayahNumber,
    'surah_name': surahName,
    'text': text,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  NoteEntity copyWith({
    String? id,
    int? verseId,
    int? surahNumber,
    int? ayahNumber,
    String? surahName,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      surahName: surahName ?? this.surahName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
