import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

import 'package:turrant/app_bootstrap.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  // get selected settings for theme and locale
  SharedPreferences.getInstance().then((SharedPreferences prefs) {
    final bool darkModeOn = prefs.getBool('darkMode') ?? true;
    final String selectedLocaleCode = prefs.getString('selectedLocale');
    Locale selectedLocale;

    if (selectedLocaleCode != null) {
      if (selectedLocaleCode.split('-').length == 2) {
        selectedLocale = Locale(
            selectedLocaleCode.split('-')[0], selectedLocaleCode.split('-')[1]);
      }
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));

    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle('Source Server Manager');
      setWindowMinSize(const Size(600, 900));
      setWindowMaxSize(const Size(700, 900));
    }
    runApp(MyApp(darkModeOn, selectedLocale));
  });
}

class MyApp extends StatelessWidget {
  const MyApp(this._darkModeOn, this._selectedLocale,);

  final bool _darkModeOn;
  final Locale _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ThemeNotifier>.value(
            value: ThemeNotifier(_darkModeOn ? darkTheme : lightTheme))
      ],
      child: AppBootstrap(_selectedLocale),
    );
  }
}
