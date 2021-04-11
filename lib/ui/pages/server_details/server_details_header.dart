import 'package:flutter/material.dart';

import 'package:turrant/models/server.dart';

class ServerDetailsHeader extends StatelessWidget {
  const ServerDetailsHeader(this.server, this.map, this.numOfPlayers,
      this.maxPlayers);

  final Server server;
  final String map;
  final String numOfPlayers;
  final String maxPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1,
              heightFactor: 0.2,
              child: Image.asset('assets/img/de_mirage.jpg',),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${server.serverIp}:${server.serverPort}',
                  style: Theme.of(context).textTheme.headline6),
              Text(map, style: Theme.of(context).textTheme.subtitle1),
              Text('$numOfPlayers / $maxPlayers',
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
        ],
      ),
    );
  }
}
