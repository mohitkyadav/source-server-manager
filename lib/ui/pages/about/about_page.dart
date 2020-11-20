import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key,}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    final _title = AppLocalizations.of(context)
        .getTranslatedValue('about_page_app_bar_title');

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_title, style: Theme.of(context).textTheme.headline4,),
          ],
        ),
      ),
    );
  }
}
