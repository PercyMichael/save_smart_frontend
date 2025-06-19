import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:savesmart_app/provider/auth_provider.dart';
import 'package:savesmart_app/provider/settings_provider.dart';
import 'package:savesmart_app/screens/debug_connection_test.dart';
import 'package:savesmart_app/screens/home_screen.dart';
import 'package:savesmart_app/screens/login_screen.dart';
import 'package:savesmart_app/screens/onboarding_screen.dart';
import 'package:savesmart_app/screens/resetpassword_screen.dart';
import 'package:savesmart_app/screens/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'l10n/lg_material_localizations.dart';
import 'l10n/sw_material_localizations.dart';
import 'l10n/nyn_material_localizations.dart';
import 'l10n/ach_material_localizations.dart';
import 'models/language_provider.dart';
import 'l10n/custom_cupertino_localizations.dart';

import 'package:savesmart_app/provider/firebase_auth_provider.dart';
import 'package:savesmart_app/provider/firebase_firestore_provider.dart';
import 'package:savesmart_app/provider/firebase_storage_provider.dart';
import 'package:savesmart_app/provider/firebase_analytics_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Firebase providers
  final firebaseAuthProvider = FirebaseAuthProvider();
  await firebaseAuthProvider.initialize();
  
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseFirestoreProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseStorageProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseAnalyticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SaveSmart App',
          locale: settingsProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // Add custom localizations delegates for all supported languages
            LgMaterialLocalizations.delegate,
            SwMaterialLocalizations.delegate,
            NynMaterialLocalizations.delegate,
            AchMaterialLocalizations.delegate,
            CustomCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) {
              return const Locale('en');
            }
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('en');
          },
          theme: settingsProvider.darkMode
              ? ThemeData.dark().copyWith(
                  snackBarTheme: const SnackBarThemeData(
                    behavior: SnackBarBehavior.floating,
                  ),
                )
              : ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                  snackBarTheme: const SnackBarThemeData(
                    behavior: SnackBarBehavior.floating,
                  ),
                ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const AuthWrapper(child: HomeScreen()), // Fixed: Added const and removed extra parentheses
            '/resetpassword': (context) => const ResetPasswordScreen(),
            '/debug': (context) => const DebugConnectionTest(), // Fixed: Added const
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Page not found!')),
              ),
            );
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final Widget child;
  const AuthWrapper({super.key, required this.child});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _isAuthenticated;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = authProvider.isLoggedIn; // Use the getter instead of a method
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
    
    if (!isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return widget.child;
  }
}