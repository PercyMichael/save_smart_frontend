import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savesmart_app/provider/auth_provider.dart';

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileInformationScreenState createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _districtController;
  
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _districtController = TextEditingController();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = await authProvider.getCurrentUser();
      debugPrint('Loaded user data: ${user?.toJson()}');
      
      if (user != null) {
        setState(() {
          _nameController.text = user.displayName ?? "Rehema Malole";
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? "+256 704985597";
          _districtController.text = user.district ?? "Kampala";
        });
      } else {
        debugPrint('No user found, using defaults');
        setState(() {
          _nameController.text = "Rehema Malole";
          _emailController.text = "rehemamalole@gmail.com";
          _phoneController.text = "+256 704985597";
          _districtController.text = "Kampala";
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updateData = {
        'displayName': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'district': _districtController.text,
      };
      debugPrint('Saving user data: $updateData');
      
      final result = await authProvider.updateProfile(
        displayName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        district: _districtController.text,
      );
      debugPrint('Update result: $result');
      
      // Pop back with true to trigger reload and SnackBar on HomeScreen
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error updating profile: $e');
      // Show error SnackBar in ProfileInformationScreen
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  final Color themeColor = const Color(0xFF8EB55D);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Information"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: themeColor))
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        label: const Text("Change Profile Picture"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Image picker would open here')),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: "District",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: _saveUserData,
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}