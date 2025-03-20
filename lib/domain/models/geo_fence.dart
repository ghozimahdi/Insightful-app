import 'package:freezed_annotation/freezed_annotation.dart';

import 'geo_fence_type.dart';

part 'geo_fence.freezed.dart';

@freezed
class GeoFence with _$GeoFence {
  const factory GeoFence({
    @Default(GeoFenceType.unknown) GeoFenceType type,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @Default(0) double totalSeconds,
  }) = _GeoFence;
}
