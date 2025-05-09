// lib/utils/connectivity_checker.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:savesmart_app/config/api_config.dart';


class ConnectivityChecker {
  static Future<bool> isServerReachable() async {
    try {
      final uri = Uri.parse(ApiConfig.baseUrl);
      final result = await InternetAddress.lookup(uri.host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  static void showConnectivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connection Issue'),
        content: Text(
          'Cannot connect to the server. Please check:\n'
          '1. Your internet connection\n'
          '2. That your device and server are on the same network\n'
          '3. The server is running\n\n'
          'Server URL: ${ApiConfig.baseUrl}'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}