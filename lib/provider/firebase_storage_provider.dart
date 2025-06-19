import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../config/firebase_config.dart';

class FirebaseStorageProvider with ChangeNotifier {
  final _storage = storage;

  Future<String> uploadFile({
    required String userId,
    required File file,
    required String fileName,
    String? folder,
  }) async {
    final ref = _storage
        .ref()
        .child('users/$userId/${folder ?? ''}/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteFile({
    required String userId,
    required String fileName,
    String? folder,
  }) async {
    final ref = _storage
        .ref()
        .child('users/$userId/${folder ?? ''}/$fileName');
    await ref.delete();
  }

  Future<String> getDownloadURL({
    required String userId,
    required String fileName,
    String? folder,
  }) async {
    final ref = _storage
        .ref()
        .child('users/$userId/${folder ?? ''}/$fileName');
    return await ref.getDownloadURL();
  }

  Future<ListResult> listFiles({
    required String userId,
    String? folder,
  }) async {
    final ref = _storage
        .ref()
        .child('users/$userId/${folder ?? ''}');
    return await ref.listAll();
  }
}
