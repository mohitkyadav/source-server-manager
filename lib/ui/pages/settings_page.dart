import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/themes/app_themes.dart';
import 'package:turrant/themes/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key,}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _title = 'Turrant';
  bool isDarkModeOn = false;

  @override
  void initState() {
    _checkDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(isDarkModeOn ? Icons.lightbulb_outline : Icons.lightbulb),
              title: Text('Toggle theme'),
              onTap: () =>_toggleTheme(context),
            )
          ],
        ),
      ),
    );
  }

  void _checkDarkMode() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isDarkModeOn = prefs.getBool('darkMode') ?? false;
      });
    });
  }

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
      _checkDarkMode();
    });
  }
}
