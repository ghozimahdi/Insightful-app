import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_model.freezed.dart';

@freezed
class PositionModel with _$PositionModel {
  const factory PositionModel({
    required double latitude,
    required double longitude,
  }) = _PositionModel;
}
