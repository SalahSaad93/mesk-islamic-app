import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:adhan/adhan.dart';
import '../../../../core/services/location_service.dart';

class QiblaState {
  final double
  qiblaDirection; // Fixed direction towards Mecca relative to True North
  final double currentHeading; // Device's current heading
  final bool hasError;
  final String errorMessage;

  const QiblaState({
    required this.qiblaDirection,
    required this.currentHeading,
    this.hasError = false,
    this.errorMessage = '',
  });

  QiblaState copyWith({
    double? qiblaDirection,
    double? currentHeading,
    bool? hasError,
    String? errorMessage,
  }) {
    return QiblaState(
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      currentHeading: currentHeading ?? this.currentHeading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final qiblaProvider =
    StateNotifierProvider<QiblaNotifier, AsyncValue<QiblaState>>((ref) {
      return QiblaNotifier(ref);
    });

class QiblaNotifier extends StateNotifier<AsyncValue<QiblaState>> {
  final Ref _ref;

  QiblaNotifier(this._ref) : super(const AsyncLoading()) {
    _initQibla();
  }

  Future<void> _initQibla() async {
    try {
      final locationService = _ref.read(locationServiceProvider);
      final locationParams = await locationService.getCurrentLocation();

      final qiblaDirection = Qibla(
        Coordinates(locationParams.latitude, locationParams.longitude),
      ).direction;

      state = AsyncData(
        QiblaState(qiblaDirection: qiblaDirection, currentHeading: 0.0),
      );

      FlutterCompass.events?.listen(
        (CompassEvent event) {
          if (mounted) {
            final heading = event.heading ?? 0.0;
            state = state.whenData((s) => s.copyWith(currentHeading: heading));
          }
        },
        onError: (Object error) {
          if (mounted) {
            state = AsyncData(
              QiblaState(
                qiblaDirection: qiblaDirection,
                currentHeading: 0.0,
                hasError: true,
                errorMessage: 'Compass error: $error',
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        state = AsyncError(e, StackTrace.current);
      }
    }
  }
}
