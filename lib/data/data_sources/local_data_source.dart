import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../model/location_dto.dart';

abstract class LocalDataSource {
  Future<LocationDto?> getLastSavedLocation();

  void updateLastSavedLocation(LocationDto data);

  void clearData();
}

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  final Box localBox;

  LocalDataSourceImpl(this.localBox);

  static const lastUpdatedLocationKey = 'lastUpdatedLocation';

  @override
  void clearData() {
    Hive.deleteFromDisk();
  }

  @override
  Future<LocationDto?> getLastSavedLocation() async {
    if (!localBox.containsKey(lastUpdatedLocationKey)) {
      return null;
    }

    final lastUpdatedLocation = localBox.get(lastUpdatedLocationKey);
    return LocationDto.fromJson(lastUpdatedLocation);
  }

  @override
  void updateLastSavedLocation(LocationDto data) {
    localBox.put(lastUpdatedLocationKey, data.toJson());
  }
}
