import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../models/location.dart';
import 'logged_in/dashboard_screen.dart';
import '../util/notifications_helper.dart';
import '../providers/location_provider.dart';
import '../providers/local_data_provider.dart';
import '../providers/auth_provider.dart';
import '../gen/colors.gen.dart';
import '../gen/assets.gen.dart';
import 'logged_out/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {
  @override
  void afterFirstLayout(BuildContext context) => _routeUser();

  final LocalDataProvider localDataProvider = LocalDataProvider();

  Future<void> _routeUser() async {
    final AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final bool isLoggedIn = await _isAuthenticated(auth);

    if (!isLoggedIn) {
      _redirectToLogin();
      return;
    }

    try {
      await _initializeAppServices(auth);
      _redirectToDashboard();
    } catch (e, s) {
      final bool isOffline = e.toString().contains('offline');
      NotificationsHelper().printIfDebugMode('Error initializing app services: $e\n$s');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOffline
                  ? 'You are not connected to internet or your network is too slow.'
                  : 'The Project 50 App is temporarily unavailable. Please try again later.',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  Future<bool> _isAuthenticated(AuthProvider auth) async {
    try {
      await auth.init();
      return auth.isLoggedIn;
    } catch (e) {
      NotificationsHelper().showError(e.toString());
      return false;
    }
  }

  Future<void> _initializeAppServices(AuthProvider auth) async {
    await Future.wait([
      localDataProvider.init(),
    ]);

    Future.wait([
      updateLocation(auth),
    ]);
  }

  Future<void> updateLocation(AuthProvider auth) async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.init();

    final Location? currentLocation = locationProvider.currentLocation;
    final Location? lastSavedLocation = localDataProvider.lastSavedLocation;

    if (currentLocation != null && lastSavedLocation == null) {
      await locationProvider.updateLocationOnMap(currentLocation.latitude!, currentLocation.longitude!);
    } else if (currentLocation != null && lastSavedLocation != null) {
      final distanceInKm = currentLocation.distanceTo(lastSavedLocation);
      if (distanceInKm > 10) {
        await locationProvider.updateLocationOnMap(currentLocation.latitude!, currentLocation.longitude!);
        localDataProvider.updateLastSavedLocation(currentLocation);
      }
    }
  }

  void _redirectToDashboard() {
    Navigator.pushReplacement(context, Dashboard.route());
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(context, LoginScreen.route());
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          alignment: Alignment.center,
          child: Assets.logoText.svg(
            width: 240,
            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
