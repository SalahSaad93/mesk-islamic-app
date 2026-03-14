class VersePositionEntity {
  final int surahNumber;
  final int ayahNumber;
  final int page;

  const VersePositionEntity({
    required this.surahNumber,
    required this.ayahNumber,
    required this.page,
  });

  factory VersePositionEntity.fromMap(Map<String, dynamic> map) =>
      VersePositionEntity(
        surahNumber: map['surah_number'] as int,
        ayahNumber: map['ayah_number'] as int,
        page: map['page'] as int,
      );

  Map<String, dynamic> toMap() => {
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'page': page,
      };

  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VersePositionEntity &&
        other.surahNumber == surahNumber &&
        other.ayahNumber == ayahNumber &&
        other.page == page;
  }

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode ^ page.hashCode;

  @override
  String toString() =>
      'VersePositionEntity(surahNumber: $surahNumber, ayahNumber: $ayahNumber, page: $page)';
}
