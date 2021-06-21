import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
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
                  padding: EdgeInsets.all(17),
                  child: CircularProgressIndicator(),
                )
              else AdvancedAvatar(
                name: name,
                image: NetworkImage(profileImg),
                size: 70,
                bottomLeft: _buildBadges(context),
                foregroundDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getBorderColor(context),
                    width: 3.0,
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name, style: AppStyles.playerItemTitle,
                    overflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 8,),
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
            ],
          ),
        ],
      ),
    );
  }

  Color _getBorderColor (BuildContext context) {
    final String userFlags = flags ?? '';
    final bool isRoot = userFlags.contains('root')
        || userFlags.contains('admin');
    final bool isVip = userFlags.contains('res');

    if (isRoot) {
      return AppStyles.yellow.withOpacity(0.8);
    }

    if (isVip) {
      return AppStyles.purple.withOpacity(0.8);
    }

    return Colors.transparent;
  }

  Widget _buildBadges (BuildContext context) {
    final String userFlags = flags ?? '';
    final bool isRoot = userFlags.contains('root')
        || userFlags.contains('admin');
    final bool isVip = userFlags.contains('res');

    if (isRoot) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: AppStyles.black,
            shape: BoxShape.circle
        ),
        child: const FaIcon(
            FontAwesomeIcons.shieldAlt, size: 12,
            color: AppStyles.yellow),
      );
    }

    if (isVip) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: AppStyles.black,
            shape: BoxShape.circle
        ),
        child: const FaIcon(FontAwesomeIcons.crown, size: 10,
              color: AppStyles.purple),
      );
    }

    return null;
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
