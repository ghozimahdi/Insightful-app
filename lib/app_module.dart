import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@module
abstract class AppModule {
  @lazySingleton
  Location provideLocation() => Location();
}
