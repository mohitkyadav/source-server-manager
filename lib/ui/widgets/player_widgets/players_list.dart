import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turrant/utils/utils.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';
import 'package:turrant/ui/widgets/widgets.dart';

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
          child: InkWell(
            onTap: () {
             showModalBottomSheet<Widget>(
                 context: context,
                 isScrollControlled: true,
                 builder: (BuildContext context) =>
                     _buildPlayerOptions(context, players[index]));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 2,
                    color: _getBorderColor(context, index),)
              ),
              child: PlayerProfile(player: players[index], imgSize: 50,
                  bgColor: AppStyles.darkBg,
                  borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10,);
      },
    );
  }


  Color _getBorderColor (BuildContext context, int index) {
    final String userFlags = players[index].flag ?? '';
    final bool isRoot = userFlags.contains('root')
        || userFlags.contains('admin');
    final bool isVip = userFlags.contains('res');

    if (isRoot) {
      return AppStyles.yellow.withOpacity(0.5);
    }

    if (isVip) {
      return AppStyles.green50;
    }

    return AppStyles.blue2.withOpacity(0.5);
  }

  Widget _buildPlayerOptions(BuildContext context, Player player) {

    return Container(
      color: AppStyles.darkBg,
      height: 500,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 15),
        children: <Widget>[
          PlayerProfile(player: player,),
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
            leading: const FaIcon(FontAwesomeIcons.steamSymbol, size: 18,),
            title: const Text('Open Steam Profile',
                style: AppStyles.playerActionText),
            onTap: () async {
              final String url = 'https://steamcommunity.com/profiles'
                  '/${player.id}';
              await launch(url);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.copy, size: 18,),
            subtitle: Text(player.steamId,
              style: AppStyles.playerActionSubText,),
            title: const Text('Copy Steam Id',
                style: AppStyles.playerActionText),
            onTap: () async {
              showToast(context, 'Copied Steam_Id ${player.steamId}',
                  durationSec: 4);

              final ClipboardData data = ClipboardData(text: player.steamId);
              await Clipboard.setData(data);
              Navigator.pop(context);
            },
          ),
          if (player.flag != null)
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.flag, size: 18,),
              subtitle: Text(player.flag,
                style: AppStyles.playerActionSubText,),
              title: const Text('User flags',
                  style: AppStyles.playerActionText),
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
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          backgroundColor: AppStyles.darkBg,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Ban Player ${player.name}',
                    style: AppStyles.playerActionDialogTitle,),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _durationFieldController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.playerActionInputDec(
                        'Ban Duration', 'Duration in minutes (Default 10 min)'),
                  ),
                ),
                const SizedBox(height: 15,),
                _buildDurationPresets(context, _durationFieldController),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _textFieldController,
                    decoration: AppStyles.playerActionInputDec(
                        'Reason for Ban', 'Reason (optional)'),
                  ),
                ),
                const SizedBox(height: 40,),
                Container(
                  decoration: const BoxDecoration(
                    color: AppStyles.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20,
                      vertical: 10),
                  child: Row(
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
                        child: const Text('BAN', style: AppStyles.playerActionBtn),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty
                                .all(AppStyles.red),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )
                            )
                        ),
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
                  ),
                ),
              ],
            ),
          ),
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
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          backgroundColor: AppStyles.darkBg,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Mute Player ${player.name}',
                    style: AppStyles.playerActionDialogTitle,),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _durationFieldController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.playerActionInputDec(
                        'Mute Duration',
                        'Duration in minutes (Default 10 min)'),
                  ),
                ),
                const SizedBox(height: 15,),
                _buildDurationPresets(context, _durationFieldController),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _textFieldController,
                    decoration: AppStyles.playerActionInputDec(
                        'Reason for Muting', 'Reason (optional)'),
                  ),
                ),
                const SizedBox(height: 40,),
                Container(
                  decoration: const BoxDecoration(
                    color: AppStyles.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20,
                      vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text(
                          'CANCEL', style: AppStyles.playerActionBtn,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16,),
                      TextButton(
                        child: const Text(
                            'MUTE', style: AppStyles.playerActionBtn),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty
                                .all(AppStyles.red),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )
                            )
                        ),
                        onPressed: () async {
                          final String finalCmd = '$cmd '
                              '${player.name} ${_durationFieldController.text
                              .isNotEmpty
                              ? _durationFieldController.text : 10}'
                              ' ${_textFieldController.text}';
                          await sendCommandToSv(finalCmd);
                          Navigator.pop(context);
                          await refreshInfo();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationPresets (BuildContext context,
      TextEditingController durationFieldController) {
      return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              _buildDurationPreset(context, '+ 1 day',
                  durationFieldController, const Duration(days: 1)),
              const SizedBox(width: 10,),
              _buildDurationPreset(context, '+ 1 week',
                  durationFieldController, const Duration(days: 7)),
              const SizedBox(width: 10,),
              _buildDurationPreset(context, '+ 1 month',
                  durationFieldController, const Duration(days: 30)),
            ],
          )
      );
  }

  Widget _buildDurationPreset (BuildContext context, String dur,
      TextEditingController durationFieldController, Duration duration) {
    return TextButton(
      child: Text(dur),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty
              .all(AppStyles.purple),
          foregroundColor: MaterialStateProperty
              .all(AppStyles.white),
          shape: MaterialStateProperty
              .all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )
          )
      ),
      onPressed: () {
        final String currDur = durationFieldController.text;
        final bool isDurNum = Utils.isNumeric(currDur);

        if (!isDurNum) {
          durationFieldController.text = duration.inMinutes.toString();
        } else {
          durationFieldController.text = (int.parse(currDur) + duration
              .inMinutes).toString();
        }
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          backgroundColor: AppStyles.darkBg,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Kick Player ${player.name}',
                    style: AppStyles.playerActionDialogTitle,),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _textFieldController,
                    decoration: AppStyles.playerActionInputDec(
                      'Reason', 'Reason (optional)'),
                  ),
                ),
                const SizedBox(height: 40,),
                Container(
                  decoration: const BoxDecoration(
                    color: AppStyles.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20,
                      vertical: 10),
                  child: Row(
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty
                              .all(AppStyles.red),
                          shape: MaterialStateProperty
                              .all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                          )
                        ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
