import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

import 'package:turrant/ui/home_page.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>
            .value(value: ThemeNotifier(darkTheme))
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
      theme: themeNotifier.getTheme,
      home: HomePage(),
    );
  }
}
