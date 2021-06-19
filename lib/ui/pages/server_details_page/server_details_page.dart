import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:source_server/source_server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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


class Choice {
  Choice({this.title, this.icon, this.onSelect});

  final String title;
  final IconData icon;
  final Function onSelect;
}

const List<String> defaultMaps = <String>[
  'de_cache', 'de_dust2', 'de_inferno', 'de_mirage', 'de_nuke',
  'de_ancient', 'de_overpass', 'de_train', 'de_vertigo', '',
];

class _ServerDetailsPageState extends State<ServerDetailsPage> {
  String ip;
  int port;
  String rconPassword;

  bool isLoading = true;
  SourceServer sourceServer;
  List<Player> players;
  List<String> maps = defaultMaps;
  List<Command> commands = <Command>[];
  String map;
  String numOfPlayers;
  String maxPlayers;

  List<Choice> choices = <Choice>[];

  @override
  void initState() {
    super.initState();

    ip = widget.server.serverIp;
    port = int.parse(widget.server.serverPort);
    rconPassword = widget.server.serverRcon;

    refreshInfo();
    choices = <Choice>[
      Choice(title: 'Restart server', icon: Icons.refresh_sharp,
          onSelect: _restartSv),
    ];
  }

  void _selectChoice(Choice choice) {
    if (choice.onSelect != null) {
      choice.onSelect(context);
    }
  }

  void _restartSv (BuildContext context) {
    showToast(context,
        'Restarting, server will not respond for a minute');
    sendCommandToSv('_restart');
    // ignore: always_specify_types
    Future.delayed(const Duration(seconds: 2),
            () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.server.serverName),
          actions: <Widget>[
            // overflow menu
            PopupMenuButton<Choice>(
              onSelected: _selectChoice,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(choice.icon),
                        const SizedBox(width: 10,),
                        Text(choice.title),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppStyles.white20, width: 1.0,),
                )
              ),
              child: TabBar(
                isScrollable: true,
                labelStyle: AppStyles.tabItem,
                labelColor: AppStyles.blue2,
                unselectedLabelColor: AppStyles.white70,
                unselectedLabelStyle: AppStyles.tabItem,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      children: <Widget>[
                        const FaIcon(FontAwesomeIcons.infoCircle, size: 18),
                        const SizedBox(width: 10,),
                        Text(AppLocalizations.of(context)
                            .getTranslatedValue('details_tab_label'))
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: <Widget>[
                        const FaIcon(FontAwesomeIcons.terminal, size: 18,),
                        const SizedBox(width: 10,),
                        Text(AppLocalizations.of(context)
                            .getTranslatedValue('console_tab_label'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
          ServerDetailsHeader(widget.server, map, defaultMaps),
          ServerControls(widget.server, map, refreshInfo,
              sendCommandToSv, showToast, maps, numOfPlayers, maxPlayers,),
          PlayersList(players, refreshInfo, sendCommandToSv, showToast),
          if (players.isEmpty) EmptyServerState(),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTerminal(BuildContext context) {
    return Console(sendCommandToSv, commands);
  }


  Future<SourceServer> _createSourceServer () async{
    return await SourceServer.connect(
        ip, port, password: rconPassword
    );
  }

  Future<void> _connectToServer(Function callBack) async {
    try {
      final SourceServer server = await _createSourceServer()
          .timeout(const Duration(seconds: 2));

      callBack(server);
    } catch (e) {
      print('Connection to server timed out');
      print(e);
      _connectToServer(callBack);
    }
  }

  Future<void> sendCommandToSv(String cmd) async {
    // clear console history
    if (cmd == 'clear') {
      setState(() {
        commands = <Command>[];
      });

      return;
    }

    _connectToServer((SourceServer sv) async {
      final String res = await sv.command(cmd);

      setState(() {
        commands.add(Command(cmd, false));
        commands.add(Command(res, true));
      });

      sv.close();
    });
  }

  void showToast(BuildContext context, String text, {int durationSec = 1}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: durationSec),
    ));
  }

  Future<void> refreshInfo() async {
    setState(() {
      isLoading = true;
    });
    _connectToServer((SourceServer sourceServer) async {
      final ServerInfo serverInfo = await sourceServer.getInfo();
      final String statusRes = await sourceServer.command('status');
      final String mapsRes = await sourceServer.command('maps *');
      // admins, mods, vips
      final String playersWithPower = await sourceServer.command('sm_who');

      setState(() {
        players = Utils.parseStatus(statusRes, playersWithPower);
        map = serverInfo.map;
        numOfPlayers = serverInfo.players.toString();
        maxPlayers = serverInfo.maxPlayers.toString();
        maps = Utils.parseMaps(mapsRes);
        isLoading = false;
      });

      sourceServer.close();
    });
  }
}
