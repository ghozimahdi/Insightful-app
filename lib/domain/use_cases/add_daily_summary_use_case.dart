import 'package:injectable/injectable.dart';

import '../models/geo_fence_summary.dart';
import '../repository/repository.dart';

@injectable
class AddDailySummaryUseCase {
  final Repository _repository;

  AddDailySummaryUseCase(this._repository);

  Future<void> call(GeoFenceSummary input) {
    return _repository.addDailySummary(input);
  }
}
