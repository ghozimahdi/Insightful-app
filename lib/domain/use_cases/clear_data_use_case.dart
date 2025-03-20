import 'package:injectable/injectable.dart';

import '../repository/repository.dart';

@injectable
class ClearDataUseCase {
  final Repository _repository;

  ClearDataUseCase(this._repository);

  void call() {
    return _repository.clearData();
  }
}
