import 'dart:io';

import 'package:flutter/material.dart';
import 'package:source_server/source_server.dart';
import 'package:turrant/models/cmd.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/ui/pages/server_details/console.dart';
import 'package:turrant/ui/pages/server_details/players_list.dart';
import 'package:turrant/ui/pages/server_details/server_controls.dart';
import 'package:turrant/ui/pages/server_details/server_details_header.dart';
import 'package:turrant/utils/utils.dart';

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
  List<String> maps;
  List<Command> commands = <Command>[];
  String map;
  String numOfPlayers;
  String maxPlayers;

  @override
  void initState() {
    super.initState();

    ip = widget.server.serverIp;
    port = int.parse(widget.server.serverPort);
    rconPassword = widget.server.serverRcon;

    refreshInfo();
    _setMaps();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.server.serverName),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.dns)),
              Tab(icon: Icon(Icons.branding_watermark)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetails(context),
            _buildTerminal(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return RefreshIndicator(
      key: const ValueKey<String> ('PullToRefreshServerDetails'),
      onRefresh: () => refreshInfo(),
      child: !isLoading ? ListView(
        children: <Widget>[
          ServerDetailsHeader(widget.server, map, numOfPlayers, maxPlayers),
          ServerControls(widget.server, map, refreshInfo,
              sendCommandToSv, showToast, maps),
          PlayersList(players, refreshInfo, sendCommandToSv, showToast),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTerminal(BuildContext context) {
    return Console(sendCommandToSv, commands);
  }

  Future<String> sendCommandToSv(String cmd) async {
    final SourceServer sv = SourceServer(InternetAddress(ip), port, rconPassword);

    await sv.connect();
    final String res = await sv.send(cmd);

    setState(() {
      commands.add(Command(cmd, false));
      commands.add(Command(res, true));
    });

    sv.close();
  }

  void showToast(BuildContext context, String text) {
    final ScaffoldState scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> _setMaps() async {
    final SourceServer sv = SourceServer(InternetAddress(ip), port, rconPassword);

    await sv.connect();
    final String res = await sv.send('maps *');
    setState(() {
      maps = Utils.parseMaps(res);
    });
  }

  Future<void> refreshInfo() async {
    final SourceServer sourceServer = SourceServer(
        InternetAddress(ip), port, rconPassword);
    await sourceServer.connect();

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> serverInfo = await sourceServer.getInfo();
    final String statusRes = await sourceServer.send('status');

    setState(() {
      players = Utils.parseStatus(statusRes);
      map = serverInfo['map'].toString();
      numOfPlayers = serverInfo['players'].toString();
      maxPlayers = serverInfo['maxplayers'].toString();
      isLoading = false;
    });

    sourceServer.close();
  }
}
