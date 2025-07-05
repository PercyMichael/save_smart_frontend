import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Replace these values with your Firebase project configuration
const String defaultFirebaseConfig = '''
{
  "apiKey": "AIzaSyCXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "appId": "1:XXXXXXXXXXXX:web:XXXXXXXXXXXXXXXXXXXX",
  "messagingSenderId": "XXXXXXXXXXXX",
  "projectId": "savesmart-app",
  "storageBucket": "savesmart-app.appspot.com"
}
''';

Future<void> initializeFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        appId: "1:XXXXXXXXXXXX:web:XXXXXXXXXXXXXXXXXXXX",
        messagingSenderId: "XXXXXXXXXXXX",
        projectId: "savesmart-app",
        storageBucket: "savesmart-app.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}
