import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/geo_fence_type.dart';
import '../../../../gen/colors.gen.dart';
import '../../../providers/main_screen_provider.dart';
import '../../../util/duration_formatter_mixin.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/permission_helper.dart';
import '../../../util/theme.dart';

class MainScreen extends StatelessWidget with DurationFormatterMixin {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainScreenProvider>(context);
    final summary = provider.geoFenceSummary;
    final timeAgo = summary.clockInTime.timeAgo;
    final geoFenceType = summary.type.label;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insightful',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateTime.now().longDate,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  provider.geoFenceSummary.elapsed,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Started at $timeAgo | Current Location: $geoFenceType',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: provider.isTracking
                        ? AppColors.orange.shade900
                        : Colors.black,
                  ),
                  onPressed: () => context.requestPermissions(
                    permissions: [
                      Permission.locationWhenInUse,
                      Permission.locationAlways,
                      Permission.location,
                    ],
                    onGrantedCallback: provider.isTracking
                        ? provider.clockOut
                        : provider.clockIn,
                  ),
                  child: Text(
                    provider.isTracking ? 'Clock Out' : 'Clock In',
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Today',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'Home: ${formatToHourMinute(summary.homeSeconds)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Office: ${formatToHourMinute(summary.officeSeconds)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Traveling: ${formatToHourMinute(summary.travelingSeconds)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
