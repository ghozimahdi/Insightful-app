import 'package:injectable/injectable.dart';

import '../models/daily_summary_model.dart';
import '../repository/repository.dart';

@injectable
class GetDailySummariesUseCase {
  final Repository _repository;

  GetDailySummariesUseCase(this._repository);

  Future<List<DailySummaryModel>> call() async {
    return _repository.getDailySummaries();
  }
}
