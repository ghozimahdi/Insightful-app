import '../models/daily_summary_model.dart';
import '../models/geo_fence_summary.dart';

abstract class Repository {
  void clearData();

  Future<void> addDailySummary(GeoFenceSummary model);

  Future<List<DailySummaryModel>> getDailySummaries();
}
