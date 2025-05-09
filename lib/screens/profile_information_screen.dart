import 'package:flutter/material.dart';
import 'package:savesmart_app/services/auth_service.dart';

class ProfileInformationScreen extends StatefulWidget {
  final VoidCallback? onProfileUpdate;
  
  // ignore: use_super_parameters
  const ProfileInformationScreen({
    Key? key, 
    this.onProfileUpdate
  }) : super(key: key);

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
      // Use class name to call static method
      final user = await AuthService.getCurrentUser();
      
      if (user != null) {
        setState(() {
          _nameController.text = user.displayName ?? "Rehema Malole";
          _emailController.text = user.email; // Remove ?? since email is required
          _phoneController.text = user.phoneNumber ?? "+256 704985597";
          _districtController.text = user.district ?? "Kampala";
        });
      } else {
        // Default values if no user is found
        setState(() {
          _nameController.text = "Rehema Malole";
          _emailController.text = "rehemamalole@gmail.com";
          _phoneController.text = "+256 704985597";
          _districtController.text = "Kampala";
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Show error message or fallback to default values
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
      // Use class name to call static method
      await AuthService.updateUserProfile(
        displayName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        district: _districtController.text,
      );
      
      // Notify the parent widget that profile was updated
      if (widget.onProfileUpdate != null) {
        widget.onProfileUpdate!();
      }
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      debugPrint('Error updating profile: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Define the theme color using the hex value FF8EB55D
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
                          // Implement image picker functionality
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