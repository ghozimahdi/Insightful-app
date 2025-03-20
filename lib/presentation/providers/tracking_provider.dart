import 'package:flutter/material.dart';

import '../../data/model/daily_summary.dart';
import '../../data/services/location_tracking_service.dart';
import '../../injector.dart';

class TrackingProvider extends ChangeNotifier {
  final _service = getIt<LocationTrackingService>();

  DailySummary? currentSummary;
  bool isTracking = false;

  Future<void> init() async {
    currentSummary = DailySummary(
      date: _getTodayKey(),
      homeSeconds: 0,
      officeSeconds: 0,
      travelingSeconds: 0,
    );
    notifyListeners();
  }

  Future<void> startTracking() async {
    _service.clockIn();
    isTracking = true;
    notifyListeners();
  }

  Future<void> stopTracking() async {
    _service.clockOut();
    isTracking = false;

    currentSummary = DailySummary(
      date: _getTodayKey(),
      homeSeconds: _service.summary.homeSeconds,
      officeSeconds: _service.summary.officeSeconds,
      travelingSeconds: _service.summary.travelingSeconds,
    );

    notifyListeners();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
