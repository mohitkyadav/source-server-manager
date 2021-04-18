import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/ui/pages/home_page//server_item.dart';

class ServersList extends StatelessWidget {
  const ServersList(this.servers, this._removeServer, this.handleSvLongPress);

  final List<Server> servers;
  final Function _removeServer;
  final Function handleSvLongPress;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: servers.length,
            itemBuilder: (BuildContext context, int index) {
              return ServerItem(
                  servers[index], _removeServer, handleSvLongPress);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
        ),
      ],
    );
  }
}
