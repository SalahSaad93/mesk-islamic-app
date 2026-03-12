class HijriDate {
  HijriDate._(); // Prevent instantiation

  static int _toJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  static String format(DateTime date, {String fallback = 'Hijri Date'}) {
    final julianDay = _toJulianDay(date);
    final hijriDay = julianDay - 1948440 + 10632;
    final n = ((hijriDay - 1) ~/ 10631);
    final hijriDay2 = hijriDay - 10631 * n + 354;
    final j = ((10985 - hijriDay2) ~/ 5316) * ((50 * hijriDay2) ~/ 17719) +
        (hijriDay2 ~/ 5670) * ((43 * hijriDay2) ~/ 15238);
    final hijriDay3 = hijriDay2 -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * hijriDay3) ~/ 709;
    final day = hijriDay3 - (709 * month) ~/ 24;
    final year = 30 * n + j - 30;

    final hijriMonths = [
      'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
      "Jumada al-Ula", "Jumada al-Akhirah", 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", "Dhu al-Hijjah"
    ];

    try {
      final monthName = hijriMonths[(month - 1).clamp(0, 11)];
      return '$day $monthName $year';
    } catch (_) {
      return fallback;
    }
  }
}
