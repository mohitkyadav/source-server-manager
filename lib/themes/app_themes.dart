import 'package:flutter/material.dart';

import 'package:turrant/models/app_theme.dart';
import 'package:turrant/themes/styling.dart';

final darkTheme = AppTheme('darkTheme', 'Dark', ThemeData(
    primaryColor: AppStyles.black,
    brightness: Brightness.dark,
    backgroundColor: AppStyles.lightGray,
    accentColor: AppStyles.lightPurple,
    accentIconTheme: IconThemeData(color: AppStyles.black),
    dividerColor: AppStyles.lightGray,
    colorScheme: ColorScheme.dark(
        primary: AppStyles.lightPurple,
        secondary: AppStyles.lightGray,
    ),
  )
);

final lightTheme = AppTheme('lightTheme', 'Light', ThemeData(
    primaryColor: AppStyles.white,
    brightness: Brightness.light,
    backgroundColor: AppStyles.white60,
    accentColor: AppStyles.lightPurple,
    accentIconTheme: IconThemeData(color: AppStyles.white),
    dividerColor: AppStyles.lightGray,
    colorScheme: ColorScheme.light(
        primary: AppStyles.lightPurple,
        secondary: AppStyles.lightGray,
    ),
  )
);
