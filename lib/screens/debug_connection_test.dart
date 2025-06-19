import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';

// Add this file as: lib/screens/debug_connection_test.dart

class DebugConnectionTest extends StatefulWidget {
  const DebugConnectionTest({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DebugConnectionTestState createState() => _DebugConnectionTestState();
}

class _DebugConnectionTestState extends State<DebugConnectionTest> {
  String _testResults = '';
  bool _isLoading = false;

  // Hard-coded URLs for testing - replace with your actual backend URL
  final String baseUrl = 'http://127.0.0.1:8001/api';
  
  Future<void> testDirectConnection() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Starting connection tests...\n\n';
    });

    // Test 1: Direct test-connection endpoint
    await _testEndpoint('$baseUrl/test-connection', 'Test Connection');
    
    // Test 2: Direct user-test endpoint  
    await _testEndpoint('$baseUrl/user-test', 'User Test');
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testEndpoint(String url, String testName) async {
    try {
      setState(() {
        _testResults += '🚀 Testing $testName...\n';
        _testResults += '📡 URL: $url\n';
      });

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      setState(() {
        _testResults += '✅ Status: ${response.statusCode}\n';
        _testResults += '📄 Response: ${response.body}\n';
        
        if (response.statusCode == 200) {
          _testResults += '🎉 $testName SUCCESS!\n\n';
        } else {
          _testResults += '❌ $testName failed with status ${response.statusCode}\n\n';
        }
      });

    } catch (e) {
      setState(() {
        _testResults += '❌ $testName ERROR: $e\n';
        _testResults += 'Error type: ${e.runtimeType}\n\n';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Connection Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : testDirectConnection,
              // ignore: sort_child_properties_last
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Test Backend Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Test Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults.isEmpty ? 'Click "Test Backend Connection" to start...' : _testResults,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}