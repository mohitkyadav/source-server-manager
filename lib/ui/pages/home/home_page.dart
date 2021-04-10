import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';

import 'home_appbar_actions.dart';
import 'home_drawer_list.dart';
import 'home_form.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final String _title = AppLocalizations.of(context)
        .getTranslatedValue('app_bar_title');

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          HomeAppbarActions(),
        ],
      ),
      drawer: HomeDrawerList(),
      body: SingleChildScrollView(child: HomeForm()),
    );
  }
}
