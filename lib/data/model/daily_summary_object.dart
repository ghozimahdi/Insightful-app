import 'package:hive/hive.dart';

part 'daily_summary_object.g.dart';

@HiveType(typeId: 0)
class DailySummaryObject extends HiveObject {
  @HiveField(0)
  final String clockInTime;

  @HiveField(1)
  final String clockOutTime;

  @HiveField(2)
  final int homeSeconds;

  @HiveField(3)
  final int officeSeconds;

  @HiveField(4)
  final int travelingSeconds;

  DailySummaryObject({
    required this.clockInTime,
    required this.clockOutTime,
    required this.homeSeconds,
    required this.officeSeconds,
    required this.travelingSeconds,
  });
}
