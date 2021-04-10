import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:source_server/source_server.dart';
import 'package:turrant/models/player.dart';

import 'package:turrant/models/server.dart';

class ServerDetailsPage extends StatefulWidget {
  const ServerDetailsPage(this.server);

  final Server server;

  @override
  _ServerDetailsPageState createState() => _ServerDetailsPageState();
}

class _ServerDetailsPageState extends State<ServerDetailsPage> {
  String ip;
  int port;
  String rconPassword;

  SourceServer sourceServer;
  List<Player> players;
  String map;
  String numOfPlayers;
  String maxPlayers;

  @override
  void initState() {
    super.initState();

    ip = widget.server.serverIp;
    port = int.parse(widget.server.serverPort);
    rconPassword = widget.server.serverRcon;
    sourceServer = SourceServer(InternetAddress(ip), port, rconPassword);

    _connectToServer();
  }

  @override
  void dispose() {
    sourceServer.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server.serverName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.server.serverIp,
              style: Theme.of(context).textTheme.headline4,),
          ],
        ),
      ),
    );
  }

  Future<void> _connectToServer () async {
    await sourceServer.connect();

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final Map<String, dynamic> playerInfo = await sourceServer.getPlayers();

    print(playerInfo.values);
    setState(() {
      players = playerInfo.values
          .map((dynamic player) => Player
          .fromJson(player as Map<String, dynamic>)).toList();

      map = serverInfo['map'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
    });
    print(map);
    print(numOfPlayers);
    print(maxPlayers);
    print(players);
    sourceServer.send('sm_kick haaboo');
    sourceServer.send('say haaboo');
  }
}
