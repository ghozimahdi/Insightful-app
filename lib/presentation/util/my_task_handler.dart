import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTaskHandler extends TaskHandler {
  DateTime? _clockInTime;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Load waktu clock-in dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final clockInString = prefs.getString('clockInTime');
    if (clockInString != null) {
      _clockInTime = DateTime.parse(clockInString);
    }
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    if (_clockInTime == null) return;

    final elapsed = DateTime.now().difference(_clockInTime!);
    final elapsedStr = _formatDuration(elapsed);

    // Update native foreground notification setiap kali event dipanggil (1 detik)
    await FlutterForegroundTask.updateService(
      notificationTitle: 'Clocked In',
      notificationText: 'Elapsed: $elapsedStr',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}