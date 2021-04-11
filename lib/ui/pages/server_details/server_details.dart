import 'dart:io';

import 'package:flutter/material.dart';
import 'package:source_server/source_server.dart';
import 'package:turrant/models/player.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/ui/pages/server_details/players_list.dart';
import 'package:turrant/ui/pages/server_details/server_controls.dart';
import 'package:turrant/ui/pages/server_details/server_details_header.dart';

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

  bool isLoading = true;
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
    // RefreshIndicator(
    //     key: const ValueKey('PullToRefreshBlocks'),
    //     onRefresh: () => _loadPractice(),
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server.serverName),
      ),
      body: RefreshIndicator(
        key: const ValueKey<String> ('PullToRefreshServerDetails'),
        onRefresh: () => refreshInfo(),
        child: !isLoading ? ListView(
          children: <Widget>[
            ServerDetailsHeader(widget.server, map, numOfPlayers, maxPlayers),
            const SizedBox(height: 10,),
            ServerControls(widget.server, map, refreshInfo, sendCommandToSv),
            PlayersList(players, sendCommandToSv),
          ],
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<String> sendCommandToSv(String cmd) async {
    await sourceServer.connect();
    return sourceServer.send(cmd);
  }

  Future<void> refreshInfo() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final Map<String, dynamic> playerInfo = await sourceServer.getPlayers();

    setState(() {
      players = playerInfo.values
          .map((dynamic player) => Player
          .fromJson(player as Map<String, dynamic>)).toList();

      map = serverInfo['map'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
      isLoading = false;
    });
  }

  Future<void> _connectToServer() async {
    await sourceServer.connect();

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final Map<String, dynamic> playerInfo = await sourceServer.getPlayers();

    setState(() {
      players = playerInfo.values
          .map((dynamic player) => Player
          .fromJson(player as Map<String, dynamic>)).toList();

      map = serverInfo['map'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
      isLoading = false;
    });

    // sourceServer.send('sm_kick haaboo [reason is this]').then((String value) => print(value));
  }
}
