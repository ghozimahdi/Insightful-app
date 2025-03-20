import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'injector.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'config.env');
  initializeDependencies().then((_) => runApp(const MyApp()));
}

Future<void> initializeDependencies() async {
  await configureDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
