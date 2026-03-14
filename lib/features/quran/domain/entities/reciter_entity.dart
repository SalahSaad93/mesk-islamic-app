class ReciterEntity {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final String style;
  final String audioBaseUrl;

  const ReciterEntity({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.style,
    required this.audioBaseUrl,
  });

  factory ReciterEntity.fromJson(Map<String, dynamic> json) => ReciterEntity(
    id: json['id'] as String,
    nameArabic: json['nameArabic'] as String,
    nameEnglish: json['nameEnglish'] as String,
    style: json['style'] as String,
    audioBaseUrl: json['audioBaseUrl'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameArabic': nameArabic,
    'nameEnglish': nameEnglish,
    'style': style,
    'audioBaseUrl': audioBaseUrl,
  };
}
