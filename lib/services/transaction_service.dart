// lib/services/transaction_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static const String _transactionsKey = 'transactions';
  static const String _balanceKey = 'wallet_balance';
  static const double _initialBalance = 215000000.0; // Initial balance of 58095 * 3700 from original code
  static final Uuid _uuid = Uuid();

  // Get wallet balance
  static Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? _initialBalance;
  }

  // Save wallet balance
  static Future<void> saveWalletBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, balance);
  }

  // Get all transactions
  static Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? transactionsJson = prefs.getString(_transactionsKey);
      
      if (transactionsJson == null) {
        // If no transactions exist, return empty list
        return [];
      }
      
      List<dynamic> transactionsList = jsonDecode(transactionsJson);
      return transactionsList
          .map((item) => TransactionModel.fromJson(item))
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date)); // Sort by most recent first
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      return [];
    }
  }

  // Save all transactions
  static Future<void> saveAllTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String transactionsJson = jsonEncode(
        transactions.map((transaction) => transaction.toJson()).toList(),
      );
      await prefs.setString(_transactionsKey, transactionsJson);
    } catch (e) {
      debugPrint('Error saving transactions: $e');
    }
  }

  // Get recent transactions
  static Future<List<TransactionModel>> getRecentTransactions(int limit) async {
    final transactions = await getAllTransactions();
    return transactions.take(limit).toList();
  }

  // Add a deposit transaction
  static Future<void> addDeposit(
    double amount,
    String description,
    String userId, {
    String? goalId,
  }) async {
    await _addTransaction(
      amount,
      TransactionType.deposit,
      description,
      userId,
      goalId: goalId,
    );
  }

  // Add a withdrawal transaction
  static Future<void> addWithdrawal(
    double amount,
    String description,
    String phoneNumber,
    String destinationType,
    String userId, {
    String? goalId,
  }) async {
    await _addTransaction(
      amount,
      TransactionType.withdrawal,
      description,
      userId,
      goalId: goalId,
    );
  }

  // Add a transfer transaction
  static Future<void> addTransfer(
    double amount,
    String description,
    String userId, {
    String? goalId,
  }) async {
    await _addTransaction(
      amount,
      TransactionType.transfer,
      description,
      userId,
      goalId: goalId,
    );
  }

  // Private method to add a transaction
  static Future<void> _addTransaction(
    double amount,
    TransactionType type,
    String description,
    String userId, {
    String? goalId,
  }) async {
    try {
      // Create new transaction
      final transaction = TransactionModel(
        id: _uuid.v4(),
        amount: amount,
        date: DateTime.now(),
        type: type,
        description: description,
        userId: userId,
        goalId: goalId,
      );

      // Get existing transactions
      final transactions = await getAllTransactions();
      transactions.insert(0, transaction); // Add to the beginning of the list

      // Save all transactions
      await saveAllTransactions(transactions);

      // Update balance
      final currentBalance = await getWalletBalance();
      final newBalance = type == TransactionType.deposit 
          ? currentBalance + amount 
          : currentBalance - amount;
      await saveWalletBalance(newBalance);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  // Delete a transaction
  static Future<void> deleteTransaction(String id) async {
    try {
      final transactions = await getAllTransactions();
      final transaction = transactions.firstWhere((t) => t.id == id);
      
      // Update balance
      final currentBalance = await getWalletBalance();
      final newBalance = transaction.type == TransactionType.deposit 
          ? currentBalance - transaction.amount 
          : currentBalance + transaction.amount;
      await saveWalletBalance(newBalance);
      
      // Remove transaction and save
      transactions.removeWhere((t) => t.id == id);
      await saveAllTransactions(transactions);
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Initialize with sample data if needed
  static Future<void> initializeWithSampleData() async {
    final transactions = await getAllTransactions();
    if (transactions.isEmpty) {
      final userId = "user_${_uuid.v4().substring(0, 8)}";
      
      await addDeposit(50000, "Initial deposit", userId);
      await addWithdrawal(20000, "Withdrawal for groceries", "0704985597", "mobile", userId);
      await addDeposit(10000, "Savings contribution", userId);
    }
  }
}