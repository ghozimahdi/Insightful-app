import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/geo_fence.dart';
import '../../domain/models/geo_fence_summary.dart';
import '../../domain/models/geo_fence_type.dart';
import '../../domain/models/position_model.dart';
import '../../domain/use_cases/add_daily_summary_use_case.dart';
import '../../injector.dart';
import '../model/geo_fence_summary_data.dart';
import 'clock_in_tracking_service.dart';
import 'geo_fence_evaluator.dart';

@injectable
class ClockInTrackingHandler extends TaskHandler with GeoFenceEvaluator {
  final AddDailySummaryUseCase _useCase;

  ClockInTrackingHandler(this._useCase);

  late DateTime? _clockInTime;
  int _homeSeconds = 0;
  int _officeSeconds = 0;
  int _travelingSeconds = 0;

  final _geoFences = [
    const GeoFence(
      type: GeoFenceType.home,
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    const GeoFence(
      type: GeoFenceType.office,
      latitude: 37.7858,
      longitude: -122.4364,
    ),
  ];

  Timer? _timer;
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _clockInTime = DateTime.now();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 50,
      ),
    ).listen((position) {
      _lastPosition = position;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final geoFenceType = evaluateLocation(
        PositionModel(
          latitude: _lastPosition?.latitude ?? 0,
          longitude: _lastPosition?.longitude ?? 0,
        ),
        _geoFences,
      );

      switch (geoFenceType) {
        case GeoFenceType.home:
          _homeSeconds++;
          break;
        case GeoFenceType.office:
          _officeSeconds++;
          break;
        default:
          _travelingSeconds++;
          break;
      }

      final elapsed = DateTime.now().difference(_clockInTime!);
      FlutterForegroundTask.updateService(
        notificationTitle: 'Clocked In',
        notificationText: _formatDuration(elapsed),
      );

      final summary = GeoFenceSummaryData(
        homeSeconds: _homeSeconds,
        officeSeconds: _officeSeconds,
        travelingSeconds: _travelingSeconds,
        elapsed: _formatDuration(elapsed),
        type: geoFenceType.label,
        clockInTime: _clockInTime,
      );

      FlutterForegroundTask.sendDataToMain(summary.toJson());
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    try {
      final geoFenceType = evaluateLocation(
        PositionModel(
          latitude: _lastPosition?.latitude ?? 0,
          longitude: _lastPosition?.longitude ?? 0,
        ),
        _geoFences,
      );

      await _useCase.call(
        GeoFenceSummary(
          type: geoFenceType,
          clockInTime: _clockInTime ?? DateTime.now(),
          homeSeconds: _homeSeconds,
          officeSeconds: _officeSeconds,
          travelingSeconds: _travelingSeconds,
          clockOutTime: DateTime.now(),
        ),
      );

      _timer?.cancel();
      await _positionSubscription?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'btn_stop') {
      getIt<ClockInTrackingService>().stop();
    }
  }
}

@pragma('vm:entry-point')
Future<void> startCallback() async {
  await configureDependencies();
  FlutterForegroundTask.setTaskHandler(getIt<ClockInTrackingHandler>());
}
