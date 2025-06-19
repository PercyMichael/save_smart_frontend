import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Add this import for SynchronousFuture

/// Model class to handle all text translations for the app
class AppTranslations {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'SaveSmart App',
      'hello': 'Hello',
      'welcome': 'Welcome to SaveSmart',
      'settings': 'Settings',
      'language': 'Language',
      'profile': 'Profile',
      'logout': 'Logout',
      'save': 'Save',
      'cancel': 'Cancel',
      // Add more English translations here
    },
    'sw': {
      'app_title': 'Programu ya SaveSmart',
      'hello': 'Jambo',
      'welcome': 'Karibu kwenye SaveSmart',
      'settings': 'Mipangilio',
      'language': 'Lugha',
      'profile': 'Wasifu',
      'logout': 'Toka',
      'save': 'Hifadhi',
      'cancel': 'Ghairi',
      // Add more Swahili translations here
    },
    'lg': {
      'app_title': 'App ya SaveSmart',
      'hello': 'Oli otya',
      'welcome': 'Tusanyukide ku SaveSmart',
      'settings': 'Entegeka',
      'language': 'Olulimi',
      'profile': 'Ebikukwatako',
      'logout': 'Fuluma',
      'save': 'Kuuma',
      'cancel': 'Sazamu',
      // Add more Luganda translations here
    },
    'nyn': {
      'app_title': 'SaveSmart App',
      'hello': 'Agandi',
      'welcome': 'Karibu SaveSmart',
      'settings': 'Enteekateka',
      'language': 'Orurimi',
      'profile': 'Ebirikukwata ahari iwe',
      'logout': 'Shohora',
      'save': 'Biike',
      'cancel': 'Kyerereza',
      // Add more Nyankole translations here
    },
    'ach': {
      'app_title': 'SaveSmart App',
      'hello': 'Itye',
      'welcome': 'Wajoli i SaveSmart',
      'settings': 'Ter',
      'language': 'Leb',
      'profile': 'Ngec mamegi',
      'logout': 'Kat woko',
      'save': 'Gwoki',
      'cancel': 'Juki',
      // Add more Acholi translations here
    },
  };

  final Locale locale;

  AppTranslations(this.locale);

  // A static method to create an instance using the device locale
  static AppTranslations of(BuildContext context) {
    return AppTranslations(Localizations.localeOf(context));
  }

  // Get a translated string
  String get(String key) {
    // If the language is not supported or the key doesn't exist, return the English version
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key; // Fallback to the key itself if nothing is found
  }
}

// Create a delegate for the AppTranslations class
class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Return true if the locale is supported
    return ['en', 'sw', 'lg', 'nyn', 'ach'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) {
    // Return a SynchronousFuture because this load method doesn't do any async work
    return SynchronousFuture<AppTranslations>(AppTranslations(locale));
  }

  @override
  bool shouldReload(AppTranslationsDelegate old) => false;
}

// Extension to make access to translations easier
extension TranslationsExtension on BuildContext {
  AppTranslations get tr => AppTranslations.of(this);
  
  // Access translations easily with context.t('key')
  String t(String key) => tr.get(key);
}