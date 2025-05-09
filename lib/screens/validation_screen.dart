import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure this import is correct

class ValidationScreen extends StatefulWidget {
  // Add a constructor to receive the password
  final String originalPassword;

  const ValidationScreen({
    super.key, 
    required this.originalPassword
  });

  @override
  // ignore: library_private_types_in_public_api
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  bool _isPasswordVisible = false;
  
  // Controllers for password fields
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Error message for confirmation password
  String? _confirmPasswordErrorText;

  // Validate confirm password
  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordErrorText = 'Please confirm your password';
      } else if (confirmPassword != widget.originalPassword) {
        _confirmPasswordErrorText = 'Passwords do not match';
      } else {
        _confirmPasswordErrorText = null;
      }
    });
  }

  // Function to handle password confirmation
  void _confirmPasswordReset() {
    // Validate password confirmation
    _validateConfirmPassword(_confirmPasswordController.text);

    // Check if passwords match
    if (_confirmPasswordErrorText == null) {
      // Show success dialog if passwords match
      _showSuccessDialog();
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _confirmPasswordController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 30),

              // Confirm Password Field
              _buildConfirmPasswordField(),
              const SizedBox(height: 30),

              // Confirm Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmPasswordReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EB55D),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back to Login Button
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Center(
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8EB55D),
                      fontWeight: FontWeight.bold,
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

  // Confirm Password Field with Eye Icon and Validation
  Widget _buildConfirmPasswordField() {
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
                color: _confirmPasswordErrorText != null 
                  ? Colors.red 
                  : const Color.fromARGB(255, 66, 71, 60), 
                width: 1.5
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 66, 71, 60),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: const InputDecoration(
                      hintText: 'Confirm new password',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                    onChanged: _validateConfirmPassword,
                  ),
                ),
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
          if (_confirmPasswordErrorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                _confirmPasswordErrorText!,
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

  // Function to show a success alert dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Password reset successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate back to login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}