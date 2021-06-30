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
    this.imgSize,
    this.bgColor,
    this.borderRadius,
  }) : super(key: key);

  final Player player;
  final double imgSize;
  final Color bgColor;
  final BorderRadius borderRadius;

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.bgColor ?? AppStyles.black,
        borderRadius: widget.borderRadius
      ),
      child: Row(
        children: <Widget>[
          if (isLoading)
            Container(
              width: widget.imgSize ?? 70,
              height: widget.imgSize ?? 70,
              decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: <Color>[AppStyles.blue2, AppStyles.purple],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight
                ),
              )
            )
          else AdvancedAvatar(
            name: name,
            image: NetworkImage(profileImg),
            size: widget.imgSize ?? 70,
            bottomLeft: _buildBadges(context),
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _getBorderColor(context),
                width: 2.0,
              ),
            ),
          ),
          const SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text(name, style: AppStyles.playerItemTitle,
                  overflow: TextOverflow.ellipsis,),
              ),
              const SizedBox(height: 8,),
              Row(
                children: <Widget>[
                  const Icon(CupertinoIcons.wifi, size: 14,
                    color: AppStyles.white40,),
                  const SizedBox(width: 6,),
                  SizedBox(
                    width: 52,
                    child: Text('${widget.player.ping}ms',
                      style: AppStyles.serverItemSubTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12,),
                  const Icon(FontAwesomeIcons.clock, size: 14,
                    color: AppStyles.white40,),
                  const SizedBox(width: 6,),
                  SizedBox(
                    width: 72,
                    child: Text('${widget.player.duration} min',
                      style: AppStyles.serverItemSubTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 18,),
                  const Icon(FontAwesomeIcons.hashtag, size: 14,
                    color: AppStyles.white40,),
                  const SizedBox(width: 6,),
                  Text(widget.player.timesConnected,
                    style: AppStyles.serverItemSubTitle,
                    overflow: TextOverflow.ellipsis,
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
      return AppStyles.yellow.withOpacity(0.7);
    }

    if (isVip) {
      return AppStyles.green60;
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
              color: AppStyles.green80),
      );
    }

    return null;
  }

  Future<void> _fetchProfile () async {
    final dynamic playerProfile = await getPlayerDetails(widget.player.id);

    setState(() {
      isLoading = false;
      profileImg = playerProfile['profile']['avatarFull'].toString();
    });
  }
}
