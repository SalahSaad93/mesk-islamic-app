enum ReadingMode {
  verseMode,
  fullQuranMode,
}

class ReadingPreferencesEntity {
  final int fontSize;
  final bool nightMode;
  final bool showTranslation;

  const ReadingPreferencesEntity({
    this.fontSize = 2,
    this.nightMode = false,
    this.showTranslation = false,
  });

  ReadingPreferencesEntity copyWith({
    int? fontSize,
    bool? nightMode,
    bool? showTranslation,
  }) {
    return ReadingPreferencesEntity(
      fontSize: fontSize ?? this.fontSize,
      nightMode: nightMode ?? this.nightMode,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }

  factory ReadingPreferencesEntity.fromMap(Map<String, dynamic> map) =>
      ReadingPreferencesEntity(
        fontSize: map['font_size'] as int? ?? 2,
        nightMode: map['night_mode'] as bool? ?? false,
        showTranslation: map['show_translation'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => {
        'font_size': fontSize,
        'night_mode': nightMode,
        'show_translation': showTranslation,
      };
}
