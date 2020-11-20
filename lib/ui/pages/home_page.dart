import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/routes/route_names.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/themes/theme_notifier.dart';
import 'package:turrant/themes/app_themes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      drawer: _buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Themed text',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleTheme(context);
        },
        tooltip: 'Toggle Theme',
        child: Icon(Icons.lightbulb,),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  child: Icon(
                    Icons.home_filled,
                    size: 100,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: Text('Go to Settings Page'),
                onTap: () => Navigator.pushNamed(context, settingsRoute),
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                ),
                title: Text('Go to About Page'),
                onTap: () => Navigator.pushNamed(context, aboutRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
