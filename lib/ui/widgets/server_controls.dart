import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turrant/localization/app_localizations.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class ServerControls extends StatelessWidget {
  const ServerControls(this.server, this.map, this.refreshInfo,
      this.sendCommandToSv, this.showToast, this.maps);

  final Server server;
  final String map;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;
  final List<String> maps;

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
            IconButton(
              icon: const Icon(Icons.people_rounded),
              color: AppStyles.white,
              tooltip: AppLocalizations.of(context)
                  .getTranslatedValue('refresh_players_tooltip'),
              onPressed: () => refreshInfo(),
            ),
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
            DropdownButton<String>(
              isExpanded: false,
              hint: Text(AppLocalizations
                  .of(context).getTranslatedValue('change_map_tooltip')),
              underline: const SizedBox(),
              value: map,
              onChanged: (String map) {
                sendCommandToSv('map $map');
                showToast(context, 'Changing map to $map', durationSec: 4);

                // ignore: always_specify_types
                Future<void>.delayed(const Duration(seconds: 4),
                        () => refreshInfo());
              },
              icon: const Icon(Icons.map),
              iconEnabledColor: AppStyles.white,
              items: maps.map(
                    (String map) => DropdownMenuItem<String>(
                  value: map, child: SizedBox(
                        width: 130,
                        child: Text(map)),),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
