import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class PlayersList extends StatelessWidget {
  PlayersList(this.players, this.refreshInfo,
      this.sendCommandToSv, this.showToast);

  final List<Player> players;
  final Function refreshInfo;
  final Function sendCommandToSv;
  final Function showToast;
  final List<String> playerActions = <String>[
    'Copy Steam_id',
    'Kick',
    'Ban (work in progress)',
  ] ;

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
                     DropdownButton<String>(
                       underline: const SizedBox(),
                       onChanged: (String action) => _displayTextInputDialog(
                           context, action, players[index]),
                       icon: const Icon(Icons.more_horiz),
                       iconEnabledColor: AppStyles.white,
                       items: playerActions.map(
                             (String action) => DropdownMenuItem<String>(
                           value: action, child: Text(action),),
                       ).toList(),
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

  Future<void> _displayTextInputDialog(BuildContext context, String cmd,
      Player player) async {
    // copy steam id
    if (playerActions[0] == cmd) {
      showToast(context, 'Copied Steam_Id ${player.steamId}', durationSec: 4);

      final ClipboardData data = ClipboardData(text: player.steamId);
      await Clipboard.setData(data);
    }

    // kick player
    if (playerActions[1] == cmd) {
      _displayKickDialog(context, 'sm_kick', player);
    }

    // ban player
    if (playerActions[2] == cmd) {
      print('wip');
    }
  }


  Future<void> _displayKickDialog(BuildContext context, String cmd,
      Player player) async {
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reason for Kicking ${player.name}'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Reason (optional)'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                final String finalCmd = '$cmd '
                    '${player.name} ${_textFieldController.text}';
                await sendCommandToSv(finalCmd);
                await refreshInfo();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
