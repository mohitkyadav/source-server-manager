import 'package:flutter/material.dart';
import 'package:turrant/localization/app_localizations.dart';

class HomeForm extends StatefulWidget {

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
                  .getTranslatedValue('form_name_field_err') : null,
              decoration: InputDecoration(
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
                  .getTranslatedValue('form_dob_field_err') : null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)
                    .getTranslatedValue('form_dob_field_txt'),
                hintText: AppLocalizations.of(context)
                    .getTranslatedValue('form_dob_field_txt'),
              ),
            ),
            const SizedBox(height: 20,),
            MaterialButton(
              onPressed: () {
                if (_key.currentState.validate()) {
                  print('successfully validated form');
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
}
