import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/$map.jpg',),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1,),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 4, color: Theme.of(context).accentColor),
                    ),
                    gradient: LinearGradient(
                      begin: const Alignment(-1, 0.1),
                      end: const Alignment(1, 4),
                      colors: <Color>[AppStyles.charcoalGrey.withOpacity(0.8),
                        AppStyles.blue.withOpacity(0.1)],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.dns, color: AppStyles.lightPurple,),
                      const SizedBox(width: 10,),
                      Text('${server.serverIp}:${server.serverPort}',
                          style: AppStyles.serverDetailsHeaderTitle),
                    ],
                  ),
                  const SizedBox(height: 60,),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.map_rounded, color: AppStyles.lightPurple,),
                      const SizedBox(width: 10,),
                      Text(map, style: AppStyles.serverDetailsHeaderSubTitle),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.people, color: AppStyles.lightPurple,),
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
