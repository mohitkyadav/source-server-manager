import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';
import 'package:turrant/routes/custom_router.dart';
import 'package:turrant/routes/route_names.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Turrant',
      theme: themeNotifier.getAppTheme.themeData,
      onGenerateRoute: CustomRouter.allRoutes,
      initialRoute: homeRoute,
    );
  }
}
