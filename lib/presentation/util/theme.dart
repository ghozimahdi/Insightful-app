import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';
import '../../gen/fonts.gen.dart';

final theme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.all(const Color(0xFF131F34)),
  ),
  fontFamily: Fonts.sFPro,
  dividerTheme: const DividerThemeData(color: AppColors.grey, space: 0),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF005b96)),
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      height: 1.1,
      fontSize: 22,
      letterSpacing: 0.4,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      height: 1.1,
      fontSize: 16,
      letterSpacing: 0.24,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 1.15,
      letterSpacing: 0.4,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      height: 1.15,
      letterSpacing: 0.4,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      foregroundColor: AppColors.lightGrey,
      backgroundColor: AppColors.secondary,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        height: 1.1,
        fontSize: 16,
        letterSpacing: 0.4,
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    unselectedLabelColor: Colors.grey.shade300,
    labelColor: Colors.black,
    splashFactory: NoSplash.splashFactory,
    labelPadding: const EdgeInsets.only(bottom: 1),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? AppColors.secondary
          : AppColors.lightGrey;
    }),
    checkColor: const WidgetStatePropertyAll(Colors.white),
  ),
);
