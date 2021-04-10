import 'dart:io';

import 'package:flutter/material.dart';

import 'package:source_server/source_server.dart';

import 'package:turrant/localization/app_localizations.dart';

class HomeForm extends StatefulWidget {

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // state
  String ip;
  String port;
  String password;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(child: Text(AppLocalizations.of(context)
                .getTranslatedValue('input_form'))),
            const SizedBox(height: 20,),
            TextFormField(
              validator: (String val)  => val.isEmpty ? AppLocalizations.of(context)
                  .getTranslatedValue('form_ip_field_err') : null,
              onSaved: (String val) => setState(() => ip = val),
              decoration: InputDecoration(
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
              onSaved: (String val) => setState(() => port = val),
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
                _connectToServer();
                if (_key.currentState.validate()) {
                  _key.currentState.save();
                  print('successfully validated form');
                  _connectToServer();
                }
              },
              height: 60,
              shape: const StadiumBorder(),
              color: Theme.of(context).accentColor,
              child: Text(AppLocalizations.of(context)
                  .getTranslatedValue('form_submit_btn_txt')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connectToServer () async {
    print(ip);
    print(port);
    print(password);

    const String ip2 = '13.235.82.124';
    const int port2 = 27815;
    const String password2 = 'mintu@512';

      final SourceServer server = SourceServer(InternetAddress(ip2), 27815);
      await server.connect();

      // var status = await server.getStatus();
      // print(await server.getStatus());
      // server.close();
  }
}
