import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/themes/app_themes.dart';
import 'package:turrant/themes/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key,}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkModeOn = false;

  @override
  void initState() {
    _checkDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = AppLocalizations.of(context)
        .getTranslatedValue('setting_page_app_bar_title');

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
            ListTile(
              leading: Icon(isDarkModeOn ? Icons.nights_stay : Icons.wb_sunny),
              title: Text(AppLocalizations.of(context)
                  .getTranslatedValue('setting_page_theme_toggle_txt')),
              onTap: () =>_toggleTheme(context),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _checkDarkMode() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        isDarkModeOn = prefs.getBool('darkMode') ?? false;
      });
    });
  }

  void _toggleTheme(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final bool darkModeOn = prefs.getBool('darkMode') ?? true;
      final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

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
