import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_screen.dart';
import 'save_screen.dart';
import 'withdraw_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'notification_center.dart';
import 'settings_screen.dart'; // Import the settings screen

class HomeScreen extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(
    symbol: 'UGX ',
    decimalDigits: 0,
  );

  final Color customGreen = const Color(0xFF8EB55D);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                            icon: const Icon(Icons.person, color: Colors.white),
                            onPressed: () {
                              // Navigate to the ProfileScreen when person icon is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileInformationScreen()),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationCenter()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Mukasa John',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Wallet Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(58095 * 3700),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
                            );
                          }
                        ),
                        _buildStylishActionButton(
                          context, 
                          Icons.add, 
                          'Save',
                          customGreen,
                          Colors.white, 
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SaveScreen()),
                            );
                          }
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: customGreen,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransactionScreen()),
            );
          } else if (index == 3) {
            // Navigate to the Settings screen when Settings tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytic'),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
    VoidCallback onPressed
  ) {
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
        );
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
            const Expanded(
              child: Text(
                "Let's take a look at your financial overview for October!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: const Color.fromARGB(255, 183, 206, 146)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaction history',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(color: customGreen),
              ),
            ),
          ],
        ),
        _buildTransactionItem('Paul Yiga ', 'Save', 50000, true, DateTime.now()),
        _buildTransactionItem('Jane Babirye ', 'Withdraw', 20000, false, DateTime.now().subtract(const Duration(hours: 4))),
        _buildTransactionItem('Samuel Okello', 'Save', 10000, true, DateTime.now().subtract(const Duration(days: 1))),
      ],
    );
  }

  Widget _buildTransactionItem(String name, String type, double amount, bool isCredit, DateTime date) {
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
              name[0],
              style: TextStyle(color: customGreen),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'} UGX ${amount.toInt()}',
            style: TextStyle(
              color: isCredit ? customGreen : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}