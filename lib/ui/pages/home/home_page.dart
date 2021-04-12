import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/themes/styling.dart';
import 'file:///D:/git/turrant/lib/ui/pages/home/add_server.dart';

import 'home_appbar_actions.dart';
import 'home_drawer_list.dart';
import 'servers_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      floatingActionButton: addSvFab(context),
    );
  }

  Widget addSvFab(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<Widget>(
            context: context,
            builder: (BuildContext context) => Container(
              color: AppStyles.charcoalGrey,
              child: const AddServerForm(),
            ));
        // Navigator.pushNamed(context, addServerRoute);
      },
    );
  }
}
