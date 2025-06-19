// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // Added Provider import
import '../l10n/custom_cupertino_localizations.dart'; // Fixed path to the correct location

// Language provider to manage language state
class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  // Method to change the app's language
  void changeLanguage(String languageCode) {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }
}

// Language selection screen widget
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: ListView(
        children: [
          _buildLanguageItem(context, 'English', 'en', languageProvider),
          _buildLanguageItem(context, 'Swahili', 'sw', languageProvider),
          _buildLanguageItem(context, 'Luganda', 'lg', languageProvider),
          _buildLanguageItem(context, 'Nyankole', 'nyn', languageProvider),
          _buildLanguageItem(context, 'Acholi', 'ach', languageProvider),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, String name, String code, LanguageProvider provider) {
    final isSelected = provider.currentLocale.languageCode == code;
    
    return ListTile(
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        provider.changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}

// Localizations support widget
class LocalizationWrapper extends StatelessWidget {
  final Widget child;
  
  const LocalizationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Localizations(
          locale: languageProvider.currentLocale,
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            CustomCupertinoLocalizations.delegate,
          ],
          child: child,
        );
      },
    );
  }
}