import 'package:injectable/injectable.dart';

import '../models/location_model.dart';
import '../repository/repository.dart';

@injectable
class GetCurrentLocationUseCase {
  final Repository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<LocationModel> call() {
    return _repository.getCurrentLocation();
  }
}
