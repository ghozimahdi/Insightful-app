import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@singleton
class LocationTrackingService with ChangeNotifier {
  DateTime? _clockInTime;

  DateTime get clockInTime => _clockInTime ?? DateTime.now();
  StreamSubscription<Location>? _locationSubscription;

  final ValueNotifier<Position?> currentPositionNotifier = ValueNotifier(null);
  final ValueNotifier<String> elapsedNotifier = ValueNotifier('00:00:00');
  final ValueNotifier<GeoFenceSummary> geoFenceSummaryNotifier =
      ValueNotifier(GeoFenceSummary());

  final _geoFences = [
    GeoFence(name: 'Home', latitude: 37.7749, longitude: -122.4194),
    GeoFence(name: 'Office', latitude: 37.7858, longitude: -122.4364),
  ];

  String get currentLocation {
    final position = currentPositionNotifier.value;
    if (position != null) {
      for (final geoFence in _geoFences) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          geoFence.latitude,
          geoFence.longitude,
        );
        if (distance <= 50) {
          return geoFence.name;
        }
      }
      return 'Traveling';
    }
    return '-';
  }

  DateTime? _lastUpdate;

  Future<void> clockIn() async {
    _clockInTime = DateTime.now();
    _lastUpdate = _clockInTime;

    await BackgroundLocation.startLocationService();

    BackgroundLocation.getLocationUpdates((location) {
      _onLocationUpdate(location);
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_clockInTime == null) {
        timer.cancel();
      } else {
        final elapsed = DateTime.now().difference(_clockInTime!);
        elapsedNotifier.value = _formatDuration(elapsed);
      }
    });

    notifyListeners();
  }

  Future<void> clockOut() async {
    _clockInTime = null;
    await BackgroundLocation.stopLocationService();
    await _locationSubscription?.cancel();
    notifyListeners();
  }

  void _onLocationUpdate(Location location) {
    final now = DateTime.now();
    final delta = now.difference(_lastUpdate ?? now).inSeconds;
    _lastUpdate = now;

    final position = Position(
      latitude: location.latitude!,
      longitude: location.longitude!,
      timestamp: now,
      accuracy: location.accuracy ?? 0,
      altitude: location.altitude ?? 0,
      heading: location.bearing ?? 0,
      speed: location.speed ?? 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    currentPositionNotifier.value = position;

    bool isInsideAny = false;

    for (final geoFence in _geoFences) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        geoFence.latitude,
        geoFence.longitude,
      );

      if (distance <= 50) {
        isInsideAny = true;
        geoFence.totalSeconds += delta;
      }
    }

    if (!isInsideAny) {
      geoFenceSummaryNotifier.value.travelingSeconds += delta;
    }

    geoFenceSummaryNotifier.notifyListeners();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  GeoFenceSummary get summary => geoFenceSummaryNotifier.value;
}

class GeoFence {
  final String name;
  final double latitude;
  final double longitude;
  int totalSeconds = 0;

  GeoFence({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class GeoFenceSummary {
  int travelingSeconds = 0;

  int get homeSeconds => _getSecondsFor('Home');

  int get officeSeconds => _getSecondsFor('Office');

  int _getSecondsFor(String name) {
    final geoFence = LocationTrackingService()._geoFences.firstWhere(
          (f) => f.name == name,
          orElse: () => GeoFence(name: '', latitude: 0, longitude: 0),
        );
    return geoFence.totalSeconds;
  }
}
