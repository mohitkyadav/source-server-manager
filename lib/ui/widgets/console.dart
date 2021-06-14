import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class Console extends StatelessWidget {
  const Console(this.sendCommandToSv, this.commands);

  final Function sendCommandToSv;
  final List<Command> commands;

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
                  padding: const EdgeInsets.all(8),
                  itemCount: commands.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Command cmd = commands[index];

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
                        '', 'Command to server'
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
                      sendCommandToSv(_cmdInput.text);
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
                      sendCommandToSv(_cmdInput.text);
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
    const List<String> savedCmds = <String>[
      'status',
      'plugin_print',
      'say hello',
      'say bello',
      'say chello',
    ];

    return Container(
      height: 40,
      child: ListView.separated(
        itemCount: savedCmds.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InputChip(
            padding: const EdgeInsets.all(2.0),
            label: Text(savedCmds[index],
                style: const TextStyle(
                  color:AppStyles.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.78
                ),
            ),
            deleteIcon: const FaIcon(
              FontAwesomeIcons.solidTimesCircle,
              size: 18,
              color: AppStyles.red,
            ),
            backgroundColor: AppStyles.white20,
            onSelected: (bool selected) {
              print('selected');
            },
            onDeleted: () {
              print('deleted');
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 20,);
        },
      ),
    );
  }
}
