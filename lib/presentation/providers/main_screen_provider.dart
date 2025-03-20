import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../data/services/clock_in_tracking_service.dart';
import '../../domain/models/geo_fence_summary.dart';

@injectable
class MainScreenProvider with ChangeNotifier {
  final ClockInTrackingService _service;
  GeoFenceSummary? _geoFenceSummary;

  GeoFenceSummary get geoFenceSummary =>
      _geoFenceSummary ?? GeoFenceSummary.empty();

  bool isTracking = false;

  MainScreenProvider(this._service);

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service.initialize();
      _service.addGeoFenceSummaryChangedCallback(_onGeoFenceSummaryChanged);
    });
  }

  void _onGeoFenceSummaryChanged(GeoFenceSummary data) {
    _geoFenceSummary = data;
    isTracking = _geoFenceSummary?.clockInTime != DateTime.now();
    notifyListeners();
  }

  Future<void> clockIn() async {
    isTracking = true;
    _service.start();
    notifyListeners();
  }

  Future<void> clockOut() async {
    _geoFenceSummary = null;
    _service.stop();
    isTracking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.removeGeoFenceSummaryChangedCallback(_onGeoFenceSummaryChanged);
    super.dispose();
  }
}
