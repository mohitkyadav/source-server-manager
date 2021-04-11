import 'package:flutter/material.dart';
import 'package:turrant/localization/app_localizations.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/themes/styling.dart';

class ServerControls extends StatelessWidget {
  const ServerControls(this.server, this.map, this.refreshInfo,
      this.sendCommandToSv);

  final Server server;
  final String map;
  final Function refreshInfo;
  final Function sendCommandToSv;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppStyles.lightPurple.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('refresh_sv_tooltip'),
              onPressed: () => refreshInfo(),
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: const Icon(Icons.map),
              color: Colors.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('change_map_tooltip'),
              onPressed: () {
                print('open dropdown with map names');
              },
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: const Icon(Icons.people_rounded),
              color: Colors.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('refresh_players_tooltip'),
              onPressed: () => refreshInfo(),
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: const Icon(Icons.autorenew),
              color: Colors.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('restart_sv_tooltip'),
              onPressed: () {
                print('restart server');
              },
            ),
          ],
        ),
      ),
    );
  }
}
