class JuzEntity {
  final int juzNumber;
  final String nameArabic;
  final int startSurah;
  final int startAyah;
  final int endSurah;
  final int endAyah;
  final int startPage;
  final int endPage;

  const JuzEntity({
    required this.juzNumber,
    required this.nameArabic,
    required this.startSurah,
    required this.startAyah,
    required this.endSurah,
    required this.endAyah,
    required this.startPage,
    required this.endPage,
  });

  factory JuzEntity.fromMap(Map<String, dynamic> map) => JuzEntity(
    juzNumber: map['juz_number'] as int,
    nameArabic: map['name_arabic'] as String,
    startSurah: map['start_surah'] as int,
    startAyah: map['start_ayah'] as int,
    endSurah: map['end_surah'] as int,
    endAyah: map['end_ayah'] as int,
    startPage: map['start_page'] as int,
    endPage: map['end_page'] as int,
  );
}
