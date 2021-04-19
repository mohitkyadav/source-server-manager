import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

final AppTheme darkTheme = AppTheme('darkTheme', 'Dark', ThemeData(
    fontFamily: 'DMSans',
    primaryColor: AppStyles.darkBg,
    scaffoldBackgroundColor: AppStyles.darkBg,
    brightness: Brightness.dark,
    backgroundColor: AppStyles.darkBg,
    accentColor: AppStyles.blue2,
    accentIconTheme: const IconThemeData(color: AppStyles.white),
    dividerColor: AppStyles.lightGray,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppStyles.white,
        backgroundColor: AppStyles.blue2,
    ),
    colorScheme: const ColorScheme.dark(
        primary: AppStyles.lightPurple,
        secondary: AppStyles.lightGray,
    ),
  )
);

final AppTheme lightTheme = AppTheme('lightTheme', 'Light', ThemeData(
    primaryColor: AppStyles.white,
    brightness: Brightness.light,
    backgroundColor: AppStyles.white60,
    accentColor: AppStyles.lightPurple,
    accentIconTheme: const IconThemeData(color: AppStyles.white),
    dividerColor: AppStyles.lightGray,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppStyles.white,
        backgroundColor: AppStyles.lightPurple,
    ),
    colorScheme: const ColorScheme.light(
        primary: AppStyles.lightPurple,
        secondary: AppStyles.lightGray,
    ),
  )
);
