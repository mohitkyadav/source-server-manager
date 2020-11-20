import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/app_bootstrap.dart';
import 'package:turrant/models/language.dart';

class HomeAppbarActions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: DropdownButton(
        underline: const SizedBox(),
        onChanged: (language) {
          _changeLanguage(context, language);
        },
        iconEnabledColor: Theme.of(context).accentColor,
        icon: Icon(Icons.language),
        items: Language.supportedLanguages.map((lan) => DropdownMenuItem(
            value: lan,
            child: Row(
              children: [
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
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('selectedLocale',
          '${language.languageCode}-${language.countryCode}');
      AppBootstrap.setLocale(context,
          Locale(language.languageCode, language.countryCode));
    });
  }
}
