class TafsirEntity {
  final int verseId;
  final String source;
  final String text;
  final DateTime? cachedAt;

  const TafsirEntity({
    required this.verseId,
    required this.source,
    required this.text,
    this.cachedAt,
  });

  factory TafsirEntity.fromMap(Map<String, dynamic> map) => TafsirEntity(
    verseId: map['verse_id'] as int,
    source: map['source'] as String,
    text: map['text'] as String,
    cachedAt: map['cached_at'] != null
        ? DateTime.parse(map['cached_at'] as String)
        : null,
  );

  Map<String, dynamic> toMap() {
    final map = {
      'verse_id': verseId,
      'source': source,
      'text': text,
    };

    if (cachedAt != null) {
      map['cached_at'] = cachedAt!.toIso8601String();
    }

    return map;
  }
}
