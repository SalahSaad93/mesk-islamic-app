class PrayerTimesEntity {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;
  final String locationName;
  final String calculationMethod;

  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.locationName,
    required this.calculationMethod,
  });

  List<PrayerEntry> get prayers => [
        PrayerEntry(name: 'Fajr', nameArabic: 'الفجر', time: fajr, icon: '🌅'),
        PrayerEntry(name: 'Dhuhr', nameArabic: 'الظهر', time: dhuhr, icon: '☀️'),
        PrayerEntry(name: 'Asr', nameArabic: 'العصر', time: asr, icon: '🌤️'),
        PrayerEntry(name: 'Maghrib', nameArabic: 'المغرب', time: maghrib, icon: '🌇'),
        PrayerEntry(name: 'Isha', nameArabic: 'العشاء', time: isha, icon: '🌙'),
      ];

  PrayerEntry? get nextPrayer {
    final now = DateTime.now();
    for (final prayer in prayers) {
      if (prayer.time.isAfter(now)) {
        return prayer;
      }
    }
    return null;
  }

  Duration get timeUntilNextPrayer {
    final next = nextPrayer;
    if (next == null) return Duration.zero;
    return next.time.difference(DateTime.now());
  }
}

class PrayerEntry {
  final String name;
  final String nameArabic;
  final DateTime time;
  final String icon;
  bool notificationEnabled;

  PrayerEntry({
    required this.name,
    required this.nameArabic,
    required this.time,
    required this.icon,
    this.notificationEnabled = true,
  });

  bool get isPast => time.isBefore(DateTime.now());
  bool get isNext {
    final now = DateTime.now();
    return time.isAfter(now);
  }
}
