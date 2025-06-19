import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/firebase_config.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final _auth = auth;
  final _firestore = firestore;
  final _storage = const FlutterSecureStorage();
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await result.user!.updateDisplayName(displayName);
        
        await _firestore.collection(usersCollection).doc(result.user!.uid).set({
          'id': result.user!.uid,
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'isAdmin': false,
        });

        await _storage.write(key: 'user_id', value: result.user!.uid);
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _storage.write(key: 'user_id', value: result.user!.uid);
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.delete(key: 'user_id');
  }

  Future<void> updateProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is currently signed in');

    if (displayName != null) {
      await user.updateDisplayName(displayName);
    }
    if (email != null) {
      // ignore: deprecated_member_use
      await user.updateEmail(email);
    }
    if (photoUrl != null) {
      await user.updatePhotoURL(photoUrl);
    }

    await _firestore.collection(usersCollection).doc(user.uid).update({
      if (displayName != null) 'displayName': displayName,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> verifyEmail() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    await user.sendEmailVerification();
    return true;
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    return user.emailVerified;
  }
}
