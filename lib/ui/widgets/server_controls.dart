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

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppStyles.blue2.withOpacity(0.44),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.map_rounded, color: AppStyles.blue2,),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(map, overflow: TextOverflow.ellipsis,
                              style: AppStyles.serverDetailsHeaderTitle),
                          const SizedBox(height: 2,),
                          Text('${server.serverIp}:${server.serverPort}',
                              style: AppStyles.serverDetailsHeaderSubTitle),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: const BoxDecoration(
                      color: AppStyles.blue2,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Text(AppLocalizations.of(context)
                      .getTranslatedValue('change_map'),
                    style: AppStyles.mapBtn,),
                ),
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
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${AppLocalizations.of(context)
                  .getTranslatedValue('player_count')} ($numOfPlayers/$maxPlayers)',
                style: AppStyles.serverDetailsHeaderSubTitle
                    .copyWith(color: AppStyles.white),),
              InkWell(
                onTap: () => refreshInfo(),
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
            ],
          ),
        )
      ],
    );
  }
}
