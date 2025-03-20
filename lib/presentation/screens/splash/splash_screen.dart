import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 3),
      () => _redirectToDashboard(),
    );
  }

  void _redirectToDashboard() {
    Navigator.pushReplacement(context, Dashboard.route());
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
