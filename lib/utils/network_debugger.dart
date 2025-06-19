import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class NetworkDebugger {
  static Future<void> debugConnection(String baseUrl) async {
    debugPrint('=== NETWORK DEBUG START ===');
    debugPrint('Platform: ${kIsWeb ? "WEB" : "MOBILE"}');
    debugPrint('Base URL: $baseUrl');
    debugPrint('User Agent: ${Platform.operatingSystem}');
    
    // Test 1: Simple GET to login endpoint
    await _testEndpoint('GET', '$baseUrl/login', null);
    
    // Test 2: Simple GET to a common endpoint
    await _testEndpoint('GET', '$baseUrl/health', null);
    await _testEndpoint('GET', '$baseUrl/api/health', null);
    
    // Test 3: Test with different headers
    await _testWithHeaders('$baseUrl/login');
    
    // Test 4: Test CORS preflight
    await _testPreflight('$baseUrl/login');
    
    debugPrint('=== NETWORK DEBUG END ===');
  }
  
  static Future<void> _testEndpoint(String method, String url, Map<String, dynamic>? body) async {
    try {
      debugPrint('\n--- Testing $method $url ---');
      
      http.Response response;
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-App/1.0',
      };
      
      if (method == 'GET') {
        response = await http.get(
          Uri.parse(url),
          headers: headers,
        ).timeout(Duration(seconds: 10));
      } else {
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        ).timeout(Duration(seconds: 10));
      }
      
      debugPrint('✅ Status: ${response.statusCode}');
      debugPrint('Headers: ${response.headers}');
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint('Body preview: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');
      
    } catch (e) {
      debugPrint('❌ Error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      
      if (e.toString().contains('XMLHttpRequest')) {
        debugPrint('🚨 CORS ERROR DETECTED!');
        debugPrint('Solution: Add CORS headers to your backend or use --disable-web-security flag');
      }
    }
  }
  
  static Future<void> _testWithHeaders(String url) async {
    debugPrint('\n--- Testing with various headers ---');
    
    final headerSets = [
      {'Content-Type': 'application/json'},
      {
        'Content-Type': 'application/json',
        'Access-Control-Request-Method': 'GET',
      },
      {
        'Content-Type': 'application/json',
        'Origin': kIsWeb ? 'http://localhost:3000' : 'mobile-app',
      }
    ];
    
    for (int i = 0; i < headerSets.length; i++) {
      try {
        debugPrint('Testing header set ${i + 1}: ${headerSets[i]}');
        final response = await http.get(
          Uri.parse(url),
          headers: headerSets[i],
        ).timeout(Duration(seconds: 5));
        debugPrint('✅ Header set ${i + 1} - Status: ${response.statusCode}');
      } catch (e) {
        debugPrint('❌ Header set ${i + 1} - Error: $e');
      }
    }
  }
  
  static Future<void> _testPreflight(String url) async {
    if (!kIsWeb) return;
    
    debugPrint('\n--- Testing CORS Preflight ---');
    try {
      final response = await http.Request('OPTIONS', Uri.parse(url))
          .send()
          .timeout(Duration(seconds: 5));
      
      debugPrint('Preflight status: ${response.statusCode}');
      final headers = await response.stream.transform(utf8.decoder).join();
      debugPrint('Preflight headers: $headers');
    } catch (e) {
      debugPrint('❌ Preflight failed: $e');
    }
  }
}

// Usage in your app:
// Add this to your main app initialization or a debug button:
/*
void debugNetwork() async {
  await NetworkDebugger.debugConnection('https://your-backend-url.com/api');
}
*/