import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Initialize Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

// Firebase instances
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

// Collections
const String usersCollection = 'users';
const String transactionsCollection = 'transactions';
const String categoriesCollection = 'categories';
const String goalsCollection = 'goals';
const String budgetsCollection = 'budgets';
const String notificationsCollection = 'notifications';
