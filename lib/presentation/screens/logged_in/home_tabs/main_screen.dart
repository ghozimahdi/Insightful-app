import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../data/services/location_tracking_service.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../injector.dart';
import '../../../providers/tracking_provider.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _service = getIt<LocationTrackingService>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackingProvider>(context);

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
                ValueListenableBuilder<String>(
                  valueListenable: _service.elapsedNotifier,
                  builder: (context, elapsed, _) {
                    return Text(
                      elapsed,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                ValueListenableBuilder<Position?>(
                  valueListenable: _service.currentPositionNotifier,
                  builder: (context, position, _) {
                    final startedAt = _service.clockInTime.timeAgo;

                    return Text(
                      'Started at $startedAt | Current Location: ${_service.currentLocation}',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: provider.isTracking
                        ? AppColors.orange.shade900
                        : Colors.black,
                  ),
                  onPressed: provider.isTracking
                      ? provider.stopTracking
                      : provider.startTracking,
                  child: Text(provider.isTracking ? 'Clock Out' : 'Clock In'),
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
                      'Home: ${provider.currentSummary!.homeSeconds ~/ 60} min',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Office: ${provider.currentSummary!.officeSeconds ~/ 60} min',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Traveling: ${provider.currentSummary!.travelingSeconds ~/ 60} min',
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
