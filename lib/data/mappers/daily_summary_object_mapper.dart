import 'package:injectable/injectable.dart';

import '../model/daily_summary_object.dart';
import '../model/geo_fence_summary_data.dart';

@injectable
class DailySummaryObjectMapper {
  DailySummaryObject mapFromDomain(GeoFenceSummaryData data) {
    return DailySummaryObject(
      clockInTime: data.clockInTime.toString(),
      clockOutTime: data.clockOutTime.toString(),
      homeSeconds: data.homeSeconds ?? 0,
      officeSeconds: data.officeSeconds ?? 0,
      travelingSeconds: data.travelingSeconds ?? 0,
    );
  }
}
