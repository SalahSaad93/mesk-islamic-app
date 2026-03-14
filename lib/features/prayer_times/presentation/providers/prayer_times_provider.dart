import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/prayer_times_entity.dart';

final prayerTimesProvider =
    AsyncNotifierProvider<PrayerTimesNotifier, PrayerTimesEntity>(
      PrayerTimesNotifier.new,
    );

final calculationMethodProvider = StateProvider<String>(
  (ref) => 'NorthAmerica',
);

class PrayerTimesNotifier extends AsyncNotifier<PrayerTimesEntity> {
  @override
  Future<PrayerTimesEntity> build() async {
    return _loadPrayerTimes();
  }

  Future<PrayerTimesEntity> _loadPrayerTimes() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      final locationParams = await locationService.getCurrentLocation();

      final coords = Coordinates(
        locationParams.latitude,
        locationParams.longitude,
      );
      final date = DateComponents.from(DateTime.now());

      final methodName = storageService.calculationMethod;

      CalculationParameters params;
      switch (methodName) {
        case 'UmmAlQura':
          params = CalculationMethod.umm_al_qura.getParameters();
          break;
        case 'Egyptian':
          params = CalculationMethod.egyptian.getParameters();
          break;
        case 'Karachi':
          params = CalculationMethod.karachi.getParameters();
          break;
        case 'MWL':
          params = CalculationMethod.muslim_world_league.getParameters();
          break;
        case 'Tehran':
          params = CalculationMethod.tehran.getParameters();
          break;
        default:
          params = CalculationMethod.north_america.getParameters();
      }

      final prayerTimes = PrayerTimes(coords, date, params);

      final entity = PrayerTimesEntity(
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        date: DateTime.now(),
        locationName: locationParams.name,
        calculationMethod: methodName,
      );

      _scheduleNotifications(entity, storageService);
      return entity;
    } catch (_) {
      // Return cached or default fallback

      // We don't have lat/lng persistence directly in storage service yet for fallback
      // Using generic default fallback
      final coords = Coordinates(40.7128, -74.0060);
      final date = DateComponents.from(DateTime.now());
      final params = CalculationMethod.north_america.getParameters();
      final prayerTimes = PrayerTimes(coords, date, params);

      return PrayerTimesEntity(
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        date: DateTime.now(),
        locationName: 'New York, USA',
        calculationMethod: 'NorthAmerica',
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadPrayerTimes);
  }

  Future<void> _scheduleNotifications(
    PrayerTimesEntity entity,
    StorageService storageService,
  ) async {
    final notificationService = ref.read(notificationServiceProvider);

    // We can cancel existing prayer alarms (IDs 1 to 6)
    for (int i = 1; i <= 6; i++) {
      await notificationService.cancelNotification(i);
    }

    final Map<String, DateTime> times = {
      'Fajr': entity.fajr,
      'Sunrise': entity.sunrise,
      'Dhuhr': entity.dhuhr,
      'Asr': entity.asr,
      'Maghrib': entity.maghrib,
      'Isha': entity.isha,
    };

    int id = 1;
    for (final entry in times.entries) {
      if (storageService.getPrayerNotification(entry.key)) {
        await notificationService.schedulePrayerNotification(
          id: id,
          prayerName: entry.key,
          time: entry.value,
          minutesBefore:
              0, // In the future, this can be customized via settings
        );
      }
      id++;
    }
  }
}
