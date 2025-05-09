import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savesmart_app/config/api_config.dart';

class UserModel {
  final String? id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? district;
  final String? photoUrl;
  final bool isAdmin;
  final String? accountNumber;

  UserModel({
    this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.district,
    this.photoUrl,
    this.isAdmin = false,
    this.accountNumber,
  });

  // Convert a UserModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'district': district,
      'photoUrl': photoUrl,
      'isAdmin': isAdmin,
      'accountNumber': accountNumber,
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'] ?? json['name'],
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      district: json['district'],
      photoUrl: json['photoUrl'] ?? json['photo_url'],
      isAdmin: json['isAdmin'] ?? json['is_admin'] ?? false,
      accountNumber: json['accountNumber'] ?? json['account_number'],
    );
  }

  // Create a copy of the UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? district,
    String? photoUrl,
    bool? isAdmin,
    String? accountNumber,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      district: district ?? this.district,
      photoUrl: photoUrl ?? this.photoUrl,
      isAdmin: isAdmin ?? this.isAdmin,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }
}

class AuthService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Save token securely
  static Future<void> _saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      debugPrint('Error saving token: $e');
      throw Exception('Failed to store auth token: $e');
    }
  }

  // Get stored token
  static Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      debugPrint('Error retrieving token: $e');
      return null;
    }
  }

  // Save user data
  static Future<void> _saveUserData(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error saving user data: $e');
      throw Exception('Failed to store user data: $e');
    }
  }

  // Get the current user
  static Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (!isLoggedIn) {
        return null;
      }

      final userJson = prefs.getString(_userKey);
      if (userJson == null) {
        // Try to fetch from API if we have a token but no stored user data
        final token = await getToken();
        if (token != null) {
          final userInfo = await getUserInfo();
          if (userInfo['success']) {
            return UserModel.fromJson(userInfo['user']);
          }
        }
        return null;
      }

      return UserModel.fromJson(json.decode(userJson));
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Check if a user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      String? token = await getToken();
      return token != null;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }

  // Registration method
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.apiBaseUrl}/register"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If registration includes token, save it
        if (data.containsKey("access_token") || data.containsKey("token")) {
          String token = data["access_token"] ?? data["token"];
          await _saveToken(token);
          
          // Save user data
          if (data.containsKey("user")) {
            final user = UserModel.fromJson(data["user"]);
            await _saveUserData(user);
          } else {
            // Create basic user with provided email
            final user = UserModel(
              id: data["id"] ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
              email: email,
              displayName: name,
            );
            await _saveUserData(user);
          }
        }
        
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
          'errors': data['errors'] ?? {}
        };
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      return {
        'success': false,
        'message': 'Connection error during registration',
        'error': e.toString()
      };
    }
  }

  // Login method with support for email or account number
  static Future<Map<String, dynamic>> login({
    String? email,
    String? accountNumber,
    required String password,
    required String input,
  }) async {
    try {
      // Determine if using email or account number based on input
      final bool isEmail = input.contains('@');
      final Map<String, dynamic> loginData = isEmail
          ? {"email": input, "password": password}
          : {"account_number": input, "password": password};

      final response = await http.post(
        Uri.parse("${ApiConfig.apiBaseUrl}/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(loginData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check for token with different possible key names
        String? token;
        if (data.containsKey("access_token")) {
          token = data["access_token"];
        } else if (data.containsKey("token")) {
          token = data["token"];
        }

        if (token != null) {
          await _saveToken(token);
          
          // Save user data
          if (data.containsKey("user")) {
            final user = UserModel.fromJson(data["user"]);
            await _saveUserData(user);
          }

          return {
            'success': true,
            'token': token,
            'user': data['user'] ?? {},
            'isAdmin': data['user']?['is_admin'] ?? false
          };
        } else {
          return {
            'success': false,
            'message': 'No token received from the server'
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed. Please check your credentials.',
          'errors': data['errors'] ?? {}
        };
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      return {
        'success': false,
        'message': 'Connection error during login',
        'error': e.toString()
      };
    }
  }

  // Offline sign in for development/testing
  static Future<Map<String, dynamic>> offlineSignIn(String email, String password) async {
    try {
      // ignore: unused_local_variable
      final prefs = await SharedPreferences.getInstance();
      
      // Create a mock user
      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: 'Test User',
        phoneNumber: '+256 704985597',
        district: 'Kampala',
        accountNumber: 'TEST${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        isAdmin: email.toLowerCase().contains('admin'),
      );

      // Save mock token
      await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      
      // Save the user data
      await _saveUserData(user);

      return {
        'success': true, 
        'user': user.toJson(),
        'isAdmin': user.isAdmin
      };
    } catch (e) {
      debugPrint('Error in offline sign in: $e');
      throw Exception('Failed to sign in offline: $e');
    }
  }

  // Logout method
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        // Try to logout from server
        try {
          await http.post(
            Uri.parse("${ApiConfig.apiBaseUrl}/logout"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          );
        } catch (e) {
          debugPrint('Error logging out from server: $e');
          // Continue with local logout even if server logout fails
        }
      }

      // Clear stored tokens and login state
      await _secureStorage.delete(key: 'auth_token');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userKey);

      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      debugPrint('Error during logout: $e');
      return {
        'success': false,
        'message': 'Error during logout',
        'error': e.toString()
      };
    }
  }

  // Get current user information from API
  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
          'isAdmin': false
        };
      }

      final response = await http.get(
        Uri.parse("${ApiConfig.apiBaseUrl}/user"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        // Update locally stored user data
        final user = UserModel.fromJson(userData);
        await _saveUserData(user);
        
        return {
          'success': true,
          'user': userData,
          'isAdmin': userData['is_admin'] ?? false
        };
      } else if (response.statusCode == 401) {
        // Token is invalid or expired - perform local logout
        await logout();
        return {
          'success': false,
          'message': 'Authentication expired',
          'isAdmin': false
        };
      }

      return {
        'success': false,
        'message': 'Failed to get user info',
        'isAdmin': false
      };
    } catch (e) {
      debugPrint('Error retrieving user information: $e');
      return {
        'success': false,
        'message': 'Error retrieving user information',
        'error': e.toString(),
        'isAdmin': false
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? district,
    String? photoUrl,
  }) async {
    try {
      // First check if we have a token for server-side update
      String? token = await getToken();
      
      if (token != null) {
        // Try to update on server
        try {
          final response = await http.post(
            Uri.parse("${ApiConfig.apiBaseUrl}/update-profile"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              if (displayName != null) "name": displayName,
              if (email != null) "email": email,
              if (phoneNumber != null) "phone": phoneNumber,
              if (district != null) "district": district,
              if (photoUrl != null) "photo_url": photoUrl,
            }),
          );
          
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data.containsKey('user')) {
              final updatedUser = UserModel.fromJson(data['user']);
              await _saveUserData(updatedUser);
              return {
                'success': true,
                'user': updatedUser.toJson(),
                'message': 'Profile updated successfully'
              };
            }
          } else if (response.statusCode == 401) {
            await logout();
            return {
              'success': false,
              'message': 'Authentication expired',
            };
          }
        } catch (e) {
          debugPrint('Error updating profile on server: $e');
          // Fall back to local update if server update fails
        }
      }
      
      // Update locally if no token or server update failed
      final UserModel? currentUser = await getCurrentUser();
      if (currentUser == null) {
        return {
          'success': false,
          'message': 'No user is logged in'
        };
      }
      
      // Update the user data locally
      final updatedUser = currentUser.copyWith(
        displayName: displayName,
        email: email ?? currentUser.email,
        phoneNumber: phoneNumber,
        district: district,
        photoUrl: photoUrl,
      );

      // Save the updated user data
      await _saveUserData(updatedUser);
      
      return {
        'success': true,
        'user': updatedUser.toJson(),
        'message': 'Profile updated locally'
      };
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return {
        'success': false,
        'message': 'Failed to update profile: $e'
      };
    }
  }

  // Check if user is admin
  static Future<bool> isAdmin() async {
    try {
      // First try to get from cached user data
      final UserModel? user = await getCurrentUser();
      if (user != null) {
        return user.isAdmin;
      }
      
      // If no cached user, try getting from API
      final userInfo = await getUserInfo();
      return userInfo['isAdmin'] ?? false;
    } catch (e) {
      debugPrint('Error checking admin status: $e');
      return false;
    }
  }

  // Helper to get auth headers for other API calls
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
  
  // Initialize with default user for testing (optional)
  static Future<void> initializeWithDefaultUser() async {
    final isUserLoggedIn = await isLoggedIn();
    if (!isUserLoggedIn) {
      try {
        // Create a default user
        final user = UserModel(
          id: 'user_default',
          email: 'rehemamalole@gmail.com',
          displayName: 'Mukasa',
          phoneNumber: '+256 704985597',
          district: 'Kampala',
          accountNumber: 'DEFAULT001',
        );

        // Save mock token
        await _saveToken('default_token_${DateTime.now().millisecondsSinceEpoch}');
        
        // Save the user data
        await _saveUserData(user);
        
        // Mark as logged in
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
      } catch (e) {
        debugPrint('Error initializing default user: $e');
      }
    }
  }
}