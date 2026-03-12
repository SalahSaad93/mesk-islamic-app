class VerseEntity {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String textUthmani;
  final String textSimple;
  final int page;
  final int juz;
  final int hizb;

  const VerseEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textUthmani,
    required this.textSimple,
    required this.page,
    required this.juz,
    required this.hizb,
  });

  factory VerseEntity.fromMap(Map<String, dynamic> map) => VerseEntity(
    id: map['id'] as int,
    surahNumber: map['surah_number'] as int,
    ayahNumber: map['ayah_number'] as int,
    textUthmani: map['text_uthmani'] as String,
    textSimple: map['text_simple'] as String,
    page: map['page'] as int,
    juz: map['juz'] as int,
    hizb: map['hizb'] as int,
  );
}
