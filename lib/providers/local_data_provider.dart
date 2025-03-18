import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import '../models/location.dart';

class LocalDataProvider with ChangeNotifier {
  static final LocalDataProvider _singleton = LocalDataProvider._internal();

  late final Box _localBox;

  LocalDataProvider._internal();

  factory LocalDataProvider() => _singleton;

  bool _initialized = false;

  Location? get lastSavedLocation {
    if (!_initialized) return null;
    final lastUpdatedLocation = _localBox.get('lastUpdatedLocation');
    if (lastUpdatedLocation == null) return null;
    return Location.fromJson(lastUpdatedLocation);
  }

  Future<void> init() async {
    final currentDirectory = await path_provider.getApplicationDocumentsDirectory();

    Hive.init(currentDirectory.path);
    _localBox = await Hive.openBox('localData');

    _initialized = true;
    notifyListeners();
  }

  void updateLastSavedLocation(Location location) {
    _localBox.put('lastUpdatedLocation', location.toJson());
    notifyListeners();
  }

  void clearHive() {
    Hive.deleteFromDisk();
  }
}
