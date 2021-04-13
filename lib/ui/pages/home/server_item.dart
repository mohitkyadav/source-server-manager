import 'package:flutter/material.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/routes/route_names.dart';
import 'package:turrant/themes/styling.dart';

class ServerItem extends StatelessWidget {
  const ServerItem(this.server, this._removeServer, this.handleSvLongPress);

  final Server server;
  final Function _removeServer;
  final Function handleSvLongPress;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(server.serverIp),
      background: Container(
        padding: const EdgeInsets.only(left: 35, right: 35),
        color: AppStyles.red.withOpacity(0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: AppStyles.white.withOpacity(0.9),
            ),
          ],
        ),
      ),
      onDismissed: (DismissDirection dir) {
        _removeServer(server);
      },
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, serverDetailsRoute, arguments: server);
        },
        onLongPress: () {
          handleSvLongPress(server);
        },
        child: Material(
          elevation: 12,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppStyles.charcoalGrey,
              gradient: const LinearGradient(
                begin: Alignment(-4, 0.1),
                end: Alignment(1, 0.1),
                colors: <Color>[AppStyles.blue, AppStyles.charcoalGrey],
              ),
              border: Border(
                bottom: BorderSide(
                    width: 4, color: Theme.of(context).accentColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(server.serverName, style: AppStyles.serverItemTitle,),
                  const SizedBox(height: 8,),
                  Text('${server.serverIp} ${server.serverPort}',
                    style: AppStyles.serverItemSubTitle,
                  ),
                  const SizedBox(height: 8,),
                  Text(server.serverGame, style: AppStyles.serverItemSubTitle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
