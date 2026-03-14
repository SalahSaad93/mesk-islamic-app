class TranslationEntity {
  final int verseId;
  final String language;
  final String text;
  final String translator;

  const TranslationEntity({
    required this.verseId,
    required this.language,
    required this.text,
    required this.translator,
  });

  factory TranslationEntity.fromMap(Map<String, dynamic> map) => TranslationEntity(
    verseId: map['verse_id'] as int,
    language: map['language'] as String,
    text: map['text'] as String,
    translator: map['translator'] as String,
  );

  Map<String, dynamic> toMap() => {
    'verse_id': verseId,
    'language': language,
    'text': text,
    'translator': translator,
  };
}
