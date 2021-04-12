import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turrant/localization/app_localizations.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/themes/styling.dart';

class ServerControls extends StatelessWidget {
  const ServerControls(this.server, this.map, this.refreshInfo,
      this.sendCommandToSv, this.showToast);

  final Server server;
  final String map;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;

  @override
  Widget build(BuildContext context) {
    const List<String> activeDutyMaps = <String>[
      'de_mirage',
      'de_inferno',
      'de_dust2',
      'de_overpass',
      'de_nuke',
      'de_vertigo',
    ];

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
              color: AppStyles.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('refresh_sv_tooltip'),
              onPressed: () => refreshInfo(),
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: const Icon(Icons.people_rounded),
              color: AppStyles.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('refresh_players_tooltip'),
              onPressed: () => refreshInfo(),
            ),
            const SizedBox(width: 20,),
            IconButton(
              icon: const Icon(Icons.autorenew),
              color: AppStyles.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('restart_sv_tooltip'),
              onPressed: () {
                showToast(context,
                    'Restarting, server will not respond for a minute');
                sendCommandToSv('_restart');
                // ignore: always_specify_types
                Future.delayed(const Duration(seconds: 2),
                        () => Navigator.of(context).pop());
              },
            ),
            const SizedBox(width: 20,),
            DropdownButton<String>(
              hint: Text(AppLocalizations
                  .of(context).getTranslatedValue('change_map_tooltip')),
              underline: const SizedBox(),
              value: map,
              onChanged: (String map) => sendCommandToSv('map $map'),
              icon: const Icon(Icons.map),
              iconEnabledColor: AppStyles.white,
              items: activeDutyMaps.map(
                    (String map) => DropdownMenuItem<String>(
                  value: map, child: Text(map),),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
