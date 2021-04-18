import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/app_bootstrap.dart';
import 'package:turrant/models/models.dart';

class HomeAppbarActions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: DropdownButton<Language>(
        underline: const SizedBox(),
        onChanged: (Language language) {
          _changeLanguage(context, language);
        },
        iconEnabledColor: Theme.of(context).accentColor,
        icon: const Icon(Icons.language),
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
      AppBootstrap.setLocale(context,
          Locale(language.languageCode, language.countryCode));
    });
  }
}
