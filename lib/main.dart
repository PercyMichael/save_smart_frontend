import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savesmart_app/provider/auth_provider.dart';
import 'package:savesmart_app/provider/settings_provider.dart';
import 'package:savesmart_app/screens/home_screen.dart';
import 'package:savesmart_app/screens/login_screen.dart';
import 'package:savesmart_app/screens/onboarding_screen.dart';
import 'package:savesmart_app/screens/resetpassword_screen.dart';
import 'package:savesmart_app/screens/splash_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of SettingsProvider and load settings
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: settingsProvider,
        ),
        // You can add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to access SettingsProvider for dynamic theme
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SaveSmart App',
          theme: settingsProvider.darkMode 
            ? ThemeData.dark() 
            : ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => AuthWrapper(child: HomeScreen()),
            '/resetpassword': (context) => const ResetPasswordScreen(),
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

class AuthWrapper extends StatelessWidget {
  final Widget child;
  
  // ignore: use_key_in_widget_constructors
  const AuthWrapper({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // If not authenticated, redirect to login
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return Container(); // Return empty container while redirecting
    }
    
    // User is authenticated, show the requested page
    return child;
  }
}
// Keep your existing MyHomePage and _MyHomePageState classes