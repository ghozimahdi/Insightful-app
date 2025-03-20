import 'package:geolocator/geolocator.dart';

import '../../domain/models/geo_fence.dart';
import '../../domain/models/geo_fence_type.dart';
import '../../domain/models/position_model.dart';

mixin GeoFenceEvaluator {
  GeoFenceType evaluateLocation(
    PositionModel? position,
    List<GeoFence> geoFences,
  ) {
    if (position == null) {
      return GeoFenceType.unknown;
    }

    for (final geoFence in geoFences) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        geoFence.latitude,
        geoFence.longitude,
      );
      if (distance <= 50) {
        return geoFence.type;
      }
    }

    return GeoFenceType.traveling;
  }
}
