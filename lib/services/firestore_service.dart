import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savesmart_app/config/firebase_config.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = firestore;

  // Transactions
  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    await _firestore
        .collection(transactionsCollection)
        .add(transaction);
  }

  Stream<QuerySnapshot> getTransactions(String userId) {
    return _firestore
        .collection(transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> data) async {
    await _firestore
        .collection(transactionsCollection)
        .doc(transactionId)
        .update(data);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _firestore
        .collection(transactionsCollection)
        .doc(transactionId)
        .delete();
  }

  // Categories
  Future<void> addCategory(Map<String, dynamic> category) async {
    await _firestore
        .collection(categoriesCollection)
        .add(category);
  }

  Stream<QuerySnapshot> getCategories(String userId) {
    return _firestore
        .collection(categoriesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    await _firestore
        .collection(categoriesCollection)
        .doc(categoryId)
        .update(data);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestore
        .collection(categoriesCollection)
        .doc(categoryId)
        .delete();
  }

  // Goals
  Future<void> addGoal(Map<String, dynamic> goal) async {
    await _firestore
        .collection(goalsCollection)
        .add(goal);
  }

  Stream<QuerySnapshot> getGoals(String userId) {
    return _firestore
        .collection(goalsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateGoal(String goalId, Map<String, dynamic> data) async {
    await _firestore
        .collection(goalsCollection)
        .doc(goalId)
        .update(data);
  }

  Future<void> deleteGoal(String goalId) async {
    await _firestore
        .collection(goalsCollection)
        .doc(goalId)
        .delete();
  }

  // Budgets
  Future<void> addBudget(Map<String, dynamic> budget) async {
    await _firestore
        .collection(budgetsCollection)
        .add(budget);
  }

  Stream<QuerySnapshot> getBudgets(String userId) {
    return _firestore
        .collection(budgetsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateBudget(String budgetId, Map<String, dynamic> data) async {
    await _firestore
        .collection(budgetsCollection)
        .doc(budgetId)
        .update(data);
  }

  Future<void> deleteBudget(String budgetId) async {
    await _firestore
        .collection(budgetsCollection)
        .doc(budgetId)
        .delete();
  }

  // Notifications
  Future<void> addNotification(Map<String, dynamic> notification) async {
    await _firestore
        .collection(notificationsCollection)
        .add(notification);
  }

  Stream<QuerySnapshot> getNotifications(String userId) {
    return _firestore
        .collection(notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore
        .collection(notificationsCollection)
        .doc(notificationId)
        .update({'read': true});
  }

  Future<void> deleteNotification(String notificationId) async {
    await _firestore
        .collection(notificationsCollection)
        .doc(notificationId)
        .delete();
  }
}
