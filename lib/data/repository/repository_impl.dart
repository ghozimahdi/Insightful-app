import 'package:injectable/injectable.dart';

import '../../domain/models/location_model.dart';
import '../../domain/repository/repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/location_data_source.dart';
import '../mappers/location_dto_mapper.dart';
import '../mappers/location_model_mapper.dart';

@Injectable(as: Repository)
class RepositoryImpl extends Repository {
  final LocalDataSource localDataSource;
  final LocationDataSource locationDataSource;
  final LocationDtoMapper locationDtoMapper;
  final LocationModelMapper locationModelMapper;

  RepositoryImpl(
    this.localDataSource,
    this.locationDataSource,
    this.locationDtoMapper,
    this.locationModelMapper,
  );

  @override
  void clearData() {
    localDataSource.clearData();
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      final result = await locationDataSource.getCurrentLocation();
      return locationModelMapper.mapFromData(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LocationModel> getLastSavedLocation() async {
    try {
      final result = await localDataSource.getLastSavedLocation();
      return locationModelMapper.mapFromData(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void updateLastSavedLocation(LocationModel model) {
    final dto = locationDtoMapper.mapFromDomain(model);
    localDataSource.updateLastSavedLocation(dto);
  }

  @override
  Future<void> updateLocationOnMap(double lat, double lng) {
    //TODO update my location on the server
    throw UnimplementedError();
  }
}
