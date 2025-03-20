import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/daily_summary_model.dart';
import '../../domain/use_cases/get_daily_summaries_use_case.dart';

@injectable
class SecondScreenProvider with ChangeNotifier {
  final List<DailySummaryModel> dailySummaries = [];

  final GetDailySummariesUseCase _getDailySummariesUseCase;

  SecondScreenProvider(this._getDailySummariesUseCase);

  Future<void> getDailySummaries() async {
    dailySummaries.clear();

    final result = await _getDailySummariesUseCase();
    dailySummaries.addAll(result);
    notifyListeners();
  }
}
