import 'package:flutter/material.dart';

import 'package:turrant/ui/pages/home/home_appbar_actions.dart';
import 'package:turrant/ui/pages/home/home_drawer_list.dart';
import 'package:turrant/ui/pages/home/home_form.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _title = 'Turrant';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          HomeAppbarActions(),
        ],
      ),
      drawer: HomeDrawerList(),
      body: Center(
        child: SingleChildScrollView(child: HomeForm()),
      ),
    );
  }
}
