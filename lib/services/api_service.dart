import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For debugPrint
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Test connection method
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      debugPrint('Connection test status: ${response.statusCode}');
      return response.statusCode == 405 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  // Add this method to test from Flutter
  Future<void> testFlutterConnection() async {
    // ignore: avoid_print
    print('🚀 Testing Flutter -> Laravel connection...');
    
    try {
      // Test the working endpoint
      final url = ApiConfig.getFullUrl('/test-connection');
      // ignore: avoid_print
      print('📡 Calling: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.defaultHeaders,
      );
      
      // ignore: avoid_print
      print('✅ Response:');
      // ignore: avoid_print
      print('  Status: ${response.statusCode}');
      // ignore: avoid_print
      print('  Body: ${response.body}');
      
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print('🎉 CONNECTION SUCCESS!');
      }
    } catch (e) {
      // ignore: avoid_print
      print('❌ Connection failed: $e');
    }

    // Also test user endpoint
    try {
      final userUrl = ApiConfig.getFullUrl('/user-test');
      // ignore: avoid_print
      print('📡 Testing user endpoint: $userUrl');
      
      final userResponse = await http.get(
        Uri.parse(userUrl),
        headers: ApiConfig.defaultHeaders,
      );
      
      // ignore: avoid_print
      print('✅ User endpoint response:');
      // ignore: avoid_print
      print('  Status: ${userResponse.statusCode}');
      // ignore: avoid_print
      print('  Body: ${userResponse.body}');
      
      if (userResponse.statusCode == 200) {
        // ignore: avoid_print
        print('🎉 USER ENDPOINT SUCCESS!');
      }
    } catch (e) {
      // ignore: avoid_print
      print('❌ User endpoint failed: $e');
    }
  }

  // Generic GET request - UPDATED VERSION
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final headers = token != null
          ? ApiConfig.getAuthHeaders(token)
          : ApiConfig.defaultHeaders;
      // Use the new getFullUrl method
      final url = ApiConfig.getFullUrl(endpoint);
      debugPrint('Making GET request to: $url');
      debugPrint('Headers: $headers');
      // ignore: unnecessary_brace_in_string_interps
      debugPrint('Is Web: ${kIsWeb}');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(
        Duration(milliseconds: ApiConfig.receiveTimeout),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('GET request error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      
      // Better error logging for web
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        debugPrint('🚨 CORS ERROR: Add CORS headers to backend or use --disable-web-security');
      }
      
      throw _handleError(e);
    }
  }

  // Generic POST request - UPDATED VERSION
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
    {String? token}
  ) async {
    try {
      final headers = token != null
          ? ApiConfig.getAuthHeaders(token)
          : ApiConfig.defaultHeaders;
      // Use the new getFullUrl method
      final url = ApiConfig.getFullUrl(endpoint);
      debugPrint('Making POST request to: $url');
      debugPrint('Headers: $headers');
      debugPrint('Data: $data');
      // ignore: unnecessary_brace_in_string_interps
      debugPrint('Is Web: ${kIsWeb}');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(
        Duration(milliseconds: ApiConfig.receiveTimeout),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      debugPrint('POST request error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      
      // Better error logging for web
      if (kIsWeb && e.toString().contains('XMLHttpRequest')) {
        debugPrint('🚨 CORS ERROR: Add CORS headers to backend or use --disable-web-security');
      }
      
      throw _handleError(e);
    }
  }

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    return await post(ApiConfig.login, data);
  }

  // Register method
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await post(ApiConfig.register, userData);
  }

  // Logout method
  Future<Map<String, dynamic>> logout(String token) async {
    return await post(ApiConfig.logout, {}, token: token);
  }

  // Get user profile
  Future<Map<String, dynamic>> getUser(String token) async {
    return await get(ApiConfig.user, token: token);
  }

  // Get dashboard data
  Future<Map<String, dynamic>> getDashboard(String token) async {
    return await get(ApiConfig.dashboard, token: token);
  }

  // Transaction methods
  Future<Map<String, dynamic>> getRecentTransactions(String token) async {
    return await get(ApiConfig.transactionsRecent, token: token);
  }

  Future<Map<String, dynamic>> getAllTransactions(String token) async {
    return await get(ApiConfig.transactions, token: token);
  }

  Future<Map<String, dynamic>> getTransactionStats(String token) async {
    return await get(ApiConfig.transactionsStats, token: token);
  }

  Future<Map<String, dynamic>> saveTransaction(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.save, data, token: token);
  }

  Future<Map<String, dynamic>> withdrawTransaction(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.withdraw, data, token: token);
  }

  Future<Map<String, dynamic>> transferTransaction(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.transfer, data, token: token);
  }

  // Saving goals methods
  Future<Map<String, dynamic>> getSavingGoals(String token) async {
    return await get(ApiConfig.savingGoals, token: token);
  }

  Future<Map<String, dynamic>> createSavingGoal(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.savingGoals, data, token: token);
  }

  Future<Map<String, dynamic>> getSavingGoalsSummary(String token) async {
    return await get(ApiConfig.savingGoalsSummary, token: token);
  }

  // Withdrawals methods
  Future<Map<String, dynamic>> getWithdrawals(String token) async {
    return await get(ApiConfig.withdrawals, token: token);
  }

  Future<Map<String, dynamic>> getRecentWithdrawals(String token) async {
    return await get(ApiConfig.withdrawalsRecent, token: token);
  }

  Future<Map<String, dynamic>> requestWithdrawal(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.withdrawalsRequest, data, token: token);
  }

  Future<Map<String, dynamic>> getWithdrawalStats(String token) async {
    return await get(ApiConfig.withdrawalsStats, token: token);
  }

  // Categories methods
  Future<Map<String, dynamic>> getCategories(String token) async {
    return await get(ApiConfig.categories, token: token);
  }

  Future<Map<String, dynamic>> createCategory(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.categories, data, token: token);
  }

  // Savings methods
  Future<Map<String, dynamic>> getSavings(String token) async {
    return await get(ApiConfig.savings, token: token);
  }

  Future<Map<String, dynamic>> createSaving(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.savings, data, token: token);
  }

  Future<Map<String, dynamic>> getSavingsSummary(String token) async {
    return await get(ApiConfig.savingsSummary, token: token);
  }

  Future<Map<String, dynamic>> getSavingsAnalytics(String token) async {
    return await get(ApiConfig.savingsAnalytics, token: token);
  }

  // Analytics methods
  Future<Map<String, dynamic>> getAnalyticsOverview(String token) async {
    return await get(ApiConfig.analyticsOverview, token: token);
  }

  Future<Map<String, dynamic>> getTransactionsAnalytics(String token) async {
    return await get(ApiConfig.analyticsTransactions, token: token);
  }

  Future<Map<String, dynamic>> getSavingsAnalyticsData(String token) async {
    return await get(ApiConfig.analyticsSavings, token: token);
  }

  // Settings methods
  Future<Map<String, dynamic>> getSettings(String token) async {
    return await get(ApiConfig.settings, token: token);
  }

  Future<Map<String, dynamic>> updateSettings(String token, Map<String, dynamic> data) async {
    return await post(ApiConfig.settings, data, token: token);
  }

  // Notifications methods
  Future<Map<String, dynamic>> getNotifications(String token) async {
    return await get(ApiConfig.notifications, token: token);
  }

  Future<Map<String, dynamic>> markNotificationAsRead(String token, Map<String, dynamic> data) async {
    return await post('${ApiConfig.notifications}/mark-read', data, token: token);
  }

  // Public methods (no token required)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await post(ApiConfig.forgotPassword, {'email': email});
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    return await post(ApiConfig.resetPassword, data);
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      throw ApiException(
        message: responseData['message'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
        data: responseData,
      );
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return ApiException(
        message: 'No internet connection or server unreachable',
        statusCode: 0,
      );
    } else if (error is HttpException) {
      return ApiException(
        message: 'HTTP error occurred',
        statusCode: 0,
      );
    } else if (error is FormatException) {
      return ApiException(
        message: 'Invalid response format',
        statusCode: 0,
      );
    } else {
      return ApiException(
        message: error.toString(),
        statusCode: 0,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}