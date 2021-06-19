import 'package:flutter/cupertino.dart';
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
  bool isVacBanned = false;
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppStyles.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                )
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
                  _buildBadges(context),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: <Widget>[
              const Text('VAC Status',
                overflow: TextOverflow.ellipsis,
                style: AppStyles.gameInfoText,),
              const SizedBox(width: 15,),
              Tooltip(
                message: isVacBanned ? 'VAC Banned' : 'Clean',
                child: FaIcon(isVacBanned ? FontAwesomeIcons.userTimes
                    : FontAwesomeIcons.userCheck, size: 16,
                color: isVacBanned ? AppStyles.red : AppStyles.green,),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadges (BuildContext context) {
    final String userFlags = flags ?? '';
    final bool isRoot = userFlags.contains('root')
        || userFlags.contains('admin');
    final bool isVip = userFlags.contains('res');
    final bool isBot = userFlags.contains('bot');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (isRoot) ...<Widget>[
          const Tooltip(
            message: 'Admin',
            child: FaIcon(
                FontAwesomeIcons.shieldAlt, size: 16,
                color: AppStyles.yellow),
          ),
          const SizedBox(width: 20,),
        ],
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
      ],
    );
  }

  Future<void> _fetchProfile () async {
    final dynamic playerProfile = await getPlayerDetails(widget.player.id);

    setState(() {
      isLoading = false;
      profileImg = playerProfile['profile']['avatarFull'].toString();

      if (playerProfile['profile'] != null) {
        isVacBanned = playerProfile['profile']['vacBanned'] != '0';
      }
    });
  }
}
