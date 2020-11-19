import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

import 'package:turrant/ui/home_page.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(MyApp(darkModeOn));
  });
}


class MyApp extends StatelessWidget {
  MyApp(this._darkModeOn);

  final bool _darkModeOn;

  @override
 Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>
            .value(value: ThemeNotifier(_darkModeOn ? darkTheme : lightTheme))
      ],
      child: ThemedMaterialApp(),
    );
  }
}

class ThemedMaterialApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Turrant',
      theme: themeNotifier.getAppTheme.themeData,
      home: HomePage(),
    );
  }
}
