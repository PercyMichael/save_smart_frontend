// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCXn1HZpEBU1-kcqgRZquxEJdTbECOVZdM',
    appId: '1:935260497665:web:eb3a791f9d361a20ec9d00',
    messagingSenderId: '935260497665',
    projectId: 'savesmart-4b599',
    authDomain: 'savesmart-4b599.firebaseapp.com',
    storageBucket: 'savesmart-4b599.firebasestorage.app',
    measurementId: 'G-6K5X0CXQDE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNwjGQUsY1KdRNsvVVBrWu2m2bl_CXAyE',
    appId: '1:935260497665:android:2ba0e3e39a431d38ec9d00',
    messagingSenderId: '935260497665',
    projectId: 'savesmart-4b599',
    storageBucket: 'savesmart-4b599.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfg9_Nnp-_Auoxn0knulVEAhA2bdJht1k',
    appId: '1:935260497665:ios:3101eaf6b51f7eeeec9d00',
    messagingSenderId: '935260497665',
    projectId: 'savesmart-4b599',
    storageBucket: 'savesmart-4b599.firebasestorage.app',
    iosBundleId: 'com.example.savesmartApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfg9_Nnp-_Auoxn0knulVEAhA2bdJht1k',
    appId: '1:935260497665:ios:3101eaf6b51f7eeeec9d00',
    messagingSenderId: '935260497665',
    projectId: 'savesmart-4b599',
    storageBucket: 'savesmart-4b599.firebasestorage.app',
    iosBundleId: 'com.example.savesmartApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCXn1HZpEBU1-kcqgRZquxEJdTbECOVZdM',
    appId: '1:935260497665:web:df9d0967fd2763eeec9d00',
    messagingSenderId: '935260497665',
    projectId: 'savesmart-4b599',
    authDomain: 'savesmart-4b599.firebaseapp.com',
    storageBucket: 'savesmart-4b599.firebasestorage.app',
    measurementId: 'G-CNBW3WJ5NQ',
  );
}
