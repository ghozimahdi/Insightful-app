import 'package:injectable/injectable.dart';

import '../models/location_model.dart';
import '../repository/repository.dart';

@injectable
class UpdateLastSavedLocationUseCase {
  final Repository _repository;

  UpdateLastSavedLocationUseCase(this._repository);

  void call(LocationModel model) {
    return _repository.updateLastSavedLocation(model);
  }
}
