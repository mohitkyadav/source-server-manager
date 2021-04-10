import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/routes/route_names.dart';

import 'home_appbar_actions.dart';
import 'home_drawer_list.dart';
import 'servers_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key,}) : super(key: key);

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
      body: const SingleChildScrollView(child: ServersList()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, addServerRoute);
        },
      ),
    );
  }
}
