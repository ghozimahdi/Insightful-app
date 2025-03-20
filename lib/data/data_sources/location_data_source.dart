import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

import '../../presentation/util/notifications_helper.dart';
import '../model/location_dto.dart';

abstract class LocationDataSource {
  Future<LocationDto?> getCurrentLocation();
}

@Injectable(as: LocationDataSource)
class LocationDataSourceImpl extends LocationDataSource
    with NotificationsHelper {
  final Location location;

  LocationDataSourceImpl(this.location);

  @override
  Future<LocationDto?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }

      final data =
          await location.getLocation().timeout(const Duration(seconds: 6));

      final locationPlaceMark = await _getLocationPlaceMark(data);
      if (locationPlaceMark == null) return null;

      return LocationDto(
        country: locationPlaceMark.country ?? '',
        displayName: locationPlaceMark.locality ?? '',
        latitude: data.latitude,
        longitude: data.longitude,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      printIfDebugMode('Location fetching failed: $e');
      return null;
    }
  }

  Future<geocoding.Placemark?> _getLocationPlaceMark(
    LocationData? locationData,
  ) async {
    if (locationData?.latitude == null || locationData?.longitude == null) {
      return null;
    }

    final placeMarks = await geocoding.placemarkFromCoordinates(
      locationData?.latitude ?? 0,
      locationData?.longitude ?? 0,
    );

    return placeMarks[0];
  }
}
