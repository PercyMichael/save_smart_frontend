// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = const FlutterSecureStorage();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          return UserModel.fromJson(userData.data()!);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }
  bool get isLoading => _isLoading;

  bool get isLoggedIn => _auth.currentUser != null;

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final userData = await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .get();

        if (userData.exists) {
          _user = UserModel.fromJson(userData.data()!);
          await _storage.write(key: 'user_id', value: result.user!.uid);
          notifyListeners();
          return _user;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
    String? district,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await result.user!.updateDisplayName(displayName);
        
        final userData = UserModel(
          id: result.user!.uid,
          name: displayName ?? '',
          email: email,
          balance: 0.0,
          goalIds: [],
          transactionIds: [],
          displayName: displayName,
          phoneNumber: phoneNumber,
          district: district,
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(result.user!.uid).set(userData.toJson());
        await _storage.write(key: 'user_id', value: result.user!.uid);
        _user = userData;
        notifyListeners();
        return userData;
      }
      return null;
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signOut();
      await _storage.delete(key: 'user_id');
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> updateProfile({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? district,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) return null;

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (email != null) {
        await user.verifyBeforeUpdateEmail(email);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      final userData = await _firestore.collection('users').doc(user.uid).get();
      final updatedData = UserModel.fromJson(userData.data()!).copyWith(
        displayName: displayName,
        email: email,
        phoneNumber: phoneNumber,
        district: district,
        photoUrl: photoUrl,
      );

      await _firestore.collection('users').doc(user.uid).update(updatedData.toJson());
      _user = updatedData;
      notifyListeners();
      return updatedData;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmail() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error verifying email: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      return user?.emailVerified ?? false;
    } catch (e) {
      debugPrint('Error checking email verification: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          _user = UserModel.fromJson(userData.data()!);
        }
      }
      notifyListeners();
      return user != null;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email!,
          balance: 0.0,
          goalIds: [],
          transactionIds: [],
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }
      return null;
    });
  }
}