import 'package:hive/hive.dart';

part 'daily_summary.g.dart';

@HiveType(typeId: 0)
class DailySummary extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final int homeSeconds;

  @HiveField(2)
  final int officeSeconds;

  @HiveField(3)
  final int travelingSeconds;

  DailySummary({
    required this.date,
    required this.homeSeconds,
    required this.officeSeconds,
    required this.travelingSeconds,
  });
}
