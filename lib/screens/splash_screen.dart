import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = prefs.getBool('onboardingCompleted') ?? false;

    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });

      if (hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Ensures that the splash screen navigates only after it's done loading
        onTap: () {
          if (!_isLoading) {
            Navigator.pushReplacementNamed(
              context,
              '/onboarding',
            );
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/home_image.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromRGBO(194, 189, 189, 0.3),
                    BlendMode.lighten,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mpc_logo.png',
                    height: 300,
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
