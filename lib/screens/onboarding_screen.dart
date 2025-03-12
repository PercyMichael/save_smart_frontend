import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Import your actual LoginScreen

// Onboarding content model
class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}

// List of onboarding contents with your updated image paths
final List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Track Your Savings',
    description: 'Set savings goals and track your progress with our intuitive dashboard.',
    image: 'assets/images/savings.jpeg', // Updated image path
  ),
  OnboardingContent(
    title: 'Smart Goals',
    description: 'Create personalized savings goals and get AI-powered recommendations.',
    image: 'assets/images/goals.jpg', // Updated image path
  ),
  OnboardingContent(
    title: 'Earn Interest',
    description: 'Watch your money grow with competitive interest rates on your savings.',
    image: 'assets/images/interest.jpg', // Updated image path
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()), // Navigate to the actual LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: completeOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      // Use Expanded to ensure the image is contained correctly
                      Expanded(
                        child: Image.asset(
                          contents[i].image,
                          fit: BoxFit.contain, // Ensure the image is scaled properly
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        contents[i].title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                    contents.length,
                    (index) => buildDot(index),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      currentIndex == contents.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        completeOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
