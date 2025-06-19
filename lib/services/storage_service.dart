import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:savesmart_app/config/firebase_config.dart';

class StorageService {
  final FirebaseStorage _storage = storage;

  // Option 1: Accept File directly
  Future<String> uploadFile(String userId, File file, String fileName) async {
    final ref = _storage.ref().child('users/$userId/$fileName');
    final uploadTask = ref.putFile(file);
    
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  // Option 2: Keep string path version (from previous fix)
  Future<String> uploadFileFromPath(String userId, String filePath, String fileName) async {
    final ref = _storage.ref().child('users/$userId/$fileName');
    final uploadTask = ref.putFile(File(filePath));
    
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteFile(String userId, String fileName) async {
    final ref = _storage.ref().child('users/$userId/$fileName');
    await ref.delete();
  }

  Future<String> getDownloadURL(String userId, String fileName) async {
    final ref = _storage.ref().child('users/$userId/$fileName');
    return await ref.getDownloadURL();
  }
}