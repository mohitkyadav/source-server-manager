import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/app_bootstrap.dart';
import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/models.dart';
import 'package:turrant/themes/app_themes.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/themes/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key,}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkModeOn = false;
  Language currentLanguage = Language.supportedLanguages[0];

  @override
  void initState() {
    _checkCurrentSettings();
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
            // ListTile(
            //   leading: Icon(isDarkModeOn ? Icons.nights_stay : Icons.wb_sunny),
            //   title: Text(AppLocalizations.of(context)
            //       .getTranslatedValue('setting_page_theme_toggle_txt')),
            //   onTap: () =>_toggleTheme(context),
            // ),
            // const Divider(),
            buildLanguageButton(context),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: DropdownButton<Language>(
        isExpanded: true,
        dropdownColor: AppStyles.charcoalGrey,
        value: currentLanguage,
        underline: const SizedBox(),
        onChanged: (Language language) {
          _changeLanguage(context, language);
        },
        iconEnabledColor: Theme.of(context).accentColor,
        items: Language.supportedLanguages
            .map((Language lan) => DropdownMenuItem<Language>(
            value: lan,
            child: Row(
              children: <Widget>[
                Text(lan.flag),
                const SizedBox(width: 10,),
                Text(lan.name),
              ],
            ))
        ).toList(),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Language language) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString('selectedLocale',
          '${language.languageCode}-${language.countryCode}');
      setState(() {
        currentLanguage = language;
      });
      AppBootstrap.setLocale(context,
          Locale(language.languageCode, language.countryCode));
    });
  }

  void _checkCurrentSettings() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final String currentLocale = prefs.getString('selectedLocale') ?? 'en-US';
      final List<String> splitLocale = currentLocale.split('-');

      setState(() {
        isDarkModeOn = prefs.getBool('darkMode') ?? false;

        if (splitLocale.length < 2) {
          currentLanguage = Language.supportedLanguages[0];
        } else {
          currentLanguage = Language.supportedLanguages
              .firstWhere((Language lang) => lang.languageCode == splitLocale[0]);
        }

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
      _checkCurrentSettings();
    });
  }
}
