// lib/services/unified_api_service.dart
import 'package:savesmart_app/config/api_config.dart';
import 'package:savesmart_app/services/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnifiedApiService {
  // Authentication methods
  static Future<Map<String, dynamic>> login(String input, String password) async {
    return await AuthService.login(input: input, password: password, email: '');
  }
  
  static Future<Map<String, dynamic>> logout() async {
    return await AuthService.logout();
  }
  
  // Generic GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final url = ApiConfig.baseUrl + endpoint;
      
      // ignore: avoid_print
      print('GET request to: $url');
      final response = await http.get(Uri.parse(url), headers: headers);
      
      // ignore: avoid_print
      print('Response status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      // ignore: avoid_print
      print('GET request error: $e');
      throw Exception('Failed to perform GET request: $e');
    }
  }
  
  // Generic POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await AuthService.getAuthHeaders();
      final url = ApiConfig.baseUrl + endpoint;
      
      // ignore: avoid_print
      print('POST request to: $url');
      // ignore: avoid_print
      print('Request data: $data');
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      
      // ignore: avoid_print
      print('Response status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      // ignore: avoid_print
      print('POST request error: $e');
      throw Exception('Failed to perform POST request: $e');
    }
  }
  
  // Helper to handle responses
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Handle unauthorized - clear token and redirect to login
      AuthService.logout();
      throw Exception('Authentication expired. Please login again.');
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
  
  // Specific business methods
  static Future<Map<String, dynamic>> getDashboardData() async {
    return await get(ApiConfig.dashboard);
  }
  
  static Future<List<dynamic>> getRecentTransactions() async {
    return await get('/v1/transactions/recent');
  }
  
  // Add more specific methods here
}