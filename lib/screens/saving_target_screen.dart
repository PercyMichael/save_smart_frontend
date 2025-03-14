import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

class SavingsTargetScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SavingsTargetScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SavingsTargetScreenState createState() => _SavingsTargetScreenState();
}

class _SavingsTargetScreenState extends State<SavingsTargetScreen> {
  // Custom theme color
  final Color primaryColor = const Color(0xFF8EB55D);
  final Color backgroundColor = Colors.white;
  
  // Sample data - In a real app, this would come from a database or API
  final String goalName = "New Laptop";
  final double goalAmount = 1200.00;
  final double currentSaved = 450.00;
  final DateTime startDate = DateTime(2025, 1, 15);
  final DateTime targetDate = DateTime(2025, 8, 30);
  final String category = "Electronics";
  final List<Map<String, dynamic>> milestones = [
    {'percentage': 25, 'reached': true, 'message': 'Great start!'},
    {'percentage': 50, 'reached': false, 'message': 'Halfway there!'},
    {'percentage': 75, 'reached': false, 'message': 'Almost there!'},
    {'percentage': 100, 'reached': false, 'message': 'Goal achieved!'},
  ];
  final List<Map<String, dynamic>> recentContributions = [
    {'date': DateTime(2025, 3, 10), 'amount': 50.00},
    {'date': DateTime(2025, 3, 1), 'amount': 75.00},
    {'date': DateTime(2025, 2, 15), 'amount': 100.00},
  ];

  double get progressPercentage => (currentSaved / goalAmount).clamp(0.0, 1.0);
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  double get suggestedWeeklyContribution {
    final double remaining = goalAmount - currentSaved;
    final int weeksRemaining = (daysRemaining / 7).ceil();
    return weeksRemaining > 0 ? remaining / weeksRemaining : remaining;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Saving Target', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit target screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Header
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.laptop, color: primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goalName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Category: $category',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text('$daysRemaining days left'),
                            // ignore: deprecated_member_use
                            backgroundColor: primaryColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Progress Circle
              Center(
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 15.0,
                  percent: progressPercentage,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${(progressPercentage * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${NumberFormat.currency(symbol: '\$').format(currentSaved)} / ${NumberFormat.currency(symbol: '\$').format(goalAmount)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  progressColor: primaryColor,
                  backgroundColor: Colors.grey.shade200,
                  animation: true,
                  animationDuration: 1200,
                ),
              ),
              const SizedBox(height: 24),

              // Contribution Plans
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contribution Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Suggested Weekly:',
                        NumberFormat.currency(symbol: '\$').format(suggestedWeeklyContribution),
                      ),
                      _buildInfoRow(
                        'Monthly Equivalent:',
                        NumberFormat.currency(symbol: '\$').format(suggestedWeeklyContribution * 4.3),
                      ),
                      _buildInfoRow(
                        'Amount Remaining:',
                        NumberFormat.currency(symbol: '\$').format(goalAmount - currentSaved),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to add contribution screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: const Text('Add Contribution'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Milestones
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Milestones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...milestones.map((milestone) => _buildMilestoneItem(milestone)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recent Contributions
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Contributions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...recentContributions.map((contribution) => _buildContributionItem(contribution)),
                      TextButton(
                        onPressed: () {
                          // Navigate to view all transactions
                        },
                        child: Text(
                          'View All Transactions',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Time Information
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Start Date:',
                        DateFormat('MMM dd, yyyy').format(startDate),
                      ),
                      _buildInfoRow(
                        'Target Date:',
                        DateFormat('MMM dd, yyyy').format(targetDate),
                      ),
                      _buildInfoRow(
                        'Days Remaining:',
                        '$daysRemaining days',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          // Show saving tips or adjustment options
        },
        child: const Icon(Icons.tips_and_updates),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(Map<String, dynamic> milestone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: milestone['reached'] ? primaryColor : Colors.grey.shade300,
            ),
            child: milestone['reached']
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 16),
          Text(
            '${milestone['percentage']}% - ${milestone['message']}',
            style: TextStyle(
              color: milestone['reached'] ? Colors.black : Colors.grey.shade600,
              fontWeight: milestone['reached'] ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionItem(Map<String, dynamic> contribution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.add_circle_outline, color: primaryColor, size: 16),
          ),
          const SizedBox(width: 16),
          Text(
            DateFormat('MMM dd').format(contribution['date']),
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            NumberFormat.currency(symbol: '\$').format(contribution['amount']),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}