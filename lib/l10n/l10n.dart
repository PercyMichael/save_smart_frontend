import 'package:flutter/material.dart';

class L10n {
  static final supportedLocales = [
    const Locale('en'), // English
    const Locale('sw'), // Swahili
    const Locale('lg'), // Luganda
    const Locale('nyn'), // Nyankole
    const Locale('ach'), // Acholi
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'sw':
        return 'Kiswahili';
      case 'lg':
        return 'Luganda';
      case 'nyn':
        return 'Runyankole';
      case 'ach':
        return 'Acholi';
      default:
        return code;
    }
  }
}