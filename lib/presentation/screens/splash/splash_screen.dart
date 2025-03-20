import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../providers/app_location_provider.dart';
import '../../util/clockin_foreground_helper.dart';
import '../logged_in/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    ClockInForegroundHelper.requestPermissions();

    final provider = Provider.of<AppLocationProvider>(context, listen: false);
    provider.init();
  }

  void _redirectToDashboard() {
    Navigator.pushReplacement(context, Dashboard.route());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLocationProvider>(
      builder: (context, provider, _) {
        if (provider.hasPermission) {
          Future.delayed(
            const Duration(seconds: 3),
            () => _redirectToDashboard(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            alignment: Alignment.center,
            child: Assets.logoText.svg(
              width: 240,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}
