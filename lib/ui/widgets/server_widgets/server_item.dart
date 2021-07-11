import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:source_server/source_server.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/models.dart';
import 'package:turrant/routes/route_names.dart';
import 'package:turrant/themes/styling.dart';

class ServerItem extends StatefulWidget {
  const ServerItem(this.server, this._removeServer,
      this._handleSvLongPress, this._setSelectedServer);

  final Server server;
  final Function _removeServer;
  final Function _handleSvLongPress;
  final Function _setSelectedServer;

  @override
  _ServerItemState createState() => _ServerItemState();
}

class _ServerItemState extends State<ServerItem> {
  String playerInfo = '0 / 10';
  Timer _periodicCheckInfo;
  bool _isTvEnabled = false;
  bool _isOffline = false;

  @override
  void initState() {
    _checkPlayerCount();
    _periodicCheckInfo = Timer.periodic(
        const Duration(seconds: 15), (Timer t) => _checkPlayerCount());
    super.initState();
  }

  @override
  void dispose() {
    _periodicCheckInfo.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Slidable(
      key: Key('${widget.server.serverIp}:${widget.server.serverName}'),
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          final bool isSmallScreen = MediaQuery.of(context).size.width < 900;

          if (isSmallScreen) {
            Navigator.pushNamed(context, serverDetailsRoute,
                arguments: widget.server);
          }
          widget._setSelectedServer(widget.server);
        },
        onLongPress: () {
          widget._handleSvLongPress(widget.server);
        },
        child: Material(
          elevation: 8,
          shadowColor: (_isOffline ? AppStyles.red : AppStyles.blue2)
              .withOpacity(0.1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: (_isOffline ? AppStyles.red : AppStyles.blue2)
                  .withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(widget.server.serverName,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.serverItemTitle,),
                      ),
                      if(widget.server.serverRcon != null) const Icon(
                        Icons.lock_open_rounded, size: 16,
                          color: AppStyles.white40),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.group, size: 20,
                            color: AppStyles.white40,),
                          const SizedBox(width: 5,),
                          Text(playerInfo, style: AppStyles.serverItemSubTitle),
                        ],
                      ),
                      if (_isTvEnabled)
                        const Icon(Icons.tv, size: 16,
                          color: AppStyles.white40,),
                      if (_isOffline)
                        const Icon(Icons.signal_wifi_off_sharp, size: 16,
                          color: AppStyles.white40,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        SlideAction(
            child: Container(
                width: 105,
                margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                  color: AppStyles.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.clear),
                    Text(AppLocalizations.of(context)
                        .getTranslatedValue('delete_sv_msg'),
                      style: AppStyles.serverItemActionText,)
                  ],
                )
            ),
            onTap: () => widget._removeServer(widget.server)
        ),
      ],
      secondaryActions: <Widget>[
        SlideAction(
            child: Container(
                width: 105,
                margin: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  color: AppStyles.lightPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.edit),
                    Text(AppLocalizations.of(context)
                        .getTranslatedValue('edit_sv_msg'),
                        style: AppStyles.serverItemActionText)
                  ],
                )
            ),
            onTap: () => widget._handleSvLongPress(widget.server)
        ),
      ],
    );
  }

  Future<void> _checkPlayerCount() async {
    try {
      final SourceServer server = await SourceServer.connect(
        widget.server.serverIp,
        int.parse(widget.server.serverPort),
        password: widget.server.serverRcon,
      );

      final ServerInfo info = await server.getInfo();
      server.close();

      setState(() {
        playerInfo = '${info.players} / ${info.maxPlayers}';
        _isTvEnabled = info.tvPort != null;
        _isOffline = false;
      });
    } catch (e) {
      setState(() {
        _isOffline = true;
        _isTvEnabled = false;
      });
    }
  }
}
