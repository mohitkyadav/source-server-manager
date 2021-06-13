import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class PlayersList extends StatelessWidget {
  PlayersList(this.players, this.refreshInfo,
      this.sendCommandToSv, this.showToast);

  final List<Player> players;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {

        return Material(
          elevation: 4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.only(top: 0, right: 15, bottom: 12, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 2, color: AppStyles.blue2.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Text(players[index].name, style: AppStyles.playerItemTitle,),
                     IconButton(
                       onPressed: () {
                         showModalBottomSheet<Widget>(
                             context: context,
                             isScrollControlled: true,
                             builder: (BuildContext context) =>
                                 _buildPlayerOptions(context, players[index]));
                       },
                       icon: const FaIcon(FontAwesomeIcons.ellipsisH, size: 18,)
                     ),
                   ],
                 ),
                Row(
                  children: <Widget>[
                    Text('Ping: ${players[index].ping}ms',
                      style: AppStyles.serverItemSubTitle,
                    ),
                    const SizedBox(width: 15,),
                    Text('Score: ${players[index].score}',
                      style: AppStyles.serverItemSubTitle,
                    ),
                    const SizedBox(width: 15,),
                    Text('Duration: ${players[index].duration} Minutes',
                      style: AppStyles.serverItemSubTitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
    );
  }

  Widget _buildPlayerOptions(BuildContext context, Player player) {
    return Container(
      color: AppStyles.darkBg,
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        children: <Widget>[
          ListTile(
            selectedTileColor: AppStyles.blue2,
            leading: const FaIcon(FontAwesomeIcons.microphoneSlash, size: 18,),
            title: Text('Mute ${player.name} (WIP)',
              style: AppStyles.playerActionText,),
            subtitle: const Text('Mute user from voice and text chat',
              style: AppStyles.playerActionSubText,),
            enabled: false,
            // onTap: () => _displayKickDialog(context, 'sm_kick', player),
          ),
          ListTile(
            enabled: false,
            leading: const FaIcon(FontAwesomeIcons.ban, size: 18,),
            title: Text('Ban player ${player.name} (WIP)',
                style: AppStyles.playerActionText),
            // onTap: () => _displayKickDialog(context, 'sm_kick', player),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.userSlash, size: 18,),
            title: Text('Kick ${player.name} From The Server',
                style: AppStyles.playerActionText),
            onTap: () {
              Navigator.pop(context);
              _displayKickDialog(context, 'sm_kick', player);
            },
          ),
          const Divider(height: 5, color: AppStyles.white60),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.copy, size: 18,),
            title: const Text('Copy Steam id',
                style: AppStyles.playerActionText),
            subtitle: Text(player.steamId,
              style: AppStyles.playerActionSubText,),
            onTap: () async {
              showToast(context, 'Copied Steam_Id ${player.steamId}',
                  durationSec: 4);

              final ClipboardData data = ClipboardData(text: player.steamId);
              await Clipboard.setData(data);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _displayKickDialog(BuildContext context, String cmd,
      Player player) async {
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kick Player ${player.name}'),
          backgroundColor: AppStyles.darkBg,
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Reason (optional)'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: AppStyles.playerActionBtn,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Kick', style: AppStyles.playerActionBtn.copyWith(
                  color: AppStyles.red)),
              onPressed: () async {
                final String finalCmd = '$cmd '
                    '${player.name} ${_textFieldController.text}';
                await sendCommandToSv(finalCmd);
                Navigator.pop(context);
                await refreshInfo();
              },
            ),
          ],
        );
      },
    );
  }
}
