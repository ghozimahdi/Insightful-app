import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'injector.dart';
import 'presentation/providers/app_location_provider.dart';
import 'presentation/providers/tracking_provider.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'config.env');

  initializeDependencies().then(
    (_) async {
      final provider = TrackingProvider();
      await provider.init();

      runApp(
        ChangeNotifierProvider(
          create: (_) => provider,
          child: const MyApp(),
        ),
      );
    },
  );
}

Future<void> initializeDependencies() async {
  await configureDependencies();
  await updateLocalTimeZone();
}

Future<void> updateLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<AppLocationProvider>(),
        ),
      ],
      child: MaterialApp(
        theme: theme,
        home: const SplashScreen(),
      ),
    );
  }
}
