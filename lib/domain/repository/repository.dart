import '../models/location_model.dart';

abstract class Repository {
  Future<LocationModel> getLastSavedLocation();

  void updateLastSavedLocation(LocationModel model);

  void clearData();

  Future<LocationModel> getCurrentLocation();

  Future<void> updateLocationOnMap(
    double lat,
    double lng,
  );
}
