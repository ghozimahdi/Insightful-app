import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

import '../../domain/models/location_model.dart';
import '../../domain/use_cases/get_current_location_use_case.dart';
import '../../domain/use_cases/get_last_saved_location_use_case.dart';
import '../../domain/use_cases/update_last_saved_location_use_case.dart';
import '../../presentation/util/notifications_helper.dart';

@singleton
class AppLocationProvider with ChangeNotifier, NotificationsHelper {
  final Location _location;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetLastSavedLocationUseCase _getLastSavedLocationUseCase;
  final UpdateLastSavedLocationUseCase _updateLastSavedLocationUseCase;

  AppLocationProvider(
    this._getCurrentLocationUseCase,
    this._getLastSavedLocationUseCase,
    this._updateLastSavedLocationUseCase,
    this._location,
  );

  LocationModel _currentLocation = const LocationModel();

  LocationModel get currentLocation => _currentLocation;
  bool _acceptedPermission = false;

  bool get hasPermission => _acceptedPermission;

  Future<void> init() async {
    await geocoding.setLocaleIdentifier('en');
    _acceptedPermission = await requestPermission();
    if (_acceptedPermission) {
      await fetchCurrentLocation();
      await _updateLocation();
    }

    notifyListeners();
  }

  Future<bool> requestPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showError(
          'Location permission denied. Please enable location services.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _updateLocation() async {
    final lastSavedLocation = await _getLastSavedLocationUseCase.call();

    final distanceInKm = currentLocation.distanceTo(lastSavedLocation);

    if (distanceInKm > 10) {
      await updateLocationOnMap(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      _updateLastSavedLocationUseCase.call(currentLocation);
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
      }

      _currentLocation = await _getCurrentLocationUseCase.call();
    } catch (e) {
      printIfDebugMode('Location fetching failed: $e');
    }
  }

  Future<void> updateLocationOnMap(double lat, double lng) async {
    //TODO update my location on the server
  }
}
