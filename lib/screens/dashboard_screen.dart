// lib/screens/dashboard_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:savesmart_app/services/unified_api_service.dart';
import 'package:savesmart_app/services/api_service.dart';
import 'package:savesmart_app/config/api_config.dart';
import 'package:savesmart_app/utils/connectivity_checker.dart';
import 'package:savesmart_app/utils/network_debugger.dart'; // Add this import
import 'package:savesmart_app/widget/custom_loading_indicator.dart';
import 'package:savesmart_app/widget/empty_state_widget.dart';
import 'package:savesmart_app/widget/error_widget.dart';

// Define the Transaction class inline to ensure compatibility
class Transaction {
  final String id;
  final String description;
  final double amount;
  final String date;
  final String? type;
  final String? categoryId;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    this.type,
    this.categoryId,
  });

  // Static factory method for creating Transaction objects from JSON
  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      description: json['description'] as String? ?? 'No description',
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String? ?? '',
      type: json['type'] as String?,
      categoryId: json['category_id']?.toString(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String? token;
  final Map<String, dynamic>? user;

  const DashboardScreen({
    super.key,
    this.token,
    this.user,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<Transaction> _recentTransactions = [];
  Map<String, dynamic>? _savingsSummary;
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
        if (mounted) {
          ConnectivityChecker.showConnectivityDialog(context);
        }
        return;
      }

      // Load multiple data sources concurrently
      final results = await Future.wait([
        UnifiedApiService.getDashboardData(),
        UnifiedApiService.getRecentTransactions(),
        UnifiedApiService.getSavingsSummary().catchError((e) => <String, dynamic>{}),
      ]);

      if (mounted) {
        // Parse dashboard data
        setState(() {
          _dashboardData = results[0];
        });

        // Parse transactions
        final transactionsData = results[1];
        final List<Transaction> parsedTransactions = [];
        
        if (transactionsData is List) {
          for (var json in transactionsData) {
            if (json is Map<String, dynamic>) {
              parsedTransactions.add(Transaction.fromJson(json));
            }
          }
        } else if (transactionsData is Map && transactionsData['data'] is List) {
          for (var json in transactionsData['data']) {
            if (json is Map<String, dynamic>) {
              parsedTransactions.add(Transaction.fromJson(json));
            }
          }
        }

        setState(() {
          _recentTransactions = parsedTransactions;
          _savingsSummary = results[2];
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

  Future<void> _performSaveTransaction() async {
    try {
      final saveData = {
        'amount': 100.0,
        'description': 'Test save from Flutter',
        'category_id': 1,
      };

      await UnifiedApiService.saveTransaction(saveData);
      _showSnackBar('Save transaction successful!');
      _loadDashboardData(); // Refresh data
    } catch (e) {
      _showSnackBar('Save transaction failed');
    }
  }

  Future<void> _createSavingGoal() async {
    try {
      final goalData = {
        'title': 'Emergency Fund',
        'target_amount': 1000.0,
        'description': 'Saving for emergencies',
        'target_date': '2024-12-31',
      };

      await UnifiedApiService.createSavingGoal(goalData);
      _showSnackBar('Saving goal created!');
      _loadDashboardData();
    } catch (e) {
      _showSnackBar('Failed to create saving goal');
    }
  }

  Future<void> _logout() async {
    try {
      await UnifiedApiService.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showSnackBar('Logout failed');
    }
  }

  // Debug network connection function
  Future<void> _debugNetwork() async {
    try {
      // Debug network connection
      await NetworkDebugger.debugConnection(ApiConfig.baseUrl);
      
      // Also test the API service
      final apiService = ApiService();
      final canConnect = await apiService.testConnection();
      debugPrint('API Service can connect: $canConnect');
      
      _showSnackBar('Debug completed - check console for details');
    } catch (e) {
      _showSnackBar('Debug failed: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveSmart Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDebugDrawer(), // Add debug drawer
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Debug floating action button (only in debug mode)
          if (kDebugMode)
            FloatingActionButton(
              heroTag: "debug_btn", // Unique hero tag
              onPressed: _debugNetwork,
              backgroundColor: Colors.orange,
              // ignore: sort_child_properties_last
              child: const Icon(Icons.bug_report),
              tooltip: 'Debug Network',
            ),
          if (kDebugMode) const SizedBox(height: 16),
          // Refresh floating action button
          FloatingActionButton(
            heroTag: "refresh_btn", // Unique hero tag
            onPressed: _loadDashboardData,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  // Build debug drawer (only shows in debug mode)
  Widget? _buildDebugDrawer() {
    if (!kDebugMode) return null;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Text(
              'Debug Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Debug Network'),
            onTap: () async {
              Navigator.pop(context); // Close drawer
              await _debugNetwork();
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Refresh Data'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _loadDashboardData();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('API Info'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showSnackBar('Base URL: ${ApiConfig.baseUrl}');
            },
          ),
        ],
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Welcome Card
            if (widget.user != null) _buildWelcomeCard(),
            if (widget.user != null) const SizedBox(height: 16),
            
            // Balance Card
            _buildBalanceCard(),
            const SizedBox(height: 16),
            
            // Savings Summary Card
            if (_savingsSummary != null) _buildSavingsSummaryCard(),
            if (_savingsSummary != null) const SizedBox(height: 16),
            
            // Recent Transactions
            _buildRecentTransactions(),
            const SizedBox(height: 16),
            
            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 16),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${widget.user!['name'] ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Email: ${widget.user!['email'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    if (_dashboardData == null) {
      return const EmptyStateWidget(
        message: 'No balance information available',
        icon: Icons.account_balance_wallet,
      );
    }

    final balance = _dashboardData!['balance'] ?? _dashboardData!['total_balance'] ?? 0.0;
    final totalSavings = _dashboardData!['total_savings'] ?? 0.0;
    final activeGoals = _dashboardData!['active_goals'] ?? 0;
    final currency = _dashboardData!['currency'] ?? 'USD';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '$currency ${balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Savings',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '$currency ${totalSavings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Active Goals: $activeGoals',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Savings Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Add savings summary content based on _savingsSummary data
            Text('Monthly Target: \$${_savingsSummary!['monthly_target'] ?? '0.00'}'),
            Text('This Month: \$${_savingsSummary!['current_month'] ?? '0.00'}'),
            Text('Progress: ${_savingsSummary!['progress_percentage'] ?? '0'}%'),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.date),
                    if (transaction.type != null)
                      Text('Type: ${transaction.type}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                trailing: Text(
                  '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.toStringAsFixed(2)}',
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _performSaveTransaction,
            child: const Text('Test Save \$100'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _createSavingGoal,
            child: const Text('Create Goal'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('View Analytics'),
            onTap: () async {
              try {
                // ignore: unused_local_variable
                final analytics = await UnifiedApiService.getAnalyticsOverview();
                _showSnackBar('Analytics loaded successfully!');
              } catch (e) {
                _showSnackBar('Failed to load analytics');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('View Categories'),
            onTap: () async {
              try {
                final categories = await UnifiedApiService.getCategories();
                _showSnackBar('Categories loaded successfully!');
                // ignore: avoid_print
                print('Categories: $categories');
              } catch (e) {
                _showSnackBar('Failed to load categories');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('View Notifications'),
            onTap: () async {
              try {
                // ignore: unused_local_variable
                final notifications = await UnifiedApiService.getNotifications();
                _showSnackBar('Notifications loaded successfully!');
              } catch (e) {
                _showSnackBar('Failed to load notifications');
              }
            },
          ),
        ],
      ),
    );
  }
}