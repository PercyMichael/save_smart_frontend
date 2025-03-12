import 'package:flutter/material.dart';
import 'resetpassword_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final _accountNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _accountNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/mpc_logo.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Logo not found', style: TextStyle(color: Colors.red));
                },
              ),
              const SizedBox(height: 15),

              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildTextFieldWithIcon(
                        controller: _accountNumberController,
                        icon: Icons.person_outline,
                        hintText: "Account Number",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your account number';
                          }
                          if (value.length < 6) {
                            return 'Account number must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      _buildPasswordField(),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ResetPasswordScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: Color(0xFF8EB55D),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 148, 187, 101),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: const Color.fromARGB(255, 240, 235, 235),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'LOG IN',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      // Removed the "Don't have an account?" section
                    ],
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required IconData icon,
    required String hintText,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 66, 71, 60), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 66, 73, 57)),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 66, 71, 60), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: Color.fromARGB(255, 66, 73, 57)),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color.fromARGB(255, 66, 73, 57),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}