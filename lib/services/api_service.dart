import 'dart:convert';
// ignore: unused_import
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for your Laravel development server
  final String baseUrl = 'http://127.0.0.1:8001/api';

  // Auth token property
  String? _authToken;

  // Constructor that can load the token
  ApiService() {
    _loadToken();
  }

  // Load token from storage
  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('auth_token');
      // ignore: avoid_print
      print('Loaded auth token: ${_authToken != null ? 'Token exists' : 'No token found'}');
    } catch (e) {
      // ignore: avoid_print
      print('Error loading token: $e');
    }
  }

  // Save token to storage
  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      _authToken = token;
      // ignore: avoid_print
      print('Token saved successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error saving token: $e');
    }
  }

  // Clear token (for logout)
  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _authToken = null;
      // ignore: avoid_print
      print('Token cleared successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing token: $e');
    }
  }

  // Getter for the token
  String? get authToken => _authToken;

  // Helper to create headers with authentication
  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Consistent URL structure with the rest of the API
      final loginUrl = '$baseUrl/login';
      // ignore: avoid_print
      print('Attempting login to: $loginUrl');

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({'email': email, 'password': password}),
      );

      // ignore: avoid_print
      print('Login response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Login response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await _saveToken(data['token']);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
          'error': data['error'] ?? 'Unknown error',
        };
      }
    } catch (e) {
      // ignore: avoid_print
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Connection error',
        'error': e.toString(),
      };
    }
  }

  // Method to get dashboard data
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final url = '$baseUrl/v1/dashboard';
      // ignore: avoid_print
      print('Fetching dashboard data from: $url');

      final headers = _getHeaders();
      // ignore: avoid_print
      print('Request headers: $headers');

      final response = await http.get(Uri.parse(url), headers: headers);

      // ignore: avoid_print
      print('Dashboard response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Dashboard response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Token might be expired
        await clearToken();
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching dashboard data: $e');
      throw Exception('Error fetching dashboard data: $e');
    }
  }

  // Get active users
  Future<List<dynamic>> getActiveUsers() async {
    try {
      final url = '$baseUrl/v1/users/active';
      // ignore: avoid_print
      print('Fetching active users from: $url');
      
      final headers = _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      
      // ignore: avoid_print
      print('Active users response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Active users response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await clearToken();
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load active users: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching active users: $e');
      throw Exception('Error fetching active users: $e');
    }
  }

  // Get recent transactions
  Future<List<dynamic>> getRecentTransactions() async {
    try {
      final url = '$baseUrl/v1/transactions/recent';
      // ignore: avoid_print
      print('Fetching recent transactions from: $url');
      
      final headers = _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      
      // ignore: avoid_print
      print('Recent transactions response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Recent transactions response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await clearToken();
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load recent transactions: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching recent transactions: $e');
      throw Exception('Error fetching recent transactions: $e');
    }
  }

  // Create a saving goal
  Future<Map<String, dynamic>> createSavingGoal(String name, double targetAmount, String targetDate) async {
    try {
      final url = '$baseUrl/v1/savings/goals';
      // ignore: avoid_print
      print('Creating saving goal at: $url');
      
      final headers = _getHeaders();
      final body = json.encode({
        'name': name,
        'target_amount': targetAmount,
        'target_date': targetDate,
      });
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      // ignore: avoid_print
      print('Create saving goal response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Create saving goal response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create saving goal: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error creating saving goal: $e');
      throw Exception('Error creating saving goal: $e');
    }
  }

  // Get saving goals
  Future<List<dynamic>> getSavingGoals() async {
    try {
      final url = '$baseUrl/v1/savings/goals';
      // ignore: avoid_print
      print('Fetching saving goals from: $url');
      
      final headers = _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      
      // ignore: avoid_print
      print('Saving goals response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Saving goals response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load saving goals: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching saving goals: $e');
      throw Exception('Error fetching saving goals: $e');
    }
  }

  // Request withdrawal
  Future<Map<String, dynamic>> requestWithdrawal(double amount, String accountNumber) async {
    try {
      final url = '$baseUrl/v1/withdrawals/request';
      // ignore: avoid_print
      print('Requesting withdrawal at: $url');
      
      final headers = _getHeaders();
      final body = json.encode({
        'amount': amount,
        'account_number': accountNumber,
      });
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      
      // ignore: avoid_print
      print('Withdrawal request response status: ${response.statusCode}');
      // ignore: avoid_print
      print('Withdrawal request response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to request withdrawal: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error requesting withdrawal: $e');
      throw Exception('Error requesting withdrawal: $e');
    }
  }
}