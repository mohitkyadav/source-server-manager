import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: AppStyles.red.withOpacity(0.8),
        ),
        padding: const EdgeInsets.only(left: 35, right: 35),
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
          elevation: 8,
          shadowColor: AppStyles.blue2.withOpacity(0.1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppStyles.blue2.withOpacity(0.2),
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
                        child: Text(server.serverName,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.serverItemTitle,),
                      ),
                      if(server.serverRcon != null) const Icon(
                        Icons.lock_open_rounded, size: 16,),
                    ],
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
