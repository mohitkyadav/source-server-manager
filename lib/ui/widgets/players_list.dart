import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class PlayersList extends StatelessWidget {
  const PlayersList(this.players, this.refreshInfo,
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
            title: Text('Mute ${player.name}',
              style: AppStyles.playerActionText,),
            subtitle: const Text('Mute user from voice and text chat',
              style: AppStyles.playerActionSubText,),
            onTap: () {
              Navigator.pop(context);
              _displayMuteDialog(context, 'sm_silence', player);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.ban, size: 18,),
            title: Text('Ban player ${player.name}',
                style: AppStyles.playerActionText),
            onTap: () {
              Navigator.pop(context);
              _displayBanDialog(context, 'sm_ban', player);
            },
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

  Future<void> _displayBanDialog(BuildContext context, String cmd,
      Player player) async {
    final TextEditingController _durationFieldController = TextEditingController();
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ban Player ${player.name}'),
          backgroundColor: AppStyles.darkBg,
          titleTextStyle: AppStyles.playerActionDialogTitle,
          content: Container(
            height: 180,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                TextField(
                  controller: _durationFieldController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Duration in minutes (Default 10 min)',
                  ),
                ),
                const SizedBox(height: 30,),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Reason (optional)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: AppStyles.playerActionBtn,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Ban', style: AppStyles.playerActionBtn),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () async {
                final String finalCmd = '$cmd '
                    '${player.name} ${_durationFieldController.text.isNotEmpty
                    ? _durationFieldController.text : 10}'
                    ' ${_textFieldController.text}';
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

  Future<void> _displayMuteDialog(BuildContext context, String cmd,
      Player player) async {
    final TextEditingController _durationFieldController = TextEditingController();
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mute Player ${player.name}'),
          backgroundColor: AppStyles.darkBg,
          titleTextStyle: AppStyles.playerActionDialogTitle,
          content: Container(
            height: 180,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                TextField(
                  controller: _durationFieldController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Duration in minutes (Default 10 min)',
                  ),
                ),
                const SizedBox(height: 30,),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Reason (optional)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: AppStyles.playerActionBtn,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Mute', style: AppStyles.playerActionBtn),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: () async {
                final String finalCmd = '$cmd '
                    '${player.name} ${_durationFieldController.text.isNotEmpty
                    ? _durationFieldController.text : 10}'
                    ' ${_textFieldController.text}';
                await sendCommandToSv(finalCmd);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayKickDialog(BuildContext context, String cmd,
      Player player) async {
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppStyles.darkBg,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Kick Player ${player.name}',
                  style: AppStyles.playerActionDialogTitle,),
                const SizedBox(height: 20,),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Reason (optional)'),
                ),
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('CANCEL', style: AppStyles.playerActionBtn,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16,),
                    TextButton(
                      child: const Text('KICK', style: AppStyles.playerActionBtn),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      onPressed: () async {
                        final String finalCmd = '$cmd '
                            '${player.name} ${_textFieldController.text}';
                        await sendCommandToSv(finalCmd);
                        Navigator.pop(context);
                        await refreshInfo();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
