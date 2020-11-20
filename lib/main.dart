import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:turrant/models/language.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';
import 'package:turrant/routes/custom_router.dart';
import 'package:turrant/routes/route_names.dart';

import 'localization/app_localizations.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  // get selected preferences for theme and locale
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    var selectedLocaleCode = prefs.getString('selectedLocale');
    var selectedLocale = selectedLocaleCode.split('-').length != 2 ? null
      : Locale(selectedLocaleCode.split('-')[0],
        selectedLocaleCode.split('-')[1]);

    runApp(MyApp(darkModeOn, selectedLocale));
  });
}

class MyApp extends StatefulWidget {
  MyApp(this.darkModeOn, this.selectedLocale);

  final bool darkModeOn;
  Locale selectedLocale;

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>
            .value(value: ThemeNotifier(widget.darkModeOn ? darkTheme : lightTheme))
      ],
      child: ThemedMaterialApp(widget.selectedLocale),
    );
  }

  void setLocale(Locale locale) {
    setState(() {
      widget.selectedLocale = locale;
    });
  }
}

class ThemedMaterialApp extends StatelessWidget {
  ThemedMaterialApp(this._selectedLocale);

  final Locale _selectedLocale;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turrant',
      theme: themeNotifier.getAppTheme.themeData,
      onGenerateRoute: CustomRouter.allRoutes,
      initialRoute: homeRoute,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      locale: _selectedLocale,
      supportedLocales: Language.supportedLocales(),
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (_selectedLocale != null) {
          return _selectedLocale;
        }
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode
              && locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }

        return supportedLocales.first;
      },
    );
  }
}
