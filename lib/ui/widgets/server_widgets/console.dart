import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class Console extends StatefulWidget {
  const Console(this.sendCommandToSv, this.commands);

  final Function sendCommandToSv;
  final List<Command> commands;

  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  List<String> savedCommands = <String>[];
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _checkSavedCmds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppStyles.black,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  controller: _controller,
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.commands.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Command cmd = widget.commands[index];

                    return Text('${!cmd.isResponse ? '> ' : ''}${cmd.cmdText}',
                      style: cmd.isResponse
                          ? AppStyles.consoleRes : AppStyles.consoleReq,);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 5,);
                  },
                ),
              )
          ),
          _buildInputSection(context),
        ],
      ),
    );
  }

  Widget _buildInputSection (BuildContext context) {
    final TextEditingController _cmdInput = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
          color: AppStyles.blackShadowOp50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
      ),
      padding: const EdgeInsets.only(top: 20, right: 5, left: 10,
          bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _cmdInput,
                  decoration: AppStyles.playerActionInputDec(
                      'use "clear" to clean history ', 'Command to server'
                  )
                ),
              ),
              const SizedBox(width: 15,),
              ClipOval(
                child: Material(
                  color: AppStyles.white20,
                  child: InkWell(
                    splashColor: AppStyles.blue2,
                    onTap: () {
                      _addCommand(context, _cmdInput.text);
                    },
                    child: const SizedBox(
                        width: 40, height: 40, child: Icon(Icons.add)),
                  ),
                ),
              ),
              const SizedBox(width: 15,),
              ClipOval(
                child: Material(
                  color: AppStyles.white20,
                  child: InkWell(
                    splashColor: AppStyles.blue2,
                    onTap: () {
                      widget.sendCommandToSv(_cmdInput.text,
                          callback:_scrollToBottom);
                    },
                    child: const SizedBox(
                        width: 40, height: 40, child: Icon(Icons.send)),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10,),
          _buildSavedChips(context),
        ],
      ),
    );
  }

  Widget _buildSavedChips (BuildContext context) {

    if (savedCommands.isEmpty) {
      return Container(
        height: 30,
        alignment: Alignment.centerLeft,
        child: const Text(
          'Type a command and tap on the + icon to save it.',
          style: AppStyles.consoleInfoText,
        ),
      );
    }

    return Container(
      height: 40,
      child: ListView.separated(
        itemCount: savedCommands.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InputChip(
            padding: const EdgeInsets.all(2.0),
            label: Text(savedCommands[index],
                style: const TextStyle(
                  color:AppStyles.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.78
                ),
            ),
            deleteIcon: const FaIcon(
              Icons.pending,
              size: 18,
              color: AppStyles.yellow,
            ),
            backgroundColor: AppStyles.white20,
            onSelected: (bool selected) async {
              widget.sendCommandToSv(savedCommands[index],
                  callback:_scrollToBottom);
            },
            onDeleted: () {
              _displayChipActionDialog(context, savedCommands[index]);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 20,);
        },
      ),
    );
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 500), () =>
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),));
  }

  void _checkSavedCmds () {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final String currentCmds = prefs.getString('savedCmds');
      final List<String> splitCmds = currentCmds != null && currentCmds
          .isNotEmpty ? currentCmds.split(';') : <String>[];

      setState(() {
        savedCommands = splitCmds;
      });
    });
  }

  void _setSavedCmds (BuildContext context, List<String> cmds) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString('savedCmds', cmds.join(';'));

      setState(() {
        savedCommands = cmds;
      });
    });
  }

  void _addCommand (BuildContext context, String cmd) {
    final List<String> newCommands = <String>[...savedCommands, cmd];
    _setSavedCmds(context, newCommands);
  }

  Future<void> _displayChipActionDialog(BuildContext context, String cmdToRemoved) async {
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
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Change Saved Command',
                    style: AppStyles.playerActionDialogTitle,),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _textFieldController..text = cmdToRemoved,
                    decoration: AppStyles.playerActionInputDec(
                        'New Command', 'New Command'),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        child: Text('DELETE', style: AppStyles
                            .playerActionBtn.copyWith(color: AppStyles.red)),
                        style: ButtonStyle(
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )
                            )
                        ),
                        onPressed: () async {
                          final List<String> newCommands = savedCommands
                              .where((String cmd) => cmdToRemoved != cmd).toList();
                          _setSavedCmds(context, newCommands);
                          Navigator.of(context).pop();
                        },
                      ),
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
                            child: Text('UPDATE', style: AppStyles
                                .playerActionBtn.copyWith(color: AppStyles.blue2)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty
                                    .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )
                                )
                            ),
                            onPressed: () async {
                              final List<String> newCommands = savedCommands
                                  .map((String cmd) => cmd == cmdToRemoved
                                  ? _textFieldController.text : cmd).toList();
                              _setSavedCmds(context, newCommands);
                              Navigator.pop(context);
                            },
                          ),
                        ],
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
