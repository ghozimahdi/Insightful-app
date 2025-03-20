import 'package:injectable/injectable.dart';

import '../../domain/models/location_model.dart';
import '../model/location_dto.dart';

@injectable
class LocationModelMapper {
  LocationModel mapFromData(LocationDto? locationDto) {
    return LocationModel(
      country: locationDto?.country ?? '',
      displayName: locationDto?.displayName ?? '',
      latitude: locationDto?.latitude ?? 0.0,
      longitude: locationDto?.longitude ?? 0.0,
      lastUpdated: locationDto?.lastUpdated ?? DateTime.now(),
    );
  }
}
