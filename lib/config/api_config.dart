// lib/config/api_config.dart
class ApiConfig {
  // Change this according to environment (dev, test, prod)
  static const String baseUrl = 'http://192.168.1.X:8001/api'; // Replace with your actual IP
  
  // For emulators:
  // Android emulator: 10.0.2.2
  // iOS simulator: 127.0.0.1
  
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  
  // API endpoints
  static const String login = '/login';
  static const String logout = '/logout';
  static const String dashboard = '/v1/dashboard';

  // ignore: prefer_typing_uninitialized_variables
  static var apiBaseUrl;
  // Add other endpoints here
}