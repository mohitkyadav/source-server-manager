import 'package:flutter/material.dart';

import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class Console extends StatelessWidget {
  const Console(this.sendCommandToSv, this.commands);

  final Function sendCommandToSv;
  final List<Command> commands;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _cmdInput = TextEditingController();

    return Container(
      color: AppStyles.black,
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
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
          Container(
            decoration: const BoxDecoration(
              color: AppStyles.blackShadowOp50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )
            ),
            padding: const EdgeInsets.only(top: 20, right: 5, left: 10,
                bottom: 35),
            child: Row(
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
                IconButton(
                    icon: const Icon(Icons.send),
                    tooltip: 'Send',
                    onPressed: () {
                      sendCommandToSv(_cmdInput.text);
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
