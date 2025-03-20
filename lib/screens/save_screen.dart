import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SaveScreen extends StatefulWidget {
  final Map<String, dynamic>? goalData;
  const SaveScreen({super.key, this.goalData});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _goalNameController = TextEditingController();
  final _goalAmountController = TextEditingController();
  final _goalDateController = TextEditingController();

  String? _selectedSource;
  String? _selectedAccount;
  String? _selectedMobileMoneyProvider;
  bool _formIsValid = false;
  // ignore: unused_field
  final bool _showMobileMoneyFields = false;
  DateTime? _selectedDate;
  bool _hasPrefilledGoal = false;
  // ignore: unused_field
  final bool _isLoading = false;

  final currencyFormatter = NumberFormat.currency(
    symbol: 'UGX ',
    decimalDigits: 0,
    locale: 'en_UG',
  );

  final List<String> fundingSources = ['Bank Transfer', 'Mobile Money'];
  final List<String> mobileMoneyProviders = [
    'MTN Mobile Money',
    'Airtel Money'
  ];
  final List<Map<String, dynamic>> savingsAccounts = [
    {'name': 'Main Savings', 'balance': 1500000},
    {'name': 'Emergency Fund', 'balance': 500000},
    {'name': 'House Savings', 'balance': 2500000},
    {'name': 'Education Fund', 'balance': 1000000},
  ];
  final List<int> quickAmounts = [50000, 100000, 500000];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
    _initializeWithGoalData();
  }

  void _initializeWithGoalData() {
    if (widget.goalData != null) {
      setState(() {
        _hasPrefilledGoal = true;
        _goalNameController.text = widget.goalData!['goalName'];
        _goalAmountController.text =
            widget.goalData!['targetAmount'].toString();

        if (widget.goalData!['targetDate'] != null) {
          _selectedDate = widget.goalData!['targetDate'];
          _goalDateController.text =
              DateFormat('dd MMM yyyy').format(_selectedDate!);
        }

        if (widget.goalData!['contributionAmount'] != null) {
          _amountController.text =
              widget.goalData!['contributionAmount'].toString();
        }

        String category = widget.goalData!['category'];
        for (var account in savingsAccounts) {
          if (account['name'].toString().contains(category)) {
            _selectedAccount = account['name'] as String;
            break;
          }
        }

        if (_selectedAccount == null && savingsAccounts.isNotEmpty) {
          _selectedAccount = savingsAccounts[0]['name'] as String;
        }

        if (widget.goalData!['notes'] != null &&
            widget.goalData!['notes'].toString().isNotEmpty) {
          _noteController.text = "For goal: ${widget.goalData!['notes']}";
        }
        _selectedSource = fundingSources[0];
      });
      _validateForm();
    }
  }

  void _validateForm() {
    final amountValid = _amountController.text.isNotEmpty;
    final sourceValid = _selectedSource != null && _selectedSource!.isNotEmpty;
    final accountValid =
        _selectedAccount != null && _selectedAccount!.isNotEmpty;

    bool mobileMoneyValid = true;
    if (_selectedSource == 'Mobile Money') {
      final providerValid = _selectedMobileMoneyProvider != null &&
          _selectedMobileMoneyProvider!.isNotEmpty;
      final phoneValid = _phoneNumberController.text.isNotEmpty &&
          _phoneNumberController.text.length >= 10;
      mobileMoneyValid = providerValid && phoneValid;
    }

    setState(() {
      _formIsValid =
          amountValid && sourceValid && accountValid && mobileMoneyValid;
    });
  }

  void _showMobileMoneyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Mobile Money Deposit'),
          content: const Text(
              'Are you sure you want to proceed with Mobile Money deposit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _processDeposit(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8EB55D), // Your green color
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _processDeposit(BuildContext context) {
    // Show saving process started at the top
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Saving process started...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8EB55D), // Your green color
        margin: const EdgeInsets.fromLTRB(16, 50, 16, 0), // Position at top
      ),
    );
    
    // Simulate processing time
    Future.delayed(const Duration(seconds: 1), () {
      // Show success dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success!'),
            content: const Text('Your money has been saved successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // More robust navigation to home screen
                  Navigator.of(context).popUntil((route) => route.isFirst); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EB55D), // Your green color
                ),
                child: const Text('Back to Home'),
              ),
            ],
          );
        },
      );
    });
    // Here, you can add API integration for deposit processing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Save Money',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8EB55D), // Updated to your green color
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display goal banner if navigated from goal creation
              if (_hasPrefilledGoal) _buildGoalBanner(),

              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount to Save (UGX)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                  helperText: 'Enter the amount you want to save',
                  suffixText: 'UGX',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quick amount buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: quickAmounts.map((amount) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _amountController.text = amount.toString();
                      });
                      _validateForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                    ),
                    child: Text(currencyFormatter.format(amount)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Funding source dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Funding Source',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
                value: _selectedSource,
                items: fundingSources.map((String source) {
                  return DropdownMenuItem<String>(
                    value: source,
                    child: Text(source),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSource = newValue;
                    _validateForm();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a funding source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mobile Money fields if Mobile Money is selected
              if (_selectedSource == 'Mobile Money') ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Service Provider',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  value: _selectedMobileMoneyProvider,
                  items: mobileMoneyProviders.map((String provider) {
                    return DropdownMenuItem<String>(
                      value: provider,
                      child: Text(provider),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMobileMoneyProvider = newValue;
                      _validateForm();
                    });
                  },
                  validator: (value) {
                    if (_selectedSource == 'Mobile Money' &&
                        (value == null || value.isEmpty)) {
                      return 'Please select a mobile money provider';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    helperText: 'Enter your mobile money number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (_selectedSource == 'Mobile Money') {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Account dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Save Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.savings),
                ),
                value: _selectedAccount,
                items: savingsAccounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account['name'] as String,
                    child: Text(
                        '${account['name']} (${currencyFormatter.format(account['balance'])})'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAccount = newValue;
                    _validateForm();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an account';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes field
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  helperText: 'Add any notes about this saving',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Confirm button
              ElevatedButton(
                onPressed: _formIsValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedSource == 'Mobile Money') {
                            _showMobileMoneyConfirmation(context);
                          } else {
                            _processDeposit(context);
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: _formIsValid ? const Color(0xFF8EB55D) : null, // Updated to your green color
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  'Save ${_amountController.text.isNotEmpty ? currencyFormatter.format(double.parse(_amountController.text)) : ""}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalBanner() {
    return Card(
      elevation: 2.0,
      color: Colors.blue.shade50,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Goal: ${_goalNameController.text}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                'Target: ${currencyFormatter.format(double.parse(_goalAmountController.text))}'),
            if (_selectedDate != null) ...[
              const SizedBox(height: 4),
              Text(
                  'Deadline: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}'),
            ],
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.0, // This would be calculated based on current progress
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF8EB55D)), // Updated to your green color
            ),
            const SizedBox(height: 4),
            const Text(
              'Getting started on your goal!',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}