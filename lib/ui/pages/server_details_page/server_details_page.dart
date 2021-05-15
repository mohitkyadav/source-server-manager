import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:source_server/source_server.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/ui/widgets/widgets.dart';
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
          bottom: TabBar(
            labelStyle: AppStyles.tabItem,
            labelColor: AppStyles.blue2,
            unselectedLabelColor: AppStyles.white70,//For Selected tab
            unselectedLabelStyle: AppStyles.tabItem,
            tabs: <Widget>[
              Tab(icon: const Icon(Icons.dns),
                text: AppLocalizations.of(context)
                    .getTranslatedValue('details_tab_label'),),
              Tab(icon: const Icon(Icons.branding_watermark),
                text: AppLocalizations.of(context)
                  .getTranslatedValue('console_tab_label'),),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
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
          if (players.isEmpty) EmptyServerState(),
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

  void showToast(BuildContext context, String text, {int durationSec = 1}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: durationSec),
    ));
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
