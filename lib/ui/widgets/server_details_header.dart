import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class ServerDetailsHeader extends StatelessWidget {
  const ServerDetailsHeader(this.server, this.map, this.availableMaps);

  final Server server;
  final String map;
  final List<String> availableMaps;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/${
                availableMaps.contains(map) ? map : 'fallbackmap'}.jpg',),
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
                  color: AppStyles.blackShadowOp60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.map_rounded, color: AppStyles.blue2,),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(map, overflow: TextOverflow.ellipsis,
                                style: AppStyles.serverDetailsHeaderTitle),
                            Text('${server.serverIp}:${server.serverPort}',
                                style: AppStyles.serverDetailsHeaderSubTitle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
