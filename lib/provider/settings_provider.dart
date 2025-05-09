// settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _automaticSavings = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'UGX';
  bool _darkMode = false;
  bool _soundEnabled = true;
  String _selectedMobileMoneyProvider = 'MTN Mobile Money';
  
  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get automaticSavings => _automaticSavings;
  String get selectedLanguage => _selectedLanguage;
  String get selectedCurrency => _selectedCurrency;
  bool get darkMode => _darkMode;
  bool get soundEnabled => _soundEnabled;
  String get selectedMobileMoneyProvider => _selectedMobileMoneyProvider;
  
  // Initialize settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _automaticSavings = prefs.getBool('automaticSavings') ?? true;
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    _selectedCurrency = prefs.getString('selectedCurrency') ?? 'UGX';
    _darkMode = prefs.getBool('darkMode') ?? false;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _selectedMobileMoneyProvider = prefs.getString('selectedMobileMoneyProvider') ?? 'MTN Mobile Money';
    
    notifyListeners();
  }
  
  // Setters with persistence
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }
  
  Future<void> setAutomaticSavings(bool value) async {
    _automaticSavings = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('automaticSavings', value);
    notifyListeners();
  }
  
  // Add similar methods for other settings
  Future<void> setSelectedLanguage(String value) async {
    _selectedLanguage = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
  _darkMode = value;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('darkMode', value);
  notifyListeners();
}

Future<void> setSoundEnabled(bool value) async {
  _soundEnabled = value;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('soundEnabled', value);
  notifyListeners();
}

Future<void> setSelectedMobileMoneyProvider(String value) async {
  _selectedMobileMoneyProvider = value;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('selectedMobileMoneyProvider', value);
  notifyListeners();
}
  
  // Continue with remaining setters...
}