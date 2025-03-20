import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';

@freezed
class LocationModel with _$LocationModel {
  const LocationModel._();

  const factory LocationModel({
    @Default('') String country,
    @Default('') String displayName,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    DateTime? lastUpdated,
  }) = _LocationModel;

  factory LocationModel.empty() => LocationModel(
        lastUpdated: DateTime.now(),
      );

  num distanceTo(LocationModel other) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    final double dLat = (other.latitude - latitude) * (3.141592653589793 / 180);
    final double dLon =
        (other.longitude - longitude) * (3.141592653589793 / 180);
    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(latitude * (3.141592653589793 / 180)) *
            cos(other.latitude * (3.141592653589793 / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }
}
