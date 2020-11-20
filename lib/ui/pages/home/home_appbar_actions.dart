import 'package:flutter/material.dart';

import 'package:turrant/models/language.dart';

class HomeAppbarActions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: DropdownButton(
        underline: const SizedBox(),
        onChanged: _changeLanguage,
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

  void _changeLanguage(Language language) {
    print(language);
  }
}
