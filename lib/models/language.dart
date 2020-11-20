class Language {
  Language(this.id, this.flag, this.name, this.languageCode);

  final int id;
  final String flag;
  final String name;
  final String languageCode;

  @override
  String toString () =>  name;

  static List<Language> supportedLanguages = [
    Language(0, '🇺🇸', 'English', 'en'),
    Language(1, '🇮🇳', 'हिंदी', 'hi'),
    Language(0, '🇸🇦', 'عربى', 'ar'),
  ];
}