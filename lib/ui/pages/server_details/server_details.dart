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
  String svName = '';

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
        title: Text(svName),
      ),
      body: RefreshIndicator(
        key: const ValueKey<String> ('PullToRefreshServerDetails'),
        onRefresh: () => refreshInfo(),
        child: !isLoading ? ListView(
          children: <Widget>[
            ServerDetailsHeader(widget.server, map, numOfPlayers, maxPlayers),
            const SizedBox(height: 10,),
            ServerControls(widget.server, map, refreshInfo, sendCommandToSv, showToast),
            PlayersList(players, refreshInfo, sendCommandToSv, showToast),
          ],
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<String> sendCommandToSv(String cmd) async {
    await sourceServer.connect();
    return sourceServer.send(cmd);
  }

  void showToast(BuildContext context, String text) {
    final ScaffoldState scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> refreshInfo() async {
    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final String statusRes = await sourceServer.send('status');

    setState(() {
      players = _parseStatus(statusRes);
      map = serverInfo['map'].toString();
      svName = serverInfo['name'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
      isLoading = false;
    });
  }

  Future<void> _connectToServer() async {
    await sourceServer.connect();

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final String statusRes = await sourceServer.send('status');

    setState(() {
      players = _parseStatus(statusRes);
      map = serverInfo['map'].toString();
      svName = serverInfo['name'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
      isLoading = false;
    });
  }

  List<Player> _parseStatus(String statusRes) {
    final String status = statusRes.trim();
    final List<String> lines = status.split('\n');
    final int index = lines.indexWhere((String line) => line.startsWith('#'));

    return _parseUsers(lines.sublist(index + 1, lines.length - 1));
  }

  List<Player> _parseUsers(List<String> playerStrings) {
    // 4 1 "haaboo" STEAM_1:0:217416156 00:59 50 0 active 128000 49.36.240.49:27005
    final List<Player> playersOnSv = <Player>[];

    for (final String line in playerStrings) {
      if (line.startsWith('#end')) {
        break;
      }

      final String name = line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
      final List<String> split = line.split(' ');
      final String steamId = split[5];
      final String time = split[6];
      final String ping = split[7];
      final String score = split[8];

      playersOnSv.add(Player(name, score, time, ping, steamId));
    }

    return playersOnSv;
  }
}
