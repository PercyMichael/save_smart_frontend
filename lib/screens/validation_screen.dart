import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure this import is correct

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

            // Password Field
            _buildPasswordField(),

            const SizedBox(height: 30),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Show an alert dialog after password reset confirmation
                    _showSuccessDialog();
                  },
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
    );
  }

  // Password Field with Eye Icon (without fingerprint icon)
  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 66, 71, 60), width: 1.5),
        ),
        child: Row(
          children: [
            // Removed fingerprint icon
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                obscureText: !_isPasswordVisible,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
