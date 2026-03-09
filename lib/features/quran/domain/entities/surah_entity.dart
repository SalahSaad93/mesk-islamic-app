class SurahEntity {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final int versesCount;
  final int startPage;
  final int endPage;
  final String revelationType;
  final int juzNumber;

  const SurahEntity({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.versesCount,
    required this.startPage,
    required this.endPage,
    required this.revelationType,
    required this.juzNumber,
  });

  factory SurahEntity.fromJson(Map<String, dynamic> json) {
    return SurahEntity(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      versesCount: json['versesCount'] as int,
      startPage: json['startPage'] as int,
      endPage: json['endPage'] as int,
      revelationType: json['revelationType'] as String,
      juzNumber: json['juzNumber'] as int,
    );
  }
}
