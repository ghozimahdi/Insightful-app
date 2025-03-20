import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@module
abstract class LocalModule {
  @preResolve
  @lazySingleton
  Future<Box> get boxHive async {
    final currentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(currentDirectory.path);
    return Hive.openBox('localData');
  }
}
