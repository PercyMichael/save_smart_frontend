import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SaveScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SaveScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SaveScreenState createState() => _SaveScreenState();
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
  bool _showMobileMoneyFields = false;
  DateTime? _selectedDate;
  
  // Formatter for Ugandan Shillings
  final currencyFormatter = NumberFormat.currency(
    symbol: 'UGX ',
    decimalDigits: 0,
    locale: 'en_UG',
  );

  // Sample data
  final List<String> fundingSources = ['Bank Transfer', 'Mobile Money'];
  final List<String> mobileMoneyProviders = ['MTN Mobile Money', 'Airtel Money'];
  final List<Map<String, dynamic>> savingsAccounts = [
    {'name': 'Main Savings', 'balance': 1500000},
    {'name': 'Emergency Fund', 'balance': 500000},
    {'name': 'House Savings', 'balance': 2500000},
    {'name': 'Education Fund', 'balance': 1000000},
  ];
  final List<int> quickAmounts = [50000, 100000, 500000];

  // Check if all required fields are filled
  void _validateForm() {
    final amountValid = _amountController.text.isNotEmpty;
    final sourceValid = _selectedSource != null && _selectedSource!.isNotEmpty;
    final accountValid = _selectedAccount != null && _selectedAccount!.isNotEmpty;
    
    // Additional validation for mobile money
    bool mobileMoneyValid = true;
    if (_selectedSource == 'Mobile Money') {
      final providerValid = _selectedMobileMoneyProvider != null && 
                           _selectedMobileMoneyProvider!.isNotEmpty;
      final phoneValid = _phoneNumberController.text.isNotEmpty && 
                        _phoneNumberController.text.length >= 10;
      mobileMoneyValid = providerValid && phoneValid;
    }
    
    setState(() {
      _formIsValid = amountValid && sourceValid && accountValid && mobileMoneyValid;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to track form changes
    _amountController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _goalDateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Money'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (UGX)',
                  prefixText: 'UGX ',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quick Amount Buttons
              Row(
                children: quickAmounts.map((amount) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          _amountController.text = amount.toString();
                          _validateForm();
                        },
                        child: Text(currencyFormatter.format(amount)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Source of Funds Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Source of Funds',
                  border: OutlineInputBorder(),
                ),
                value: _selectedSource,
                items: fundingSources.map((String source) {
                  return DropdownMenuItem<String>(
                    value: source,
                    child: Text(source),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                    // Show mobile money fields if Mobile Money is selected
                    _showMobileMoneyFields = value == 'Mobile Money';
                    // Reset mobile money fields if source changes
                    if (!_showMobileMoneyFields) {
                      _selectedMobileMoneyProvider = null;
                      _phoneNumberController.clear();
                    }
                    _validateForm();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mobile Money Provider dropdown (conditionally shown)
              if (_showMobileMoneyFields) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Mobile Money Provider',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedMobileMoneyProvider,
                  items: mobileMoneyProviders.map((String provider) {
                    return DropdownMenuItem<String>(
                      value: provider,
                      child: Text(provider),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMobileMoneyProvider = value;
                      _validateForm();
                    });
                  },
                  validator: (value) {
                    if (_showMobileMoneyFields && (value == null || value.isEmpty)) {
                      return 'Please select a mobile money provider';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number input (conditionally shown)
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Money Number',
                    hintText: _selectedMobileMoneyProvider == 'MTN Mobile Money' 
                              ? '077XXXXXXX' : '075XXXXXXX',
                    border: const OutlineInputBorder(),
                    prefixText: '+256 ',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (_showMobileMoneyFields) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile money number';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid 10-digit number';
                      }
                      
                      // Validate prefix based on provider
                      if (_selectedMobileMoneyProvider == 'MTN Mobile Money' && 
                          !value.startsWith('077') && !value.startsWith('078')) {
                        return 'MTN numbers should start with 077 or 078';
                      }
                      if (_selectedMobileMoneyProvider == 'Airtel Money' && 
                          !value.startsWith('075') && !value.startsWith('070')) {
                        return 'Airtel numbers should start with 075 or 070';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Target Account Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Save To',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAccount,
                items: savingsAccounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account['name'] as String,
                    child: Text(
                      '${account['name']} - ${currencyFormatter.format(account['balance'])}',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccount = value;
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

              // Notes Field
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  hintText: 'Add reference, purpose, or other details',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Transaction Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ID: #TR${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _formIsValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          // Show savings goal dialog before proceeding
                          _showSavingsGoalDialog(context);
                        }
                      }
                    : null, // Button is disabled when form is not valid
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: _formIsValid ? Colors.green : null,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Confirm Saving',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show savings goal dialog
  void _showSavingsGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Set a Savings Goal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Would you like to set a savings goal for this account? This helps track your progress!',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _goalNameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., New Car, Wedding, Vacation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _goalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount (UGX)',
                  prefixText: 'UGX ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _goalDateController,
                decoration: const InputDecoration(
                  labelText: 'Target Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              
              // If mobile money is selected, show PIN authorization dialog
              if (_selectedSource == 'Mobile Money') {
                _showMobileMoneyConfirmation(context);
              } else {
                _processDeposit(context);
              }
            },
            child: const Text('Skip For Now'),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate goal inputs
              if (_goalNameController.text.isEmpty ||
                  _goalAmountController.text.isEmpty ||
                  _goalDateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all goal details or skip'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              
              // Process goal creation
              Navigator.of(context).pop();
              _showGoalCreatedConfirmation(context);
            },
            child: const Text('Set Goal'),
          ),
        ],
      ),
    );
  }

  // Show goal created confirmation
  void _showGoalCreatedConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Goal Created Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            Text('Goal: ${_goalNameController.text}'),
            Text('Target: ${currencyFormatter.format(int.parse(_goalAmountController.text))}'),
            Text('By: ${_goalDateController.text}'),
            const SizedBox(height: 12),
            const Text('Your first contribution will be made with this deposit!'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              
              // Proceed with deposit after goal creation
              if (_selectedSource == 'Mobile Money') {
                _showMobileMoneyConfirmation(context);
              } else {
                _processDeposit(context);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  // Show mobile money confirmation dialog
  void _showMobileMoneyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // ignore: unnecessary_brace_in_string_interps
        title: Text('${_selectedMobileMoneyProvider} Authorization'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A request has been sent to your mobile phone.'),
            const SizedBox(height: 12),
            Text('Please check your phone and enter your PIN to authorize:'),
            const SizedBox(height: 12),
            Text('Amount: ${currencyFormatter.format(int.parse(_amountController.text))}', 
                 style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Phone: +256 ${_phoneNumberController.text}', 
                 style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('This dialog simulates the mobile money authorization process.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processDeposit(context);
            },
            child: const Text('Simulate Authorized'),
          ),
        ],
      ),
    );
  }

  // Process the deposit after confirmation
  void _processDeposit(BuildContext context) {
    // Show processing message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Saving...')),
    );
    
    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      // Show success dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Savings Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 16),
              Text('Amount: ${currencyFormatter.format(int.parse(_amountController.text))}'),
              Text('Account: $_selectedAccount'),
              if (_selectedSource == 'Mobile Money')
                // ignore: unnecessary_brace_in_string_interps
                Text('From: ${_selectedMobileMoneyProvider} (+256 ${_phoneNumberController.text})'),
              if (_goalNameController.text.isNotEmpty)
                Text('Goal: ${_goalNameController.text}'),
              const SizedBox(height: 12),
              Text('Reference ID: #TR${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
              const SizedBox(height: 16),
              const Text('A confirmation SMS has been sent to your phone.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateForm);
    _phoneNumberController.removeListener(_validateForm);
    _amountController.dispose();
    _noteController.dispose();
    _phoneNumberController.dispose();
    _goalNameController.dispose();
    _goalAmountController.dispose();
    _goalDateController.dispose();
    super.dispose();
  }
}