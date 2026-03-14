class KhatmaProgressEntity {
  final int highestPage;
  final int totalPages;
  final DateTime startDate;
  final bool isCompleted;

  const KhatmaProgressEntity({
    required this.highestPage,
    required this.totalPages,
    required this.startDate,
    this.isCompleted = false,
  });

  double get percentage {
    if (totalPages == 0) return 0.0;
    return (highestPage / totalPages) * 100;
  }

  KhatmaProgressEntity copyWith({
    int? highestPage,
    int? totalPages,
    DateTime? startDate,
    bool? isCompleted,
  }) {
    return KhatmaProgressEntity(
      highestPage: highestPage ?? this.highestPage,
      totalPages: totalPages ?? this.totalPages,
      startDate: startDate ?? this.startDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory KhatmaProgressEntity.fromMap(Map<String, dynamic> map) =>
      KhatmaProgressEntity(
        highestPage: map['highest_page'] as int,
        totalPages: map['total_pages'] as int,
        startDate: DateTime.parse(map['start_date'] as String),
        isCompleted: map['completed'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => {
        'highest_page': highestPage,
        'total_pages': totalPages,
        'start_date': startDate.toIso8601String(),
        'completed': isCompleted,
      };
}
