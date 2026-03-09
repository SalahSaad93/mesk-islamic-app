import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_times_entity.dart';

final prayerTimesProvider =
    AsyncNotifierProvider<PrayerTimesNotifier, PrayerTimesEntity>(
  PrayerTimesNotifier.new,
);

final calculationMethodProvider =
    StateProvider<String>((ref) => 'NorthAmerica');

class PrayerTimesNotifier extends AsyncNotifier<PrayerTimesEntity> {
  @override
  Future<PrayerTimesEntity> build() async {
    return _loadPrayerTimes();
  }

  Future<PrayerTimesEntity> _loadPrayerTimes() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position;
      String locationName = 'Your Location';

      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 10),
          ),
        );

        // Try to get city name
        try {
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            locationName = place.locality ??
                place.administrativeArea ??
                place.country ??
                'Your Location';
          }
        } catch (_) {}
      } catch (_) {
        // Fallback to New York coordinates
        position = Position(
          latitude: 40.7128,
          longitude: -74.0060,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        locationName = 'New York, USA';
      }

      final coords = Coordinates(position.latitude, position.longitude);
      final date = DateComponents.from(DateTime.now());

      // Load calculation method from preferences
      final prefs = await SharedPreferences.getInstance();
      final methodName =
          prefs.getString('calculation_method') ?? 'NorthAmerica';

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

      // Save location for offline use
      await prefs.setDouble('last_lat', position.latitude);
      await prefs.setDouble('last_lng', position.longitude);
      await prefs.setString('last_location_name', locationName);

      return PrayerTimesEntity(
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        date: DateTime.now(),
        locationName: locationName,
        calculationMethod: methodName,
      );
    } catch (e) {
      // Return cached or default
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat') ?? 40.7128;
      final lng = prefs.getDouble('last_lng') ?? -74.0060;
      final locationName =
          prefs.getString('last_location_name') ?? 'New York, USA';

      final coords = Coordinates(lat, lng);
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
        locationName: locationName,
        calculationMethod: 'NorthAmerica',
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadPrayerTimes);
  }
}
