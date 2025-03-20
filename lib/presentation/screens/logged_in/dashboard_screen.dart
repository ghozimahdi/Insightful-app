import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../injector.dart';
import '../../providers/home_provider.dart';
import '../../util/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const Dashboard(),
      fullscreenDialog: true,
    );
  }

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeProvider>(),
      child: Consumer<HomeProvider>(
        builder: (_, homeProvider, __) {
          return Scaffold(
            body: homeProvider.selectedScreen,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: homeProvider.currentIndex,
              selectedLabelStyle: theme.textTheme.titleSmall,
              selectedItemColor: AppColors.secondary,
              onTap: homeProvider.switchToIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Assets.icons.icHouse.svg(),
                  activeIcon: Assets.icons.icHouse.svg(),
                  label: 'Main',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.icBook.svg(),
                  activeIcon: Assets.icons.icBook.svg(),
                  label: 'History',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
