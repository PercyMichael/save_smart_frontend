// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:savesmart_app/services/auth_service.dart';
import 'package:savesmart_app/services/unified_api_service.dart';


class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  Map<String, dynamic>? _userData;
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  Map<String, dynamic>? get userData => _userData;
  
  AuthProvider() {
    // Check authentication status on startup
    checkAuthStatus();
  }
  
  Future<void> checkAuthStatus() async {
    _isAuthenticated = await AuthService.isLoggedIn();
    if (_isAuthenticated) {
      final userInfo = await AuthService.getUserInfo();
      _isAdmin = userInfo['isAdmin'] ?? false;
      _userData = userInfo['user'];
    }
    notifyListeners();
  }
  
  Future<bool> login(String input, String password) async {
    final result = await UnifiedApiService.login(input, password);
    if (result['success']) {
      _isAuthenticated = true;
      _isAdmin = result['isAdmin'] ?? false;
      _userData = result['user'];
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<void> logout() async {
    await UnifiedApiService.logout();
    _isAuthenticated = false;
    _isAdmin = false;
    _userData = null;
    notifyListeners();
  }
}