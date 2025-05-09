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
  
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Error message variables
  String? _emailErrorText;
  String? _passwordErrorText;

  // Email validation regex
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation method
  bool _isPasswordValid(String password) {
    return password.length >= 8 && 
           password.contains(RegExp(r'[A-Z]')) && 
           password.contains(RegExp(r'[a-z]')) && 
           password.contains(RegExp(r'[0-9]')) && 
           password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  // Validate email
  void _validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        _emailErrorText = 'Please enter your email';
      } else if (!_emailRegExp.hasMatch(email)) {
        _emailErrorText = 'Please enter a valid email address';
      } else {
        _emailErrorText = null;
      }
    });
  }

  // Validate password
  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordErrorText = 'Please enter your new password';
      } else if (!_isPasswordValid(password)) {
        _passwordErrorText = 'Password must be at least 8 characters long and include uppercase, lowercase, number, and special character';
      } else {
        _passwordErrorText = null;
      }
    });
  }

  // Validate and submit form
  void _submitForm() {
    // Validate email and password
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    // Check if there are no errors
    if (_emailErrorText == null && _passwordErrorText == null) {
      // Navigate to ValidationScreen with email and password
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationScreen(
            originalPassword: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                controller: _emailController,
                label: 'User Email:',
                icon: Icons.email,
                isPassword: false,
                errorText: _emailErrorText,
                onChanged: _validateEmail,
              ),
              const SizedBox(height: 16),

              // Password Field with Hide/Show Button
              _buildTextField(
                controller: _passwordController,
                label: 'New Password:',
                icon: Icons.lock,
                isPassword: true,
                errorText: _passwordErrorText,
                onChanged: _validatePassword,
              ),
              const SizedBox(height: 30),

              // Recover Password Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
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
      ),
    );
  }

  // Custom Text Field with Icons and Password Toggle
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
    String? errorText,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: errorText != null 
                  ? Colors.red 
                  : const Color.fromARGB(255, 66, 73, 57), 
                width: 1.5
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon, 
                  color: errorText != null 
                    ? Colors.red 
                    : const Color.fromARGB(255, 66, 73, 58)
                ), // Green/Red Icons
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: isPassword ? !_isPasswordVisible : false,
                    decoration: InputDecoration(
                      hintText: label,
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                    onChanged: onChanged,
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
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}