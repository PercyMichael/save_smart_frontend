import 'package:flutter/material.dart';
// ignore: unused_import
import 'login_screen.dart'; 
import 'validation_screen.dart'; // Import the validation screen for navigation

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back arrow button on the left side
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate to the previous screen (Login screen)
                  },
                  // ignore: sort_child_properties_last
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Smaller padding for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // Rounded corners for button
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: Image.asset(
                'assets/images/mpc_logo.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Logo not found',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "RESET PASSWORD",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "We'll send your password reset info to the email address linked to your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(199, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Email Field with Email Icon
            _buildTextField(
              label: 'User Email:',
              icon: Icons.email, // Replaced shield icon with email icon
              isPassword: false,
            ),
            const SizedBox(height: 16),

            // Password Field with Hide/Show Button
            _buildTextField(
              label: 'Password:',
              icon: Icons.lock, // Removed fingerprint icon
              isPassword: true,
            ),
            const SizedBox(height: 30),

            // Recover Password Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to ValidationScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ValidationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8EB55D),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Recover password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Text Field with Icons and Password Toggle
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 66, 73, 57), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 66, 73, 58)), // Green Icons
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                obscureText: isPassword ? !_isPasswordVisible : false,
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isPassword)
              IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}