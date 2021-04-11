import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:turrant/models/server.dart';
import 'package:turrant/themes/styling.dart';

class ServerDetailsHeader extends StatelessWidget {
  const ServerDetailsHeader(this.server, this.map, this.numOfPlayers,
      this.maxPlayers);

  final Server server;
  final String map;
  final String numOfPlayers;
  final String maxPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1,
              heightFactor: 0.2,
              child: Image.asset('assets/img/$map.jpg',),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2,),
              child: Container(
                color: AppStyles.blackShadowOp20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('IP: ${server.serverIp}:${server.serverPort}',
                    style: AppStyles.serverDetailsHeaderTitle),
                const SizedBox(height: 55,),
                Text('Current Map: $map', style: AppStyles.serverDetailsHeaderSubTitle),
                const SizedBox(height: 5,),
                Text('Players: $numOfPlayers / $maxPlayers',
                    style: AppStyles.serverDetailsHeaderSubTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
