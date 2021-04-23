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
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                color: AppStyles.black,
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
            color: AppStyles.blackShadowOp50,
            padding: const EdgeInsets.only(top: 5, right: 5, left: 10,
                bottom: 35),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _cmdInput,
                    decoration: const InputDecoration(
                      labelText: 'Command to server',
                      hintText: 'say hello',
                    ),
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
