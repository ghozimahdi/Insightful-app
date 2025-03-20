import 'package:injectable/injectable.dart';

import '../../domain/models/location_model.dart';
import '../model/location_dto.dart';

@injectable
class LocationDtoMapper {
  LocationDto mapFromDomain(LocationModel model) {
    return LocationDto(
      country: model.country,
      displayName: model.displayName,
      latitude: model.latitude,
      longitude: model.longitude,
      lastUpdated: model.lastUpdated,
    );
  }
}
