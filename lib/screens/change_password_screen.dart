import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _usePIN = false;
  
  // Define theme color
  final Color themeColor = const Color(0xFF8EB55D);
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_usePIN ? "Change PIN" : "Change Password"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text("Use PIN instead of Password"),
                value: _usePIN,
                activeColor: themeColor,
                onChanged: (value) {
                  setState(() {
                    _usePIN = value;
                    // Clear fields when switching between password and PIN
                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: _usePIN ? "Current PIN" : "Current Password",
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeColor),
                  ),
                  // ignore: deprecated_member_use
                  labelStyle: TextStyle(color: themeColor.withOpacity(0.8)),
                  prefixIcon: Icon(Icons.lock, color: themeColor),
                  suffixIcon: _usePIN ? null : IconButton(
                    icon: Icon(_obscureCurrentPassword ? Icons.visibility : Icons.visibility_off, color: themeColor),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                obscureText: _usePIN ? true : _obscureCurrentPassword,
                keyboardType: _usePIN ? TextInputType.number : TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _usePIN 
                        ? 'Please enter your current PIN' 
                        : 'Please enter your current password';
                  }
                  if (_usePIN && value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: _usePIN ? "New PIN" : "New Password",
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeColor),
                  ),
                  // ignore: deprecated_member_use
                  labelStyle: TextStyle(color: themeColor.withOpacity(0.8)),
                  prefixIcon: Icon(Icons.lock_open, color: themeColor),
                  suffixIcon: _usePIN ? null : IconButton(
                    icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off, color: themeColor),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: _usePIN ? true : _obscureNewPassword,
                keyboardType: _usePIN ? TextInputType.number : TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _usePIN 
                        ? 'Please enter your new PIN' 
                        : 'Please enter your new password';
                  }
                  if (_usePIN && value.length != 4) {
                    return 'PIN must be 4 digits';
                  }
                  if (!_usePIN && value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: _usePIN ? "Confirm New PIN" : "Confirm New Password",
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeColor),
                  ),
                  // ignore: deprecated_member_use
                  labelStyle: TextStyle(color: themeColor.withOpacity(0.8)),
                  prefixIcon: Icon(Icons.lock_outline, color: themeColor),
                  suffixIcon: _usePIN ? null : IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: themeColor),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _usePIN ? true : _obscureConfirmPassword,
                keyboardType: _usePIN ? TextInputType.number : TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _usePIN 
                        ? 'Please confirm your new PIN' 
                        : 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return _usePIN 
                        ? 'PINs do not match' 
                        : 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (!_usePIN) ...[
                Text(
                  "Password Requirements:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: themeColor),
                ),
                const SizedBox(height: 8),
                const Text("• At least 8 characters"),
                const Text("• At least one uppercase letter"),
                const Text("• At least one number"),
                const Text("• At least one special character"),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process password/PIN change
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_usePIN 
                              ? 'PIN updated successfully' 
                              : 'Password updated successfully'
                          ),
                          backgroundColor: themeColor,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(_usePIN ? "Update PIN" : "Update Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}