// lib/services/unified_api_service.dart
// ignore: unused_import
import 'package:savesmart_app/config/api_config.dart';
// ignore: unused_import
import 'package:savesmart_app/services/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UnifiedApiService {
  // Define the base URL - replace with your actual API URL
  static const String baseUrl = 'http://127.0.0.1:8001/api'; // UPDATE THIS
  
  // Alternatively, if you have an API config file, use:
  // static String get baseUrl => ApiConfig.baseUrl;

  // Authentication Methods
  static Future<Map<String, dynamic>> login(String input, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': input, // or 'username' depending on your API
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Store the token if login is successful
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
          'isAdmin': data['user']?['is_admin'] ?? false,
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: await _getAuthHeaders(),
      );

      // Clear stored token regardless of response
      await _clearToken();

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {'success': true, 'message': 'Logged out locally'};
      }
    } catch (e) {
      // Clear token even if network fails
      await _clearToken();
      return {'success': true, 'message': 'Logged out locally'};
    }
  }

  // Dashboard Methods
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }

  static Future<dynamic> getRecentTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/recent'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load recent transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recent transactions: $e');
    }
  }

  // Method to get savings summary
  static Future<Map<String, dynamic>> getSavingsSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/savings/summary'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load savings summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching savings summary: $e');
    }
  }

  // Method to save a transaction
  static Future<Map<String, dynamic>> saveTransaction(Map<String, dynamic> transactionData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/save'),
        headers: await _getAuthHeaders(),
        body: json.encode(transactionData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving transaction: $e');
    }
  }

  // Method to create a saving goal
  static Future<Map<String, dynamic>> createSavingGoal(Map<String, dynamic> goalData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/savings/goals'),
        headers: await _getAuthHeaders(),
        body: json.encode(goalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create saving goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating saving goal: $e');
    }
  }

  // Method to get analytics overview
  static Future<Map<String, dynamic>> getAnalyticsOverview() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics/overview'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching analytics: $e');
    }
  }

  // Method to get categories
  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : data['data'] ?? [];
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Method to get notifications
  static Future<List<dynamic>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : data['data'] ?? [];
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  // Helper method to get authentication headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getStoredToken();
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper method to get stored token
  static Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  // Helper method to store token
  static Future<void> _storeToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  // Helper method to clear token
  static Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      // Handle error silently or log it
    }
  }
}