import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:source_server/source_server.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/models/models.dart';
import 'package:turrant/themes/styling.dart';

class AddServerForm extends StatefulWidget {
  const AddServerForm(
      {Key key, @required this.refreshServers, this.sv}) : super(key: key);
  final Function refreshServers;
  final Server sv;

  @override
  _AddServerFormState createState() => _AddServerFormState();
}

class _AddServerFormState extends State<AddServerForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // state
  String ip;
  String name;
  int port;
  String password;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.sv != null) {
      name = widget.sv.serverName;
      ip = widget.sv.serverIp;
      port = int.parse(widget.sv.serverPort);
      password = widget.sv.serverRcon;
      isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10,),
              TextFormField(
                onSaved: (String val) => setState(() => name = val),
                initialValue: name,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_name_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_name_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_ip_field_err') : null,
                onSaved: (String val) => setState(() => ip = val),
                initialValue: ip,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_ip_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_ip_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_port_field_err') : null,
                onSaved: (String val) => setState(() => port = int.parse(val)),
                initialValue: port != null ? port.toString() : '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_port_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_port_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_pass_field_err') : null,
                onSaved: (String val) => setState(() => password = val),
                initialValue: password,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_pass_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_pass_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              MaterialButton(
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                    _connectToServer();
                  }
                },
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: AppStyles.blue2,
                child: Text(AppLocalizations.of(context)
                    .getTranslatedValue('form_submit_btn_txt')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectToServer() async {
    final SourceServer server = SourceServer(InternetAddress(ip), port, password);
    await server.connect();

    final Map<String, dynamic> serverInfo = await server.getInfo();

    final Server localServer = Server((name != null
        && name.trim().length > 1) ? name : serverInfo['name'].toString(),
        ip, port.toString(), password, serverInfo['game'].toString());

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      final List<String> currentAddedServers = prefs
          .getStringList('addedServers') ?? <String>[];

      final String jsonLocalServer = jsonEncode(localServer.toJson());

      if (isEditing) {
        final int indexOfCurrentSv = currentAddedServers
            .indexOf(jsonEncode(widget.sv.toJson()));
        currentAddedServers.replaceRange(
            indexOfCurrentSv, indexOfCurrentSv + 1, <String>[jsonLocalServer]);
        currentAddedServers.join(', ');

        prefs.setStringList('addedServers', currentAddedServers);
      } else {
        prefs.setStringList('addedServers', <String>[...currentAddedServers,
          jsonLocalServer]);
      }

      widget.refreshServers();
      Navigator.of(context).pop();
    });
    server.close();
  }
}
