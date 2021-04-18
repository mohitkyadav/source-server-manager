import 'package:flutter/material.dart';

class Language {
  Language(this.id, this.flag, this.name, this.languageCode, this.countryCode);

  final int id;
  final String flag;
  final String name;
  final String languageCode;
  final String countryCode;

  @override
  String toString () =>  name;

  static List<Language> supportedLanguages = <Language>[
    Language(0, '🇺🇸', 'English', 'en', 'US'),
    Language(1, '🇮🇳', 'हिंदी', 'hi', 'IN'),
    Language(0, '🇸🇦', 'عربى', 'ar', 'SA'),
  ];

  static List<Locale> supportedLocales() => supportedLanguages
    .map((Language lang) => Locale(lang.languageCode, lang.countryCode)).toList();
}
