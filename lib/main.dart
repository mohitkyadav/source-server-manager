import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

import 'package:turrant/app_bootstrap.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  // get selected settings for theme and locale
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    var selectedLocaleCode = prefs.getString('selectedLocale');
    var selectedLocale = selectedLocaleCode.split('-').length != 2 ? null
      : Locale(selectedLocaleCode.split('-')[0],
        selectedLocaleCode.split('-')[1]);

    runApp(MyApp(darkModeOn, selectedLocale));
  });
}

class MyApp extends StatelessWidget {
  MyApp(this._darkModeOn, this._selectedLocale,);

  final bool _darkModeOn;
  final Locale _selectedLocale;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>
          .value(value: ThemeNotifier(_darkModeOn ? darkTheme : lightTheme))
      ],
      child: AppBootstrap(_selectedLocale),
    );
  }
}
