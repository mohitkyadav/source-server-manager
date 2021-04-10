import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/models/server.dart';
import 'package:turrant/ui/pages/home/server_item.dart';

class ServersList extends StatefulWidget {
  const ServersList({Key key,}) : super(key: key);

  @override
  _ServersListState createState() => _ServersListState();
}

class _ServersListState extends State<ServersList> {

  List<Server> servers = <Server>[];

  @override
  void initState() {
    super.initState();

    _getServers();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(AppLocalizations.of(context)
              .getTranslatedValue('added_servers'), style: AppStyles.textH1,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: servers.length,
            itemBuilder: (BuildContext context, int index) {
              return ServerItem(servers[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
        ),
      ],
    );
  }

  void _getServers() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      print(currentAddedServers);
      final List<Server> currentServers = currentAddedServers.map((String server) => Server
          .fromJson(jsonDecode(server) as Map<String, dynamic>)
      ).toList();

      setState(() {
        servers = currentServers;
      });
    });
  }
}
