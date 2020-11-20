import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:turrant/models/language.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of (BuildContext context) =>
    Localizations.of<AppLocalizations>(context, AppLocalizations);

  Map<String, String> _localizationValues;

  Future load() async {
    final jsonStringValues = await rootBundle
      .loadString('lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizationValues = mappedJson.map((key, value) => MapEntry(key, value));
  }

  String getTranslatedValue(String key) => _localizationValues[key];

  static const LocalizationsDelegate<AppLocalizations> delegate =
    _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => Language
    .supportedLanguages.any((lang) => lang.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localization = new AppLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
