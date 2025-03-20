import 'dart:async';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

mixin ClockInForegroundHelper {
  static Timer? _timer;

  static Future<void> requestPermissions() async {
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

  static Future<void> init() async {
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
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(1000),
      ),
    );
  }

  static Future<void> start(DateTime clockInTime) async {
    _timer?.cancel();

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Clocked In',
        notificationText: 'Elapsed: 00:00:00',
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'Hello'),
        ],
        notificationInitialRoute: '/',
      );
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(clockInTime);
      final elapsedStr = _formatDuration(elapsed);
      FlutterForegroundTask.updateService(
        notificationTitle: 'Clocked In',
        notificationText: 'Elapsed: $elapsedStr',
      );
    });
  }

  static Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await FlutterForegroundTask.stopService();
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
