import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turrant/localization/app_localizations.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class ServerControls extends StatelessWidget {
  const ServerControls(this.server, this.map, this.refreshInfo,
      this.sendCommandToSv, this.showToast, this.maps,  this.numOfPlayers,
      this.maxPlayers);

  final Server server;
  final String map;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;
  final List<String> maps;
  final String numOfPlayers;
  final String maxPlayers;

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppStyles.blue2.withOpacity(0.1),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Text('Players ($numOfPlayers/$maxPlayers)',
                        style: AppStyles.serverDetailsHeaderSubTitle
                            .copyWith(color: AppStyles.white),),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  // icon: const Icon(Icons.map),
                  child: const Text('Change map',
                    style: AppStyles.underlineButton,),
                  onSelected: (String map) {
                    sendCommandToSv('map $map');
                    showToast(context, 'Changing map to $map', durationSec: 4);

                    // ignore: always_specify_types
                    Future<void>.delayed(const Duration(seconds: 4),
                            () => refreshInfo());
                  },
                  itemBuilder: (BuildContext context) {
                    return maps.map((String map) {
                      return PopupMenuItem<String>(
                        value: map,
                        child: Row(
                          children: <Widget>[
                            Text(map),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
                InkWell(
                  onTap: () => refreshInfo(),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .getTranslatedValue('refresh_players_tooltip'),
                          style: AppStyles.underlineButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
