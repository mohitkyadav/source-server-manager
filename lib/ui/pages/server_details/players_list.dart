import 'package:flutter/material.dart';

import 'package:turrant/models/player.dart';
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
    const List<String> playerActions = <String>[
      'Kick',
      // 'Ban',
    ] ;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        final String duration = Duration(
            seconds: int.parse(
                _durationHelper(players[index].duration))).inMinutes.toString();

        return Material(
          elevation: 12,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.only(top: 0, right: 15, bottom: 15, left: 15),
            decoration: BoxDecoration(
              color: AppStyles.charcoalGrey,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 2, color: AppStyles.blue.withOpacity(0.5)),
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
                           context, action, players[index].name),
                       icon: const Icon(Icons.more_vert),
                       iconEnabledColor: AppStyles.white,
                       items: playerActions.map(
                             (String action) => DropdownMenuItem<String>(
                           value: action, child: Text(action),),
                       ).toList(),
                     ),
                   ],
                 ),
                const SizedBox(height: 8,),
                Text('Score: ${players[index].score}, Duration: $duration mins',
                  style: AppStyles.serverItemSubTitle,
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

  String _durationHelper(String dur) =>  dur.split('.')[0];

  Future<void> _displayTextInputDialog(BuildContext context, String cmd,
      String player) async {
    final TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reason for $cmd'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Reason (optional)'),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () async {
                final String finalCmd = 'sm_${cmd.toLowerCase()} '
                    '$player ${_textFieldController.text}';

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
