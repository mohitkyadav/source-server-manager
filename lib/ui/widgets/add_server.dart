import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isLoading = false;
  int connectionAttempt = 0;

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
          padding: EdgeInsets.only(
            top: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
          ),
          // color: ,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10,),
              TextFormField(
                enabled: !isLoading,
                onSaved: (String val) => setState(() => name = val),
                initialValue: name,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_name_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_name_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                enabled: !isLoading,
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_ip_field_err') : null,
                onSaved: (String val) => setState(() => ip = val),
                initialValue: ip,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_ip_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_ip_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                enabled: !isLoading,
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_port_field_err') : null,
                onSaved: (String val) => setState(() => port = int.parse(val)),
                initialValue: port != null ? port.toString() : '',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_port_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_port_field_txt'),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                enabled: !isLoading,
                validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                    .getTranslatedValue('form_pass_field_err') : null,
                onSaved: (String val) => setState(() => password = val),
                initialValue: password,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context)
                      .getTranslatedValue('form_pass_field_txt'),
                  hintText: AppLocalizations.of(context)
                      .getTranslatedValue('form_pass_field_txt'),
                ),
              ),
              const SizedBox(height: 15,),
              MaterialButton(
                onPressed: isLoading ? null : () {
                  if (_key.currentState.validate() && !isLoading) {
                    setState(() {
                      connectionAttempt = 0;
                      isLoading = true;
                    });

                    _key.currentState.save();
                    _connectToServer();
                  }
                },
                height: 35,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: AppStyles.blue2,
                child: Text(isLoading ? 'Connection attempt $connectionAttempt'
                    : 'Save'),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }

  Future<SourceServer> _createSourceServer () async{
    setState(() {
      connectionAttempt += 1;
    });

    print(connectionAttempt);
    if (connectionAttempt >= 4) {
      return null;
    }

    return await SourceServer.connect(
        ip, port, password: password
    );
  }

  Future<void> _connectToServer() async {
    try {
      final SourceServer server = await _createSourceServer()
          .timeout(const Duration(seconds: 2));

      if (server == null) {
        setState(() {
          connectionAttempt = 0;
          isLoading = false;
        });

        showDialog<Widget>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Error', style: AppStyles
                .chipActionText.copyWith(fontSize: 18)),
            content: const Text('Could not connect to the server.'
                'Please check ip, port and password.',
                style: AppStyles.chipActionText),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Ok', style: AppStyles.chipActionText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );

        return;
      }

      final ServerInfo info = await server.getInfo();
      server.close();

      final Server localServer = Server((name != null
          && name.trim().length > 1) ? name : info.name,
          ip, port.toString(), password, info.game);

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
        setState(() {
          connectionAttempt = 0;
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
      _connectToServer();
    }
  }
}
