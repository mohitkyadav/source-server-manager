import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';

import 'server_widgets/server_item.dart';

class ServersList extends StatelessWidget {
  const ServersList(this.servers, this._removeServer,
    this._handleSvLongPress, this._setSelectedServer);

  final List<Server> servers;
  final Function _removeServer;
  final Function _handleSvLongPress;
  final Function _setSelectedServer;

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ServerItem(servers[index], _removeServer,
                _handleSvLongPress, _setSelectedServer),
          );
        },
        childCount: servers.length,
      ),
    );
  }
}
