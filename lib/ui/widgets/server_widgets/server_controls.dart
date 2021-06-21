import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:turrant/localization/app_localizations.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class ServerControls extends StatelessWidget {
  const ServerControls(this.server, this.map, this.refreshInfo,
      this.sendCommandToSv, this.showToast, this.maps,  this.numOfPlayers,
      this.maxPlayers, this.version, this.tvPort);

  final Server server;
  final String map;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;
  final List<String> maps;
  final String numOfPlayers;
  final String maxPlayers;
  final String version;
  final int tvPort;

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
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.map, color: AppStyles.blue2,
                              size: 18
                          ),
                          const SizedBox(width: 8,),
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
                  TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(4),
                      backgroundColor: MaterialStateProperty.all(AppStyles.blue2),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                          )
                      ),
                    ),
                    // borderRadius: BorderRadius.all(Radius.circular(5))
                    child: Text(AppLocalizations.of(context)
                        .getTranslatedValue('change_map'),
                      style: AppStyles.mapBtn,),
                    onPressed: () {
                      showModalBottomSheet<Widget>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) =>
                              _buildMapOptions(context));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (tvPort != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(Icons.tv, color: AppStyles.blue2, size: 18,),
                        const SizedBox(width: 8,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Source TV address',
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.serverDetailsHeaderTitle),
                            const SizedBox(height: 2,),
                            Text('${server.serverIp}:$tvPort',
                                style: AppStyles.serverDetailsHeaderSubTitle),
                          ],
                        ),
                      ],
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(FontAwesomeIcons.codeBranch,
                        color: AppStyles.blue2, size: 18),
                      const SizedBox(width: 8,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(version,
                            style: AppStyles.serverDetailsHeaderTitle,),
                          const SizedBox(height: 2,),
                          const Text('Server Version',
                              style: AppStyles.consoleRes),
                        ],
                      ),
                    ],
                  ),
                ],
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
              Text('${AppLocalizations.of(context).getTranslatedValue(
                  'player_count')} ($numOfPlayers/$maxPlayers)',
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


  Widget _buildMapOptions(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.75;
    const double searchHeight = 0;

    return Container(
      height: sheetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Container(
          //   height: searchHeight,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       suffixIcon: Icon(Icons.search),
          //       labelText: 'Search',
          //       contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //     ),
          //   ),
          // ),
          Container(
            height: sheetHeight - searchHeight,
            child: ListView.builder(
              itemCount: maps.length,
              padding: const EdgeInsets.only(bottom: 15),
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(maps[i], style: AppStyles.playerActionText),
                  onTap: () {
                    Navigator.pop(context);
                    sendCommandToSv('map ${maps[i]}');
                    showToast(context, 'Changing map to ${maps[i]}',
                        durationSec: 4);

                    // ignore: always_specify_types
                    Future<void>.delayed(const Duration(seconds: 4),
                            () => refreshInfo());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
