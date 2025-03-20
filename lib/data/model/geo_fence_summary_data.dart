import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_fence_summary_data.freezed.dart';
part 'geo_fence_summary_data.g.dart';

@freezed
class GeoFenceSummaryData with _$GeoFenceSummaryData {
  const GeoFenceSummaryData._();

  const factory GeoFenceSummaryData({
    @JsonKey(name: 'clockInTime') DateTime? clockInTime,
    @JsonKey(name: 'clockOutTime') DateTime? clockOutTime,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'homeSeconds') int? homeSeconds,
    @JsonKey(name: 'officeSeconds') int? officeSeconds,
    @JsonKey(name: 'travelingSeconds') int? travelingSeconds,
    @JsonKey(name: 'elapsed') String? elapsed,
  }) = _GeoFenceSummaryData;

  factory GeoFenceSummaryData.fromJson(Map<String, dynamic> json) =>
      _$GeoFenceSummaryDataFromJson(json);
}
