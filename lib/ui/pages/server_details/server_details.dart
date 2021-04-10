import 'package:flutter/material.dart';

import 'package:turrant/models/server.dart';

class ServerDetailsPage extends StatelessWidget {
  const ServerDetailsPage(this.server);

  final Server server;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(server.serverName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(server.serverIp, style: Theme.of(context).textTheme.headline4,),
          ],
        ),
      ),
    );
  }
}
