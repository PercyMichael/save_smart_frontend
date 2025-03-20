import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'save_screen.dart';  // Import the SaveScreen

// Define the custom color as a constant for consistency
const Color customGreen = Color(0xFF8EB55D);

class SavingGoalsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SavingGoalsScreen({Key? key}) : super(key: key);

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Savings Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: customGreen,
        actions: [
          // Redesigned Skip button in the app bar
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
                  prefixIcon: Icon(Icons.attach_money),
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
                    });
                  }
                },
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
                            backgroundColor: Colors.blue,
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
                  
                  // Redesigned Skip button
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Savings goal created successfully!'),
        backgroundColor: customGreen,
      ),
    );
  }
  
  // Method to save the goal and navigate to the save screen
  void _saveGoalAndNavigate(BuildContext context) {
    // First save the goal
    _saveGoal(context);
    
    // Navigate to the SaveScreen with the goal data
    _navigateToSaveScreen(context);
  }
  
  // New method to navigate to SaveScreen with the current form data
  void _navigateToSaveScreen(BuildContext context) {
    // Create a map of the goal data to pass to the SaveScreen
    final goalData = {
      'goalName': _goalNameController.text,
      'targetAmount': double.parse(_targetAmountController.text),
      'currentBalance': double.parse(_currentBalanceController.text),
      'targetDate': _targetDate,
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'frequency': _selectedFrequency,
      'contributionAmount': double.parse(_contributionAmountController.text),
      'notes': _notesController.text,
    };
    
    // Navigate to the SaveScreen and pass the goal data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaveScreen(goalData: goalData),
      ),
    );
  }
  
  // New method to skip to SaveScreen with default values
  void _skipToSaveScreen(BuildContext context) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to save without creating a goal'),
        backgroundColor: customGreen,
      ),
    );
    
    // Navigate to SaveScreen with default data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaveScreen(goalData: defaultGoalData),
      ),
    );
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
            const SizedBox(height: 16),
            
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
              progressColor: customGreen,
              backgroundColor: Color(0xFFD8E6C3), // Lighter shade of customGreen
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
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _currentBalanceController.dispose();
    _contributionAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}