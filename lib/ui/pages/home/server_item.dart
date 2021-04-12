import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/routes/route_names.dart';
import 'package:turrant/themes/styling.dart';

class ServerItem extends StatelessWidget {
  const ServerItem(this.server);

  final Server server;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, serverDetailsRoute, arguments: server);
      },
      child: Material(
        elevation: 12,
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          showAllActionsThreshold: 1,
          secondaryActions: <Widget>[
            IconSlideAction(
                icon: Icons.delete,
                color: AppStyles.red,
                onTap: () {
                  print('remove sv');
                }
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(15),
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
    );
  }
}
