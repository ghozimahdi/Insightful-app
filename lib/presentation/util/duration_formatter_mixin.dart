import 'package:intl/intl.dart';

import '../../domain/models/daily_summary_model.dart';

mixin DurationFormatterMixin {
  String formatToHourMinute(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  Map<String, List<DailySummaryModel>> groupByDate(
    List<DailySummaryModel> summaries,
  ) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    return summaries.fold<Map<String, List<DailySummaryModel>>>({},
        (map, item) {
      final itemDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(item.clockInTime));

      String key;
      if (itemDate == today) {
        key = 'Today';
      } else if (itemDate == yesterday) {
        key = 'Yesterday';
      } else {
        key =
            DateFormat('dd MMM yyyy').format(DateTime.parse(item.clockInTime));
      }

      map.putIfAbsent(key, () => []).add(item);
      return map;
    });
  }
}
