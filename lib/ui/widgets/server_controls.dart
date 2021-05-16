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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppStyles.blue2.withOpacity(0.1),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if(maps != null) DropdownButton<String>(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.people_rounded),
                      const SizedBox(width: 10,),
                      Text('Active Players ($numOfPlayers/$maxPlayers)',
                        style: AppStyles.serverDetailsHeaderSubTitle
                            .copyWith(color: AppStyles.white),),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => refreshInfo(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.refresh_sharp, color: AppStyles.blue2,),
                        const SizedBox(width: 10,),
                        Text(
                          AppLocalizations.of(context)
                              .getTranslatedValue('refresh_players_tooltip'),
                          style: AppStyles.underlineButton,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
