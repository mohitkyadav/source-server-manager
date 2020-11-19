import 'package:flutter/material.dart';

class AppTheme {
  AppTheme(this.themeSlug, this.themeName, this.themeData);

  String themeSlug;
  String themeName;
  ThemeData themeData;

  @override
  String toString() {
    return '$themeName - $themeSlug';
  }
}