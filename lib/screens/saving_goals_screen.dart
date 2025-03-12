import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define the theme color as a constant for easy reuse
const Color themeColor = Color(0xFF8EB55D); // Sage green color

class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String iconName;
  final Color color;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.iconName,
    required this.color,
  });
}

class SavingsGoalsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SavingsGoalsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SavingsGoalsScreenState createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<SavingsGoal> _goals = [
    SavingsGoal(
      id: '1',
      name: 'Vacation',
      targetAmount: 3000.00,
      currentAmount: 1250.00,
      targetDate: DateTime(2025, 8, 15),
      iconName: 'beach_access',
      color: themeColor,
    ),
    SavingsGoal(
      id: '2',
      name: 'New Laptop',
      targetAmount: 1500.00,
      currentAmount: 750.00,
      targetDate: DateTime(2025, 5, 1),
      iconName: 'laptop',
      color: themeColor,
    ),
    SavingsGoal(
      id: '3',
      name: 'Emergency Fund',
      targetAmount: 10000.00,
      currentAmount: 3500.00,
      targetDate: DateTime(2025, 12, 31),
      iconName: 'savings',
      color: themeColor,
    ),
  ];

  final currencyFormat = NumberFormat.currency(symbol: '\$');
  final dateFormat = DateFormat('MMM dd, yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: _goals.isEmpty
          ? const Center(
              child: Text(
                'No savings goals yet.\nTap + to add a new goal.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final goal = _goals[index];
                final progress = goal.currentAmount / goal.targetAmount;
                final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              // ignore: deprecated_member_use
                              backgroundColor: themeColor.withOpacity(0.2),
                              child: Icon(
                                _getIconData(goal.iconName),
                                color: themeColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${daysLeft > 0 ? '$daysLeft days left' : 'Target date passed'} • ${dateFormat.format(goal.targetDate)}',
                                    style: TextStyle(
                                      color: daysLeft < 30 
                                          ? Colors.red 
                                          : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                _showGoalOptions(context, goal);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currencyFormat.format(goal.currentAmount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              currencyFormat.format(goal.targetAmount),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}% saved',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.add, color: themeColor),
                              label: Text('Add Money', style: TextStyle(color: themeColor)),
                              onPressed: () {
                                _showAddMoneyDialog(context, goal);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: themeColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        onPressed: () {
          _showAddGoalDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'beach_access':
        return Icons.beach_access;
      case 'laptop':
        return Icons.laptop;
      case 'savings':
        return Icons.savings;
      case 'home':
        return Icons.home;
      case 'directions_car':
        return Icons.directions_car;
      case 'school':
        return Icons.school;
      default:
        return Icons.star;
    }
  }

  void _showGoalOptions(BuildContext context, SavingsGoal goal) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: themeColor),
                title: const Text('Edit Goal'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditGoalDialog(context, goal);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Goal'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, goal);
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: themeColor),
                title: const Text('View Contributions'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contribution history would open here'),
                      backgroundColor: themeColor,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMoneyDialog(BuildContext context, SavingsGoal goal) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Money to ${goal.name}'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '\$',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeColor, width: 2.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add', style: TextStyle(color: themeColor)),
              onPressed: () {
                // Validate and add money to goal
                if (amountController.text.isNotEmpty) {
                  double amount = double.tryParse(amountController.text) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      int index = _goals.indexWhere((g) => g.id == goal.id);
                      if (index != -1) {
                        _goals[index] = SavingsGoal(
                          id: goal.id,
                          name: goal.name,
                          targetAmount: goal.targetAmount,
                          currentAmount: goal.currentAmount + amount,
                          targetDate: goal.targetDate,
                          iconName: goal.iconName,
                          color: themeColor,
                        );
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('\$${amount.toStringAsFixed(2)} added to ${goal.name}'),
                        backgroundColor: themeColor,
                      ),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    // This would be a form to create a new goal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add goal form would open here'),
        backgroundColor: themeColor,
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, SavingsGoal goal) {
    // This would be a form to edit an existing goal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit goal form would open here'),
        backgroundColor: themeColor,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SavingsGoal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Goal'),
          content: Text('Are you sure you want to delete "${goal.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _goals.removeWhere((g) => g.id == goal.id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${goal.name} has been deleted'),
                    backgroundColor: themeColor,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}