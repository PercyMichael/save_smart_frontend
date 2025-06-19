import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAnalyticsProvider with ChangeNotifier {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(
    analytics: FirebaseAnalytics.instance,
  );

  FirebaseAnalyticsObserver get observer => _observer;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    // ignore: deprecated_member_use
    await _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClass ?? '',
    );
  }

  Future<void> logLogin() async {
    await _analytics.logLogin();
  }

  Future<void> logSignUp({
    required String signUpMethod,
  }) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> logPurchase({
    required double value,
    required String currency,
    String? transactionId,
    String? itemName,
  }) async {
    await _analytics.logEvent(
      name: 'purchase',
      parameters: {
        'value': value,
        'currency': currency,
        'transactionId': transactionId ?? '',
        'itemName': itemName ?? '',
      },
    );
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> setUserPropertyFromUser(User? user) async {
    if (user == null) return;

    await setUserProperty(name: 'user_id', value: user.uid);
    
    if (user.displayName != null) {
      await setUserProperty(name: 'display_name', value: user.displayName!);
    }

    if (user.email != null) {
      await setUserProperty(name: 'email', value: user.email!);
    }
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
