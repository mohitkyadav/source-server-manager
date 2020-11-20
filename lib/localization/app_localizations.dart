import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of (BuildContext context) =>
    Localizations.of<AppLocalizations>(context, AppLocalizations);

  Map<String, String> _localizationValues;
}