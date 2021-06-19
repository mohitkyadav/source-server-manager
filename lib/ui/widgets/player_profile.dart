import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/steam_api/steam_api.dart';
import 'package:turrant/themes/styling.dart';

class PlayerProfile extends StatefulWidget {
  const PlayerProfile({
    Key key,
    this.player,
  }) : super(key: key);

  final Player player;

  @override
  _PlayerProfileState createState() => _PlayerProfileState();
}

class _PlayerProfileState extends State<PlayerProfile> {
  bool isLoading = true;
  String profileImg;
  String name;
  String flags;

  @override
  void initState() {
    _fetchProfile();

    name = widget.player.name;
    flags = widget.player.flag;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String userFlags = flags ?? '';
    final bool isRoot = userFlags.contains('root')
        || userFlags.contains('admin');
    final bool isVip = userFlags.contains('res');
    final bool isBot = userFlags.contains('bot');

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppStyles.lightPurple.withOpacity(0.2),
      ),
      child: Row(
        children: <Widget>[
          if (isLoading)
            const CircleAvatar(backgroundColor: AppStyles.blue2)
          else CircleAvatar(
              backgroundColor: AppStyles.blue2,
              backgroundImage: NetworkImage(profileImg),
              radius: 30,
          ),
          const SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: AppStyles.playerItemTitle,),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (isBot) ...<Widget>[
                    const Tooltip(
                      message: 'Bot',
                      child: FaIcon(
                          FontAwesomeIcons.robot, size: 16,
                          color: AppStyles.blue2),
                    ),
                    const SizedBox(width: 20,),
                  ],
                  if (isVip) ...<Widget>[
                    const Tooltip(
                      message: 'Reserved Slot',
                      child: FaIcon(FontAwesomeIcons.crown, size: 16,
                          color: AppStyles.green80),
                    ),
                    const SizedBox(width: 20,),
                  ],
                  if (isRoot) ...<Widget>[
                    const Tooltip(
                      message: 'Admin',
                      child: FaIcon(
                          FontAwesomeIcons.shieldAlt, size: 16,
                          color: AppStyles.yellow),
                    ),
                    const SizedBox(width: 20,),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _fetchProfile () async {
    final dynamic playerProfile = await getPlayerDetails(widget.player.id);
    print(playerProfile);

    setState(() {
      isLoading = false;
      profileImg = playerProfile['profile']['avatarFull'].toString();
    });
  }
}
