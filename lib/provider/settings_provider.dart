import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Theme settings
  bool _darkMode = false;
  
  // Notification settings
  bool _enableNotifications = true;
  
  // Sound settings
  bool _soundEffects = true;
  
  // Font settings
  double _fontSize = 16.0;
  
  // Automatic savings setting
  bool _automaticSavings = false;
  
  // Language and locale settings
  String _languageCode = 'en';
  
  // Payment method settings
  String _selectedMobileMoneyProvider = 'MTN Mobile Money';
  String _selectedCurrency = 'UGX';
  
  // Biometric authentication settings
  bool _biometricEnabled = false;
  
  // Getters
  bool get darkMode => _darkMode;
  bool get enableNotifications => _enableNotifications;
  bool get notificationsEnabled => _enableNotifications; // Alias for backward compatibility
  bool get soundEffects => _soundEffects;
  bool get soundEnabled => _soundEffects; // Alias for backward compatibility
  double get fontSize => _fontSize;
  bool get automaticSavings => _automaticSavings;
  String get languageCode => _languageCode;
  String get selectedLanguage => getLanguageDisplayName(); // For backward compatibility
  Locale get locale => Locale(_languageCode);
  String get selectedMobileMoneyProvider => _selectedMobileMoneyProvider;
  String get selectedCurrency => _selectedCurrency;
  bool get biometricEnabled => _biometricEnabled;
  
  // Get display name for current language
  String getLanguageDisplayName() {
    return languageMap[_languageCode] ?? 'English';
  }
  
  // Map of language codes to display names
  static const Map<String, String> languageMap = {
    'en': 'English',
    'sw': 'Swahili',
    'lg': 'Luganda',
    'nyn': 'Runyankole',
    'ach': 'Acholi',
  };
  
  // Get all supported languages
  List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'sw', 'name': 'Swahili'},
    {'code': 'lg', 'name': 'Luganda'},
    {'code': 'nyn', 'name': 'Runyankole'},
    {'code': 'ach', 'name': 'Acholi'},
  ];
  
  SettingsProvider() {
    loadSettings();
  }
  
  // Load settings from shared preferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme settings
    _darkMode = prefs.getBool('darkMode') ?? false;
    
    // Load notification settings
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    
    // Load sound settings
    _soundEffects = prefs.getBool('soundEffects') ?? true;
    
    // Load font settings
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    
    // Load automatic savings settings
    _automaticSavings = prefs.getBool('automaticSavings') ?? false;
    
    // Load language settings
    _languageCode = prefs.getString('languageCode') ?? 'en';
    
    // Load payment method settings
    _selectedMobileMoneyProvider = prefs.getString('mobileMoneyProvider') ?? 'MTN Mobile Money';
    _selectedCurrency = prefs.getString('currency') ?? 'UGX';
    
    // Load biometric settings
    _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    
    notifyListeners();
  }
  
  // Save a single setting to shared preferences
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }
  
  // Toggle dark mode
  void toggleDarkMode(bool value) async {
    _darkMode = value;
    await _saveSetting('darkMode', value);
    notifyListeners();
  }
  
  // Set dark mode (keeping original method for backward compatibility)
  void setDarkMode(bool value) {
    toggleDarkMode(value);
  }
  
  // Toggle notifications
  void toggleNotifications(bool value) async {
    _enableNotifications = value;
    await _saveSetting('enableNotifications', value);
    notifyListeners();
  }
  
  // Set notifications (keeping original method for backward compatibility)
  void setNotificationsEnabled(bool value) {
    toggleNotifications(value);
  }
  
  // Toggle sound effects
  void toggleSoundEffects(bool value) async {
    _soundEffects = value;
    await _saveSetting('soundEffects', value);
    notifyListeners();
  }
  
  // Set sound (keeping original method for backward compatibility)
  void setSoundEnabled(bool value) {
    toggleSoundEffects(value);
  }
  
  // Set font size
  void setFontSize(double size) async {
    _fontSize = size;
    await _saveSetting('fontSize', size);
    notifyListeners();
  }
  
  // Set automatic savings
  void setAutomaticSavings(bool value) async {
    _automaticSavings = value;
    await _saveSetting('automaticSavings', value);
    notifyListeners();
  }
  
  // Set language
  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return; // No change needed
    
    _languageCode = code;
    await _saveSetting('languageCode', code);
    notifyListeners();
  }
  
  // Set selected language (keeping original method for backward compatibility)
  void setSelectedLanguage(String languageName) {
    // Convert language name to code
    for (var entry in languageMap.entries) {
      if (entry.value == languageName) {
        setLanguage(entry.key);
        break;
      }
    }
  }
  
  // Set selected mobile money provider
  void setSelectedMobileMoneyProvider(String provider) async {
    _selectedMobileMoneyProvider = provider;
    await _saveSetting('mobileMoneyProvider', provider);
    notifyListeners();
  }
  
  // Set selected currency
  void setSelectedCurrency(String currency) async {
    _selectedCurrency = currency;
    await _saveSetting('currency', currency);
    notifyListeners();
  }
  
  // Enable/disable biometric authentication
  void setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    await _saveSetting('biometricEnabled', value);
    notifyListeners();
  }
  
  // Get theme data based on dark mode setting
  ThemeData getTheme() {
    if (_darkMode) {
      return ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF8EB55D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8EB55D),
          secondary: Color(0xFF6A994E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF386641),
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: const Color(0xFF8EB55D),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8EB55D),
          secondary: Color(0xFF6A994E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8EB55D),
          foregroundColor: Colors.white,
        ),
      );
    }
  }

  void setLocale(Locale locale) {}
}