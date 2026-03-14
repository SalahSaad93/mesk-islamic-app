class TranslationModel {
  final int verseId;
  final String language;
  final String text;
  final String translator;

  const TranslationModel({
    required this.verseId,
    required this.language,
    required this.text,
    required this.translator,
  });

  factory TranslationModel.fromMap(Map<String, dynamic> map) =>
      TranslationModel(
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

  @override
  String toString() =>
      'TranslationModel(verseId: $verseId, language: $language, text: $text, translator: $translator)';
}
