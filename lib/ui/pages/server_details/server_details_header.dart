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
    return Material(
      elevation: 12,
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              // height: 120,
              // child: Align(
              //   alignment: Alignment.center,
              //   // widthFactor: 1,
              //   // heightFactor: 0.2,
                child: Image.asset('assets/img/$map.jpg', fit: BoxFit.fitWidth,),
              // ),
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
                  Row(
                    children: <Widget>[
                      const Icon(Icons.map, color: AppStyles.blue,),
                      const SizedBox(width: 10,),
                      Text(map, style: AppStyles.serverDetailsHeaderSubTitle),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.people, color: AppStyles.blue,),
                      const SizedBox(width: 10,),
                      Text('$numOfPlayers / $maxPlayers',
                          style: AppStyles.serverDetailsHeaderSubTitle),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
