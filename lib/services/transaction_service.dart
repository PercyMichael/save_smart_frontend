import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savesmart_app/models/transaction_model.dart';

class TransactionService {
  // Keys for SharedPreferences
  static const String _transactionsKey = 'transactions';
  static const String _balanceKey = 'wallet_balance';
  
  // In-memory cache for better performance
  static List<TransactionModel>? _transactionsCache;
  static double? _walletBalanceCache;
  
  // Add a new transaction to the system
  static Future<void> addTransaction(TransactionModel transaction) async {
    // Get current transactions
    final List<TransactionModel> transactions = await getTransactions();
    
    // Add the new transaction
    transactions.add(transaction);
    
    // Update the wallet balance
    double newBalance = await getWalletBalance();
    if (transaction.type == TransactionType.save) {
      newBalance += transaction.amount;
    } else if (transaction.type == TransactionType.withdrawal || 
              transaction.type == TransactionType.transfer) {
      newBalance -= transaction.amount;
    }
    
    // Update cache
    _transactionsCache = transactions;
    _walletBalanceCache = newBalance;
    
    // Save to persistent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_transactionsKey, 
      jsonEncode(transactions.map((t) => t.toJson()).toList()));
    await prefs.setDouble(_balanceKey, newBalance);
  }
  
  // Get all transactions
  static Future<List<TransactionModel>> getTransactions() async {
    // Return from cache if available
    if (_transactionsCache != null) {
      return _transactionsCache!;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? transactionsJson = prefs.getString(_transactionsKey);
      
      if (transactionsJson != null) {
        final List<dynamic> decoded = jsonDecode(transactionsJson);
        _transactionsCache = decoded
            .map((item) => TransactionModel.fromJson(item))
            .toList();
        return _transactionsCache!;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching transactions: $e');
    }
    
    // If no transactions found or error occurred, initialize with sample data
    await initializeWithSampleData();
    return _transactionsCache!;
  }
  
  // Get most recent transactions
  static Future<List<TransactionModel>> getRecentTransactions(int count) async {
    final transactions = await getTransactions();
    // Sort by date, newest first
    transactions.sort((a, b) => b.date.compareTo(a.date));
    // Return requested number of transactions or all if fewer exist
    return transactions.take(count).toList();
  }
  
  // Get current wallet balance
  static Future<double> getWalletBalance() async {
    // Return from cache if available
    if (_walletBalanceCache != null) {
      return _walletBalanceCache!;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final double? balance = prefs.getDouble(_balanceKey);
      
      if (balance != null) {
        _walletBalanceCache = balance;
        return balance;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching wallet balance: $e');
    }
    
    // If no balance found or error occurred, calculate from transactions
    final transactions = await getTransactions();
    double calculatedBalance = transactions.fold(0, (sum, transaction) {
      if (transaction.type == TransactionType.save) {
        return sum + transaction.amount;
      } else if (transaction.type == TransactionType.withdrawal || 
                transaction.type == TransactionType.transfer) {
        return sum - transaction.amount;
      }
      return sum;
    });
    
    // Update cache and storage
    _walletBalanceCache = calculatedBalance;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, calculatedBalance);
    
    return calculatedBalance;
  }
  
  // Initialize with sample data if no data exists
  static Future<void> initializeWithSampleData() async {
    // Check if data already exists
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_transactionsKey)) {
      return; // Data already exists
    }
    
    // Create sample transactions
    final now = DateTime.now();
    final sampleTransactions = [
      TransactionModel(
        id: '1',
        amount: 50000,
        date: now.subtract(const Duration(days: 1)),
        type: TransactionType.save,
        description: 'Initial deposit',
        userId: 'user_main', source: '', category: '',
      ),
      TransactionModel(
        id: '2',
        amount: 20000,
        date: now.subtract(const Duration(days: 2)),
        type: TransactionType.save,
        description: 'Monthly savings',
        userId: 'user_main', source: '', category: '',
      ),
      TransactionModel(
        id: '3',
        amount: 10000,
        date: now.subtract(const Duration(days: 3)),
        type: TransactionType.withdrawal,
        description: 'Grocery shopping',
        userId: 'user_main', source: '', category: '',
      ),
    ];
    
    // Calculate initial balance
    double initialBalance = sampleTransactions.fold(0, (sum, transaction) {
      if (transaction.type == TransactionType.save) {
        return sum + transaction.amount;
      } else if (transaction.type == TransactionType.withdrawal || 
                transaction.type == TransactionType.transfer) {
        return sum - transaction.amount;
      }
      return sum;
    });
    
    // Update cache
    _transactionsCache = sampleTransactions;
    _walletBalanceCache = initialBalance;
    
    // Save to storage
    await prefs.setString(_transactionsKey, 
      jsonEncode(sampleTransactions.map((t) => t.toJson()).toList()));
    await prefs.setDouble(_balanceKey, initialBalance);
  }
  
  // Clear all data (useful for testing/logout)
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
    await prefs.remove(_balanceKey);
    _transactionsCache = null;
    _walletBalanceCache = null;
  }

  static addWithdrawal(double amount, String s, String userId, String phoneNumber, String destinationType) {}
}