import 'dart:async';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/geo_fence_summary.dart';
import '../../domain/models/geo_fence_type.dart';
import '../model/geo_fence_summary_data.dart';
import 'clock_in_tracking_handler.dart';

typedef GeoFenceSummaryChanged = void Function(GeoFenceSummary location);

@singleton
class ClockInTrackingService {
  final List<GeoFenceSummaryChanged> _callbacks = [];

  Future<bool> get isRunningService => FlutterForegroundTask.isRunningService;

  Future<void> _requestPlatformPermissions() async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  Future<void> initialize() async {
    _requestPlatformPermissions();

    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'clockin_channel',
        channelName: 'Clock-In Service',
        channelDescription: 'Notification for clock-in tracking',
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> start() async {
    if (await isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Clocked In',
        notificationText: 'Elapsed: 00:00:00',
        notificationButtons: [
          const NotificationButton(id: 'btn_stop', text: 'Clock Out'),
        ],
        notificationInitialRoute: '/',
        callback: startCallback,
      );
    }
  }

  Future<void> update(String elapsedStr) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Clocked In',
      notificationText: 'Elapsed: $elapsedStr',
    );
  }

  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      final summaryData = GeoFenceSummaryData.fromJson(data);

      final model = GeoFenceSummary(
        homeSeconds: summaryData.homeSeconds ?? 0,
        officeSeconds: summaryData.officeSeconds ?? 0,
        travelingSeconds: summaryData.travelingSeconds ?? 0,
        elapsed: summaryData.elapsed ?? '00:00:00',
        type: GeoFenceType.fromString(summaryData.type ?? 'unknown'),
        clockInTime: summaryData.clockInTime ?? DateTime.now(),
        clockOutTime: summaryData.clockOutTime ?? DateTime.now(),
      );

      for (final GeoFenceSummaryChanged callback in _callbacks.toList()) {
        callback(model);
      }
    }
  }

  void addGeoFenceSummaryChangedCallback(GeoFenceSummaryChanged callback) {
    if (!_callbacks.contains(callback)) {
      _callbacks.add(callback);
    }
  }

  void removeGeoFenceSummaryChangedCallback(GeoFenceSummaryChanged callback) {
    _callbacks.remove(callback);
  }
}
