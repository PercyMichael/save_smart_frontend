// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:savesmart_app/services/unified_api_service.dart';
import 'package:savesmart_app/utils/connectivity_checker.dart';
import 'package:savesmart_app/widget/custom_loading_indicator.dart';
import 'package:savesmart_app/widget/empty_state_widget.dart';
import 'package:savesmart_app/widget/error_widget.dart';

// Define the Transaction class inline to ensure compatibility
class Transaction {
  final String id;
  final String description;
  final double amount;
  final String date; // Keep date as String for simplicity

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  // Static factory method for creating Transaction objects from JSON
  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<Transaction> _recentTransactions = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Check connectivity first
      final isConnected = await ConnectivityChecker.isServerReachable();
      if (!isConnected) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Cannot connect to server';
        });
        // Check if context is still valid before showing dialog
        if (mounted) {
          ConnectivityChecker.showConnectivityDialog(context);
        }
        return;
      }

      // Load dashboard data
      final data = await UnifiedApiService.getDashboardData();
      if (mounted) {
        setState(() {
          _dashboardData = data;
        });
      }

      // Load recent transactions
      final transactionsData = await UnifiedApiService.getRecentTransactions();
      
      if (mounted) {
        // Convert each transaction JSON to Transaction object
        final List<Transaction> parsedTransactions = [];
        for (var json in transactionsData) {
          // Make sure json is a Map<String, dynamic>
          if (json is Map<String, dynamic>) {
            parsedTransactions.add(Transaction.fromJson(json));
          }
        }
        
        setState(() {
          _recentTransactions = parsedTransactions;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDashboardData,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const CustomLoadingIndicator(
        message: 'Loading dashboard data...',
      );
    }

    if (_errorMessage.isNotEmpty) {
      return CustomErrorWidget(
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 16),
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    // Check if dashboard data is available
    if (_dashboardData == null) {
      return const EmptyStateWidget(
        message: 'No balance information available',
        icon: Icons.account_balance_wallet,
      );
    }

    // Extract balance info from dashboard data
    final balance = _dashboardData!['balance'] ?? 0.0;
    final currency = _dashboardData!['currency'] ?? 'USD';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Balance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$currency ${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    if (_recentTransactions.isEmpty) {
      return const EmptyStateWidget(
        message: 'No recent transactions',
        icon: Icons.receipt_long,
      );
    }

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _recentTransactions.length > 5 ? 5 : _recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = _recentTransactions[index];
              return ListTile(
                leading: Icon(
                  transaction.amount > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                  color: transaction.amount > 0 ? Colors.green : Colors.red,
                ),
                title: Text(transaction.description),
                subtitle: Text(transaction.date), // Now date is always a String
                trailing: Text(
                  '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.amount > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          if (_recentTransactions.length > 5)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  // Navigate to transactions screen
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionsScreen()));
                },
                child: const Text('View All'),
              ),
            ),
        ],
      ),
    );
  }
}