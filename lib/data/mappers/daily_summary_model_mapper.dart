import 'package:injectable/injectable.dart';

import '../../domain/models/daily_summary_model.dart';
import '../model/daily_summary_object.dart';

@injectable
class DailySummaryModelMapper {
  DailySummaryModel mapFromObject(DailySummaryObject object) {
    return DailySummaryModel(
      clockInTime: object.clockInTime,
      clockOutTime: object.clockOutTime,
      homeSeconds: object.homeSeconds,
      officeSeconds: object.officeSeconds,
      travelingSeconds: object.travelingSeconds,
    );
  }
}
