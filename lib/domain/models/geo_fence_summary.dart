import 'package:freezed_annotation/freezed_annotation.dart';

import 'geo_fence_type.dart';

part 'geo_fence_summary.freezed.dart';

@freezed
class GeoFenceSummary with _$GeoFenceSummary {
  const GeoFenceSummary._();

  const factory GeoFenceSummary({
    required DateTime clockInTime,
    required DateTime clockOutTime,
    @Default(GeoFenceType.unknown) GeoFenceType type,
    @Default(0) int homeSeconds,
    @Default(0) int officeSeconds,
    @Default(0) int travelingSeconds,
    @Default('00:00:00') String elapsed,
  }) = _GeoFenceSummary;

  factory GeoFenceSummary.empty() => GeoFenceSummary(
        clockInTime: DateTime.now(),
        clockOutTime: DateTime.now(),
      );
}
