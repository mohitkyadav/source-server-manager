import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class ServerDetailsHeader extends StatelessWidget {
  const ServerDetailsHeader(this.server, this.map, this.availableMaps,
      this.isPublic, this.isVacEnabled, this.isTvEnabled);

  final Server server;
  final String map;
  final bool isPublic;
  final bool isVacEnabled;
  final bool isTvEnabled;
  final List<String> availableMaps;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: AppStyles.blackShadowOp40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          ActionChip(
                            backgroundColor: AppStyles.darkBg,
                            elevation: 7,
                            label: const Text('VAC',),
                            avatar: Icon(Icons.shield, color: isVacEnabled
                                ? AppStyles.green80 : AppStyles.red,
                              size: 16,
                            ),
                            onPressed: () {
                              print('isVacEnabled: $isVacEnabled');
                            },
                          ),
                          const SizedBox(width: 15,),
                          ActionChip(
                            backgroundColor: AppStyles.darkBg,
                            elevation: 7,
                            label: Text(isPublic ?  'Public' : 'Private',),
                            avatar: Icon(
                              isPublic ? Icons.lock_open : Icons.lock_rounded,
                              color: isPublic
                                  ? AppStyles.blue2 : AppStyles.yellow,
                              size: 16,
                            ),
                            onPressed: () {
                              print('isPublic: $isPublic');
                            },
                          ),
                          if (isTvEnabled) ...<Widget>[
                            const SizedBox(width: 15,),
                            ActionChip(
                              backgroundColor: AppStyles.darkBg,
                              elevation: 7,
                              label: const Text('TV',),
                              avatar: const Icon(Icons.tv,
                                color: AppStyles.blue, size: 16,
                              ),
                              onPressed: () {
                                print('Tv is on.');
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
         const SizedBox(height: 130,)
        ],
      ),
    );
  }
}
