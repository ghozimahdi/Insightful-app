import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../model/daily_summary_object.dart';

abstract class LocalDataSource {
  void clearData();

  Future<void> addDailySummary(DailySummaryObject data);

  Future<List<DailySummaryObject>> getDailySummaries();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  Future<Box<DailySummaryObject>> _getDailySummaryBox() async {
    return Hive.openBox<DailySummaryObject>('daily_summary_box');
  }

  @override
  void clearData() {
    Hive.deleteFromDisk();
  }

  @override
  Future<void> addDailySummary(DailySummaryObject data) async {
    final box = await _getDailySummaryBox();
    box.add(data);
  }

  @override
  Future<List<DailySummaryObject>> getDailySummaries() async {
    final box = await _getDailySummaryBox();
    return box.values.toList();
  }
}
