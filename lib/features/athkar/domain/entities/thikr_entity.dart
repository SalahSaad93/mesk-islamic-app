class ThikrEntity {
  final int id;
  final String arabic;
  final String translation;
  final String transliteration;
  final String source;
  final int repeatCount;
  final String category;
  final String reference;

  const ThikrEntity({
    required this.id,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.source,
    required this.repeatCount,
    required this.category,
    required this.reference,
  });
}
