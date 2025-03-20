import 'package:injectable/injectable.dart';

import '../models/location_model.dart';
import '../repository/repository.dart';

@injectable
class GetLastSavedLocationUseCase {
  final Repository _repository;

  GetLastSavedLocationUseCase(this._repository);

  Future<LocationModel> call() {
    return _repository.getLastSavedLocation();
  }
}
