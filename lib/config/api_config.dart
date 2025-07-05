// File: lib/config/api_config.dart
import 'package:flutter/foundation.dart';

class ApiConfig {
  // REPLACE THIS WITH YOUR ACTUAL BACKEND URL
  static const String _productionBaseUrl = 'https://your-backend-api.com/api';
  static const String _developmentBaseUrl =
      'https://m.realdeejays.com/api'; // Your local server

  // Automatically choose URL based on debug mode
  static String get baseUrl {
    if (kDebugMode) {
      return _developmentBaseUrl;
    }
    return _productionBaseUrl;
  }

  // Simplified web handling - no CORS proxy needed since you're disabling web security
  static String get webSafeBaseUrl {
    return baseUrl; // Direct connection since you're using --disable-web-security
  }

  // Use this method in your API calls
  static String getFullUrl(String endpoint) {
    // ignore: unnecessary_brace_in_string_interps
    final url = '${webSafeBaseUrl}$endpoint';
    if (kDebugMode) {
      print('🔍 API URL: $url'); // Debug print
    }
    return url;
  }

  // Timeouts
  static const int connectionTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 15000; // 15 seconds

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (kIsWeb) 'X-Requested-With': 'XMLHttpRequest',
      };

  static Map<String, String> getAuthHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

  // Debug method to test connection
  static void debugConfig() {
    // ignore: avoid_print
    print('🔧 API Config Debug:');
    // ignore: avoid_print
    print('  - Base URL: $baseUrl');
    // ignore: avoid_print
    print('  - Web Safe URL: $webSafeBaseUrl');
    // ignore: avoid_print
    print('  - Is Web: $kIsWeb');
    // ignore: avoid_print
    print('  - Is Debug: $kDebugMode');
    // ignore: avoid_print
    print('  - Test URL: ${getFullUrl('/user')}');
  }

  // API Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String transactionsRecent = '/transactions/recent';
  static const String transactionsStats = '/transactions/stats';
  static const String save = '/transactions/save';
  static const String withdraw = '/transactions/withdraw';
  static const String transfer = '/transactions/transfer';
  static const String savingGoals = '/saving-goals';
  static const String savingGoalsSummary = '/saving-goals/summary';
  static const String withdrawals = '/withdrawals';
  static const String withdrawalsRecent = '/withdrawals/recent';
  static const String withdrawalsRequest = '/withdrawals/request';
  static const String withdrawalsStats = '/withdrawals/stats';
  static const String categories = '/categories';
  static const String savings = '/savings';
  static const String savingsSummary = '/savings/summary';
  static const String savingsAnalytics = '/savings/analytics';
  static const String analyticsOverview = '/analytics/overview';
  static const String analyticsTransactions = '/analytics/transactions';
  static const String analyticsSavings = '/analytics/savings';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
}
