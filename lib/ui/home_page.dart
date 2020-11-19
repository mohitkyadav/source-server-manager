import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  static const _title = 'Turrant';

  void _toggleTheme(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

      if (darkModeOn) {
        themeNotifier.setTheme(lightTheme);
      } else {
        themeNotifier.setTheme(darkTheme);
      }
      prefs.setBool('darkMode', !darkModeOn);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleTheme(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.lightbulb),
      ),
    );
  }
}
