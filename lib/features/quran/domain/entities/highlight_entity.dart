class HighlightEntity {
  final String id;
  final int verseId;
  final int surahNumber;
  final int ayahNumber;
  final String color;
  final DateTime createdAt;

  const HighlightEntity({
    required this.id,
    required this.verseId,
    required this.surahNumber,
    required this.ayahNumber,
    this.color = '#FFFF00',
    required this.createdAt,
  });

  factory HighlightEntity.fromMap(Map<String, dynamic> map) => HighlightEntity(
    id: map['id'] as String,
    verseId: map['verse_id'] as int,
    surahNumber: map['surah_number'] as int? ?? 0,
    ayahNumber: map['ayah_number'] as int? ?? 0,
    color: map['color'] as String? ?? '#FFFF00',
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'verse_id': verseId,
    'surah_number': surahNumber,
    'ayah_number': ayahNumber,
    'color': color,
    'created_at': createdAt.toIso8601String(),
  };

  HighlightEntity copyWith({
    String? id,
    int? verseId,
    int? surahNumber,
    int? ayahNumber,
    String? color,
    DateTime? createdAt,
  }) {
    return HighlightEntity(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
