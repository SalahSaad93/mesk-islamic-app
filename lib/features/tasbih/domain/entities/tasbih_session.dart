import 'dart:convert';

class TasbihSession {
  final String arabic;
  final String transliteration;
  final int count;
  final int target;
  final DateTime timestamp;

  const TasbihSession({
    required this.arabic,
    required this.transliteration,
    required this.count,
    required this.target,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'arabic': arabic,
    'transliteration': transliteration,
    'count': count,
    'target': target,
    'timestamp': timestamp.toIso8601String(),
  };

  factory TasbihSession.fromJson(Map<String, dynamic> json) => TasbihSession(
    arabic: json['arabic'] as String,
    transliteration: json['transliteration'] as String,
    count: json['count'] as int,
    target: json['target'] as int,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  static List<TasbihSession> listFromJson(String jsonString) {
    final List<dynamic> list = json.decode(jsonString);
    return list.map((e) => TasbihSession.fromJson(e)).toList();
  }

  static String listToJson(List<TasbihSession> sessions) =>
      json.encode(sessions.map((s) => s.toJson()).toList());
}
