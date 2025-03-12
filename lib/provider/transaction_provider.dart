import 'package:flutter/foundation.dart';

enum TransactionType {
  income,
  expense,
  transfer,
}

enum TransactionCategory {
  food,
  transportation,
  utilities,
  entertainment,
  shopping,
  health,
  education,
  salary,
  investment,
  other,
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String description;
  final TransactionType type;
  final TransactionCategory category;
  final String? fromAccount;
  final String? toAccount;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
    required this.category,
    this.fromAccount,
    this.toAccount,
  });
}

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Get transactions for a specific month
  List<Transaction> getTransactionsForMonth(int month, int year) {
    return _transactions.where((transaction) {
      return transaction.date.month == month && transaction.date.year == year;
    }).toList();
  }

  // Add sample transactions for testing
  void loadSampleTransactions() {
    final now = DateTime.now();
    
    _transactions = [
      Transaction(
        id: '1',
        amount: 1200,
        date: DateTime(now.year, now.month, 1),
        description: 'Salary',
        type: TransactionType.income,
        category: TransactionCategory.salary,
        toAccount: 'Checking',
      ),
      Transaction(
        id: '2',
        amount: 45.50,
        date: DateTime(now.year, now.month, 3),
        description: 'Groceries',
        type: TransactionType.expense,
        category: TransactionCategory.food,
        fromAccount: 'Checking',
      ),
      Transaction(
        id: '3',
        amount: 500,
        date: DateTime(now.year, now.month, 5),
        description: 'Transfer to savings',
        type: TransactionType.transfer,
        category: TransactionCategory.other,
        fromAccount: 'Checking',
        toAccount: 'Savings',
      ),
      Transaction(
        id: '4',
        amount: 35.99,
        date: DateTime(now.year, now.month - 1, 28),
        description: 'Streaming subscription',
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
        fromAccount: 'Checking',
      ),
      Transaction(
        id: '5',
        amount: 200,
        date: DateTime(now.year, now.month - 2, 15),
        description: 'Investment',
        type: TransactionType.expense,
        category: TransactionCategory.investment,
        fromAccount: 'Savings',
        toAccount: 'Investment',
      ),
    ];
    
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Get spending by category for analytics
  Map<TransactionCategory, double> getSpendingByCategory(int month, int year) {
    final Map<TransactionCategory, double> result = {};
    
    for (var transaction in getTransactionsForMonth(month, year)) {
      if (transaction.type == TransactionType.expense) {
        result[transaction.category] = (result[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return result;
  }

  // Get monthly spending totals for the last 6 months
  List<Map<String, dynamic>> getMonthlySpending() {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];
    
    for (int i = 5; i >= 0; i--) {
      final month = now.month - i > 0 ? now.month - i : now.month - i + 12;
      final year = now.month - i > 0 ? now.year : now.year - 1;
      
      double total = 0;
      for (var transaction in getTransactionsForMonth(month, year)) {
        if (transaction.type == TransactionType.expense) {
          total += transaction.amount;
        }
      }
      
      result.add({
        'month': month,
        'monthName': _getMonthName(month),
        'total': total,
      });
    }
    
    return result;
  }
  
  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}