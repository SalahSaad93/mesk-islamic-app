import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String name;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.name,
  });
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();

  Future<LocationResult> getCurrentLocation({
    double fallbackLat = 40.7128,
    double fallbackLng = -74.0060,
    String fallbackName = 'New York, USA',
  }) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are denied');
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      String locationName = 'Your Location';
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

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        name: locationName,
      );
    } catch (_) {
      return LocationResult(
        latitude: fallbackLat,
        longitude: fallbackLng,
        name: fallbackName,
      );
    }
  }
}
