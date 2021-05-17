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
           const SizedBox(height: 140,)
          ],
        ),
      ),
    );
  }
}
