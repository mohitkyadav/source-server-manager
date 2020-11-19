import 'package:flutter/material.dart';

import 'package:turrant/models/app_theme.dart';

class ThemeNotifier with ChangeNotifier {
  AppTheme _appTheme;

  ThemeNotifier(this._appTheme);

  AppTheme get getAppTheme => _appTheme;

  setTheme(AppTheme appTheme) async {
    _appTheme = appTheme;

    notifyListeners();
  }
}