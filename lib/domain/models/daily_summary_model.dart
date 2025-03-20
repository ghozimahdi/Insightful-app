import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_summary_model.freezed.dart';

@freezed
class DailySummaryModel with _$DailySummaryModel {
  const factory DailySummaryModel({
    @Default('') String clockInTime,
    @Default('') String clockOutTime,
    @Default(0) int homeSeconds,
    @Default(0) int officeSeconds,
    @Default(0) int travelingSeconds,
  }) = _DailySummaryModel;
}
