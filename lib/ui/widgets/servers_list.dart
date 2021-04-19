import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';

import 'server_item.dart';

class ServersList extends StatelessWidget {
  const ServersList(this.servers, this._removeServer, this.handleSvLongPress);

  final List<Server> servers;
  final Function _removeServer;
  final Function handleSvLongPress;

  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ServerItem(
                servers[index], _removeServer, handleSvLongPress),
              const SizedBox(height: 10,),
            ],
          );
        },
        childCount: servers.length,
      ),
    );
  }
}
