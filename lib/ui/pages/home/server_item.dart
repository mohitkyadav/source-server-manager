import 'package:flutter/material.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/routes/route_names.dart';

class ServerItem extends StatelessWidget {
  const ServerItem(this.server);

  final Server server;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, serverDetailsRoute, arguments: server);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          server.serverName
        ),
      ),
    );
  }
}
