import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:savesmart_app/models/transactions_model.dart';
import 'save_screen.dart';

// Define the custom color as a constant for consistency
const Color customGreen = Color(0xFF8EB55D);

class SavingGoalsScreen extends StatefulWidget {
  final double currentBalance;
  final String userId;

  const SavingGoalsScreen({
    super.key,
    required this.currentBalance,
    required this.userId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SavingsGoalScreenState createState() => _SavingsGoalScreenState();
}

class _SavingsGoalScreenState extends State<SavingGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _goalNameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentBalanceController = TextEditingController();
  final _contributionAmountController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Values
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));
  String _selectedCategory = 'Education';
  String _selectedPriority = 'Medium';
  String _selectedFrequency = 'Weekly';
  
  // Alert message state
  bool _showAlert = false;
  String _alertMessage = '';
  Color _alertColor = customGreen;
  
  // Category options
  final List<String> _categories = [
    'Education', 
    'Home', 
    'Emergency Fund', 
    'Business', 
    'Agriculture', 
    'Wedding', 
    'Vehicle', 
    'Family', 
    'Healthcare',
    'Other'
  ];
  
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];
  
  // Format currency in UGX
  final currencyFormat = NumberFormat.currency(
    locale: 'en_UG', 
    symbol: 'UGX ', 
    decimalDigits: 0
  );
  
  // Recommended savings amount based on frequency and target
  double _recommendedAmount = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    // Set up listeners for dynamic calculations
    _targetAmountController.addListener(_updateRecommendedAmount);
    _currentBalanceController.addListener(_updateRecommendedAmount);
    _contributionAmountController.addListener(_checkContributionAmount);
  }
  
  // Calculate the recommended amount based on goal and timeframe
  void _updateRecommendedAmount() {
    double targetAmount = double.tryParse(_targetAmountController.text) ?? 0;
    double currentBalance = double.tryParse(_currentBalanceController.text) ?? 0;
    double remainingAmount = targetAmount - currentBalance > 0 ? targetAmount - currentBalance : 0;
    
    // Calculate days until target date
    int daysRemaining = _targetDate.difference(DateTime.now()).inDays;
    
    if (daysRemaining <= 0 || remainingAmount <= 0) {
      setState(() {
        _recommendedAmount = 0;
      });
      return;
    }
    
    // Calculate based on frequency
    switch (_selectedFrequency) {
      case 'Daily':
        setState(() {
          _recommendedAmount = remainingAmount / daysRemaining;
        });
        break;
      case 'Weekly':
        setState(() {
          _recommendedAmount = remainingAmount / (daysRemaining / 7);
        });
        break;
      case 'Monthly':
        setState(() {
          _recommendedAmount = remainingAmount / (daysRemaining / 30);
        });
        break;
      default:
        setState(() {
          _recommendedAmount = 0;
        });
    }
  }
  
  // Check if contribution amount is sufficient
  void _checkContributionAmount() {
    double contributionAmount = double.tryParse(_contributionAmountController.text) ?? 0;
    
    // If user has entered an amount and it's less than 50% of recommended
    if (contributionAmount > 0 && _recommendedAmount > 0 && contributionAmount < (_recommendedAmount * 0.5)) {
      setState(() {
        _showAlert = true;
        _alertMessage = 'Your contribution may be too low to reach your goal on time.';
        _alertColor = Colors.amber;
      });
    } else {
      setState(() {
        _showAlert = false;
      });
    }
  }
  
  // Show alert at the top
  void _showTopAlert(String message, Color backgroundColor) {
    setState(() {
      _showAlert = true;
      _alertMessage = message;
      _alertColor = backgroundColor;
    });
    
    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showAlert = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_showAlert ? 100 : 56),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Create Savings Goal',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              backgroundColor: customGreen,
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigate to SaveScreen with default values
                    _skipToSaveScreen(context);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            // Alert message banner below AppBar
            if (_showAlert)
              Container(
                width: double.infinity,
                color: _alertColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  _alertMessage,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Goal Preview Card
              goalPreviewCard(),
              const SizedBox(height: 24),
              
              // Form Fields
              const Text(
                'Goal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Goal Name
              TextFormField(
                controller: _goalNameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              // Target Amount
              TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount (UGX)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                  helperText: 'Total amount needed to achieve your goal in Ugandan Shillings',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              // Current Balance
              TextFormField(
                controller: _currentBalanceController,
                decoration: const InputDecoration(
                  labelText: 'Current Savings (UGX)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.savings),
                  helperText: 'How much have you saved already in Ugandan Shillings?',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current savings';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              // Target Date
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _targetDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null && picked != _targetDate) {
                    setState(() {
                      _targetDate = picked;
                      // Recalculate recommended amount when date changes
                      _updateRecommendedAmount();
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Target Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd MMM yyyy').format(_targetDate)),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Priority Level
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority Level',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                value: _selectedPriority,
                items: _priorities.map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Contribution Frequency
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Contribution Frequency',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                ),
                value: _selectedFrequency,
                items: _frequencies.map((String frequency) {
                  return DropdownMenuItem<String>(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFrequency = newValue;
                      // Recalculate recommended amount when frequency changes
                      _updateRecommendedAmount();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Recommended Amount Section
              if (_recommendedAmount > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: customGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    // ignore: deprecated_member_use
                    border: Border.all(color: customGreen.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: customGreen),
                          const SizedBox(width: 8),
                          const Text(
                            'Recommended Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: customGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'To reach your goal by ${DateFormat('dd MMM yyyy').format(_targetDate)}, we recommend depositing ${currencyFormat.format(_recommendedAmount)} $_selectedFrequency.',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Apply recommended amount to contribution field
                              setState(() {
                                _contributionAmountController.text = _recommendedAmount.round().toString();
                              });
                            },
                            child: const Text('Use this amount'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              
              // Contribution Amount
              TextFormField(
                controller: _contributionAmountController,
                decoration: InputDecoration(
                  labelText: 'Deposit Amount (UGX)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.add_card),
                  helperText: 'How much will you save $_selectedFrequency in Ugandan Shillings?',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contribution amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  helperText: 'Why is this goal important to you?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Buttons section
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row with Save and Contribute buttons
                  Row(
                    children: [
                      // Save Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Save the goal data
                              _saveGoal(context);
                              
                              // Navigate to SaveScreen after creating the goal
                              _navigateToSaveScreen(context);
                            }
                          },
                          child: const Text(
                            'Create Goal',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Contribute Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Save the goal data and navigate to save screen
                              _saveGoalAndNavigate(context);
                            }
                          },
                          child: const Text(
                            'Create & Contribute',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Skip button
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Navigate to SaveScreen with default values
                      _skipToSaveScreen(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: customGreen,
                    ),
                    child: const Text(
                      'Continue without creating a goal',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Method to save the goal and show success message
  void _saveGoal(BuildContext context) {
    // Here you would save the goal data to your database
    _showTopAlert('Savings goal created successfully!', customGreen);
  }
  
  // Method to save the goal and navigate to the save screen
  void _saveGoalAndNavigate(BuildContext context) {
    // First save the goal
    _saveGoal(context);
    
    // Navigate to the SaveScreen with the goal data
    _navigateToSaveScreen(context);
  }
  
  // Method to navigate to SaveScreen with the current form data
  void _navigateToSaveScreen(BuildContext context) async {
    // Create a map of the goal data to pass to the SaveScreen
    final goalData = {
      'goalName': _goalNameController.text,
      'targetAmount': double.tryParse(_targetAmountController.text) ?? 0.0,
      'currentBalance': double.tryParse(_currentBalanceController.text) ?? 0.0,
      'targetDate': _targetDate,
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'frequency': _selectedFrequency,
      'contributionAmount': double.tryParse(_contributionAmountController.text) ?? 0.0,
      'notes': _notesController.text,
    };
    
    // Navigate to SaveScreen and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaveScreen(
          goalData: goalData,
          userId: widget.userId, // Pass userId from constructor
        ),
      ),
    );
    
    debugPrint('SavingGoalsScreen received result: $result');
    
    // If a TransactionModel is returned, pass it back to HomeScreen
    if (result is TransactionModel) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, result);
    }
  }
  
  // Method to skip to SaveScreen with default values
  void _skipToSaveScreen(BuildContext context) async {
    // Create default goal data to pass to SaveScreen
    final defaultGoalData = {
      'goalName': 'Quick Save',
      'targetAmount': 0.0,
      'currentBalance': 0.0,
      'targetDate': DateTime.now().add(const Duration(days: 365)),
      'category': 'Other',
      'priority': 'Medium',
      'frequency': 'Weekly',
      'contributionAmount': 0.0,
      'notes': '',
    };
    
    // Show feedback that we're skipping
    _showTopAlert('Proceeding to save without creating a goal', customGreen);
    
    // Navigate to SaveScreen and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaveScreen(
          goalData: defaultGoalData,
          userId: widget.userId, // Pass userId from constructor
        ),
      ),
    );
    
    debugPrint('SavingGoalsScreen received result: $result');
    
    // If a TransactionModel is returned, pass it back to HomeScreen
    if (result is TransactionModel) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, result);
    }
  }
  
  Widget goalPreviewCard() {
    // Calculate progress percentage
    double targetAmount = double.tryParse(_targetAmountController.text) ?? 0;
    double currentBalance = double.tryParse(_currentBalanceController.text) ?? 0;
    double progress = targetAmount > 0 ? (currentBalance / targetAmount) : 0;
    if (progress > 1) progress = 1;
    
    String goalName = _goalNameController.text.isEmpty 
        ? 'Your Savings Goal' 
        : _goalNameController.text;
    
    // Days remaining calculation
    int daysRemaining = _targetDate.difference(DateTime.now()).inDays;
    
    // Projected completion date based on contribution rate
    String projectedCompletion = 'On target';
    double contributionAmount = double.tryParse(_contributionAmountController.text) ?? 0;
    
    if (targetAmount > currentBalance && contributionAmount > 0) {
      double remaining = targetAmount - currentBalance;
      int numberOfContributions = (remaining / contributionAmount).ceil();
      
      // Calculate projected date based on frequency
      DateTime projectedDate;
      switch (_selectedFrequency) {
        case 'Daily':
          projectedDate = DateTime.now().add(Duration(days: numberOfContributions));
          break;
        case 'Weekly':
          projectedDate = DateTime.now().add(Duration(days: numberOfContributions * 7));
          break;
        case 'Monthly':
          projectedDate = DateTime.now().add(Duration(days: numberOfContributions * 30));
          break;
        default:
          projectedDate = _targetDate;
      }
      
      if (projectedDate.isAfter(_targetDate)) {
        int daysLate = projectedDate.difference(_targetDate).inDays;
        projectedCompletion = daysLate > 30 ? 'At risk' : 'Slightly delayed';
      }
    }
    
    // Dynamic color based on progress
    Color progressColor;
    if (progress < 0.25) {
      progressColor = Colors.red;
    } else if (progress < 0.5) {
      progressColor = Colors.orange;
    } else if (progress < 0.75) {
      progressColor = Colors.amber;
    } else {
      progressColor = customGreen;
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              goalName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Show dynamic status tag
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: projectedCompletion == 'On target' ? customGreen.withOpacity(0.2) : 
                       // ignore: deprecated_member_use
                       projectedCompletion == 'Slightly delayed' ? Colors.amber.withOpacity(0.2) : 
                       // ignore: deprecated_member_use
                       Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                projectedCompletion,
                style: TextStyle(
                  color: projectedCompletion == 'On target' ? customGreen : 
                         projectedCompletion == 'Slightly delayed' ? Colors.amber.shade800 : 
                         Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              percent: progress,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const Text('Complete')
                ],
              ),
              progressColor: progressColor,
              backgroundColor: const Color(0xFFD8E6C3), // Lighter shade of customGreen
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current'),
                    Text(
                      currencyFormat.format(currentBalance),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Target'),
                    Text(
                      currencyFormat.format(targetAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Remaining'),
                    Text(
                      currencyFormat.format(targetAmount - currentBalance > 0 
                          ? targetAmount - currentBalance 
                          : 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Time Left'),
                    Text(
                      '$daysRemaining days',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _targetAmountController.removeListener(_updateRecommendedAmount);
    _currentBalanceController.removeListener(_updateRecommendedAmount);
    _contributionAmountController.removeListener(_checkContributionAmount);
    
    // Dispose controllers
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _currentBalanceController.dispose();
    _contributionAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}