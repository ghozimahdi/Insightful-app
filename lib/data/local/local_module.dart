import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

import '../model/daily_summary_object.dart';

@module
abstract class LocalModule {
  @preResolve
  Future<HiveInterface> get hive async {
    await Hive.initFlutter();
    Hive.registerAdapter(DailySummaryObjectAdapter());
    return Hive;
  }
}
