import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savesmart_app/screens/saving_goals_screen.dart';
import 'transaction_screen.dart' as screen;
import 'withdraw_screen.dart';
import 'analytics_screen.dart';
import 'profile_information_screen.dart';
import 'notification_center.dart';
import 'settings_screen.dart';
import 'package:savesmart_app/models/transaction_model.dart';
import 'package:savesmart_app/services/transaction_service.dart';
import 'package:savesmart_app/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currencyFormat = NumberFormat.currency(
    symbol: 'UGX ',
    decimalDigits: 0,
  );

  final Color customGreen = const Color(0xFF8EB55D);
  bool _isBalanceVisible = true;
  double _walletBalance = 0;
  List<TransactionModel> _recentTransactions = [];
  bool _isLoading = true;
  final String _userId = "user_main";
  String _userName = "User"; // Default name

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user profile data
      await _loadUserProfile();
      
      // Load transaction data
      await TransactionService.initializeWithSampleData();
      final balance = await TransactionService.getWalletBalance();
      final transactions = await TransactionService.getRecentTransactions(5);

      setState(() {
        _walletBalance = balance;
        _recentTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      _showErrorSnackBar('Failed to load data. Please try again.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      // Use class name to call static method
      final user = await AuthService.getCurrentUser();
      
      if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
        setState(() {
          // Extract first name if full name is provided
          final nameParts = user.displayName!.split(' ');
          _userName = nameParts.isNotEmpty ? nameParts[0] : user.displayName!;
        });
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // Keep default name if there's an error
    }
  }

  Future<void> _processTransaction(TransactionModel transaction) async {
    if (!_isValidTransaction(transaction)) {
      _showErrorSnackBar('Invalid transaction. Please try again.');
      await _loadData();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _executeTransactionWithRetry(transaction);

      setState(() {
        if (transaction.type == TransactionType.save) {
          _walletBalance += transaction.amount;
        } else if (transaction.type == TransactionType.withdrawal ||
            transaction.type == TransactionType.transfer) {
          _walletBalance -= transaction.amount;
        }

        _recentTransactions.insert(0, transaction);
        if (_recentTransactions.length > 5) {
          _recentTransactions = _recentTransactions.sublist(0, 5);
        }
      });

      _showSuccessSnackBar(transaction);
    } catch (e) {
      debugPrint('Error processing transaction: $e');
      _showErrorSnackBar('Transaction failed: ${e.toString()}');
      await _loadData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidTransaction(TransactionModel transaction) {
    if (transaction.amount <= 0) return false;
    if (transaction.userId != _userId) return false;
    if ((transaction.type == TransactionType.withdrawal ||
            transaction.type == TransactionType.transfer) &&
        transaction.amount > _walletBalance) {
      return false;
    }
    return true;
  }

  Future<void> _executeTransactionWithRetry(TransactionModel transaction,
      {int retries = 2}) async {
    for (int attempt = 1; attempt <= retries + 1; attempt++) {
      try {
        await TransactionService.addTransaction(transaction);
        return;
      } catch (e) {
        if (attempt == retries + 1) {
          throw Exception('Failed after $retries retries: $e');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  void _showSuccessSnackBar(TransactionModel transaction) {
    String actionType;
    String actionVerb;
    Color snackBarColor;

    switch (transaction.type) {
      case TransactionType.save:
        actionType = "Deposit";
        actionVerb = "saved to";
        snackBarColor = customGreen;
        break;
      case TransactionType.withdrawal:
        actionType = "Withdrawal";
        actionVerb = "withdrawn from";
        snackBarColor = Colors.redAccent;
        break;
      case TransactionType.transfer:
        actionType = "Transfer";
        actionVerb = "transferred from";
        snackBarColor = Colors.orangeAccent;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$actionType successful! ${currencyFormat.format(transaction.amount)} $actionVerb your account',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: snackBarColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: customGreen,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  // ignore: deprecated_member_use
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  child: IconButton(
                                    icon: const Icon(Icons.person,
                                        color: Colors.white),
                                    onPressed: () async {
                                      // ignore: unused_local_variable
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileInformationScreen(
                                            onProfileUpdate: () {
                                              // This callback will be triggered when profile is updated
                                              _loadUserProfile();
                                            },
                                          ),
                                        ),
                                      );
                                      // Reload user data when returning from profile screen
                                      await _loadUserProfile();
                                    },
                                  ),
                                ),
                                Text(
                                  'Hello, $_userName',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.notifications,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationCenter()),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Wallet Balance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _isBalanceVisible
                                      ? currencyFormat.format(_walletBalance)
                                      : '•••••••••',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStylishActionButton(
                                  context,
                                  Icons.money_off,
                                  'Withdraw',
                                  const Color(0xFFF5F5F5),
                                  customGreen,
                                  () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WithdrawScreen(
                                                currentBalance: _walletBalance,
                                                userId: _userId,
                                              )),
                                    );
                                    if (result is TransactionModel) {
                                      await _processTransaction(result);
                                    } else if (result == true) {
                                      await _loadData();
                                    }
                                  },
                                ),
                                _buildStylishActionButton(
                                  context,
                                  Icons.add,
                                  'Save',
                                  customGreen,
                                  Colors.white,
                                  () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SavingGoalsScreen(
                                          currentBalance: _walletBalance,
                                          userId: _userId,
                                        ),
                                      ),
                                    );
                                    if (result is TransactionModel) {
                                      await _processTransaction(result);
                                    } else if (result == true) {
                                      await _loadData();
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            _buildAnalyticsCard(context),
                            const SizedBox(height: 20),
                            _buildTransactionsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: customGreen,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        iconSize: 26,
        onTap: (index) async {
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
            await _loadData();
          } else if (index == 2) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen.TransactionScreen(
                  userId: _userId,
                  currentBalance: _walletBalance,
                ),
              ),
            );
            if (result is TransactionModel) {
              await _processTransaction(result);
            } else if (result == true) {
              await _loadData();
            }
          } else if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStylishActionButton(
      BuildContext context,
      IconData icon,
      String label,
      Color backgroundColor,
      Color iconColor,
      VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
        );
        await _loadData();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: customGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.analytics, color: customGreen),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                "Let's take a look at your financial overview for ${DateFormat('MMMM').format(DateTime.now())}!",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color.fromARGB(255, 183, 206, 146)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_recentTransactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No recent transactions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaction history',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screen.TransactionScreen(
                      userId: _userId,
                      currentBalance: _walletBalance,
                    ),
                  ),
                );
                if (result is TransactionModel) {
                  await _processTransaction(result);
                } else if (result == true) {
                  await _loadData();
                }
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: customGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._recentTransactions
            .map((transaction) => _buildTransactionItem(transaction))
            // ignore: unnecessary_to_list_in_spreads
            .toList(),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    String displayName = '';
    if (transaction.description.isNotEmpty) {
      final nameParts = transaction.description.split(' ');
      displayName = nameParts.isNotEmpty ? nameParts[0] : 'User';
    } else if (transaction.transferRecipient != null &&
        transaction.transferRecipient!.isNotEmpty) {
      displayName = transaction.transferRecipient!;
    } else {
      displayName = 'User';
    }

    String typeDisplayName = '';
    bool isCredit = false;

    switch (transaction.type) {
      case TransactionType.save:
        typeDisplayName = 'Deposit';
        isCredit = true;
        break;
      case TransactionType.withdrawal:
        typeDisplayName = 'Withdrawal';
        isCredit = false;
        break;
      case TransactionType.transfer:
        typeDisplayName = 'Transfer';
        isCredit = false;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
              style: TextStyle(
                color: customGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      typeDisplayName,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, h:mm a').format(transaction.date),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'} ${currencyFormat.format(transaction.amount).trim()}',
            style: TextStyle(
              color: isCredit ? customGreen : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}