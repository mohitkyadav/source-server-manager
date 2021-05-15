import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:turrant/localization/app_localizations.dart';
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

    return Slidable(
      key: Key('${server.serverIp}:${server.serverName}'),
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
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
            onTap: () => _removeServer(server)
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
            onTap: () => handleSvLongPress(server)
        ),
      ],
    );
  }
}
