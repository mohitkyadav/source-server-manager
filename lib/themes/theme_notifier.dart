import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._appTheme);

  AppTheme _appTheme;

  AppTheme get getAppTheme => _appTheme;

  Future<void> setTheme(AppTheme appTheme) async {
    _appTheme = appTheme;

    notifyListeners();
  }
}
