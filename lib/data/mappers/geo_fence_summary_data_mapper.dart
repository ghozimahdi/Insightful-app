import 'package:injectable/injectable.dart';

import '../../domain/models/geo_fence_summary.dart';
import '../../domain/models/geo_fence_type.dart';
import '../model/geo_fence_summary_data.dart';

@injectable
class GeoFenceSummaryDataMapper {
  GeoFenceSummaryData mapFromDomain(GeoFenceSummary model) {
    return GeoFenceSummaryData(
      clockInTime: model.clockInTime,
      clockOutTime: model.clockOutTime,
      type: model.type.label,
      homeSeconds: model.homeSeconds,
      officeSeconds: model.officeSeconds,
      travelingSeconds: model.travelingSeconds,
    );
  }
}
