import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/player.dart';
import 'package:turrant/themes/styling.dart';

class PlayersList extends StatelessWidget {
  const PlayersList(this.players, this.sendCommandToSv);

  final List<Player> players;
  final Function sendCommandToSv;

  @override
  Widget build(BuildContext context) {

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
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppStyles.charcoalGrey,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 2, color: AppStyles.blue.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(players[index].name, style: AppStyles.serverItemTitle,),
                const SizedBox(height: 8,),
                Text('Score: ${players[index].score}, Duration: $duration mins',
                  style: AppStyles.serverItemSubTitle,
                ),
              ],
            ),
          ),
        );
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            players[index].name,
            style: AppStyles.serverItemTitle,
          )
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
    );
  }

  String _durationHelper(String dur) {
    print(dur);
    print(dur.split('.'));
    return dur.split('.')[0];
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final TextEditingController _textFieldController = TextEditingController();

    // todo reason to kick
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reason for kick'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Text Field in Dialog'),
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
              onPressed: () {
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
