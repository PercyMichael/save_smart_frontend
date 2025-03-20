import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // Add this package for generating unique IDs

enum TransactionType { deposit, withdrawal, transfer }

class TransactionModel {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String userId;
  final String? goalId;
  
  // Additional fields for transaction details
  final String? depositSource;
  final String? withdrawalDestination;
  final String? mobileProvider;
  final String? mobileMoneyNumber;
  final String? transferRecipient;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
    required this.userId,
    this.goalId,
    this.depositSource,
    this.withdrawalDestination,
    this.mobileProvider,
    this.mobileMoneyNumber,
    this.transferRecipient,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      type: _parseTransactionType(json['type']),
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      goalId: json['goalId'],
      depositSource: json['depositSource'],
      withdrawalDestination: json['withdrawalDestination'],
      mobileProvider: json['mobileProvider'],
      mobileMoneyNumber: json['mobileMoneyNumber'],
      transferRecipient: json['transferRecipient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'description': description,
      'userId': userId,
      'goalId': goalId,
      'depositSource': depositSource,
      'withdrawalDestination': withdrawalDestination,
      'mobileProvider': mobileProvider,
      'mobileMoneyNumber': mobileMoneyNumber,
      'transferRecipient': transferRecipient,
    };
  }

  static TransactionType _parseTransactionType(String? typeStr) {
    if (typeStr == 'deposit') return TransactionType.deposit;
    if (typeStr == 'withdrawal') return TransactionType.withdrawal;
    if (typeStr == 'transfer') return TransactionType.transfer;
    return TransactionType.deposit; // Default
  }
}

class TransactionScreen extends StatefulWidget {
  final String userId;
  final String? goalId;
  final double currentBalance;
  
  const TransactionScreen({
    super.key, 
    required this.userId,
    this.goalId,
    required this.currentBalance,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  // ignore: unused_field
  String _description = '';
  TransactionType _transactionType = TransactionType.deposit;
  String _depositSource = 'mobile_money'; // Default deposit source
  String _withdrawalDestination = 'mobile_money'; // Default withdrawal destination
  String _mobileProvider = ''; // MTN or Airtel
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileMoneyNumberController = TextEditingController();
  final TextEditingController _withdrawalMobileNumberController = TextEditingController();
  
  final NumberFormat currencyFormat = NumberFormat('#,###');
  final Color customGreen = const Color(0xFF8EB55D); // Custom green color
  
  String _alertMessage = '';
  bool _showAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showAlert 
            ? Text(_alertMessage, style: const TextStyle(color: Colors.white, fontSize: 16))
            : const Text('New Transaction', style: TextStyle(color: Colors.white)),
        backgroundColor: _showAlert ? Colors.green : customGreen,
        iconTheme: const IconThemeData(color: Colors.white), // Makes back arrow white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 20),
                _buildTransactionTypeToggle(),
                const SizedBox(height: 20),
                _buildAmountInput(),
                const SizedBox(height: 20),
                if (_transactionType == TransactionType.transfer)
                  _buildPhoneInput(),
                if (_transactionType == TransactionType.deposit)
                  _buildDepositSourceInput(),
                if (_transactionType == TransactionType.withdrawal)
                  _buildWithdrawalDestinationInput(),
                if (_transactionType == TransactionType.deposit && _depositSource == 'mobile_money')
                  _buildMobileProviderInput(),
                if (_transactionType == TransactionType.withdrawal && _withdrawalDestination == 'mobile_money')
                  _buildWithdrawalMobileProviderInput(),
                if (_transactionType == TransactionType.deposit && _depositSource == 'mobile_money' && _mobileProvider.isNotEmpty)
                  _buildMobileNumberInput(),
                if (_transactionType == TransactionType.withdrawal && _withdrawalDestination == 'mobile_money' && _mobileProvider.isNotEmpty)
                  _buildWithdrawalMobileNumberInput(),
                const SizedBox(height: 20),
                _buildDescriptionInput(),
                const SizedBox(height: 20),
                _buildDateCard(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Current Balance',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'UGX ${currencyFormat.format(widget.currentBalance)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = TransactionType.deposit),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == TransactionType.deposit ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Deposit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == TransactionType.deposit ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = TransactionType.withdrawal),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == TransactionType.withdrawal ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Withdraw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == TransactionType.withdrawal ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = TransactionType.transfer),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == TransactionType.transfer ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == TransactionType.transfer ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositSourceInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deposit Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDepositSourceOption('mobile_money', 'Mobile Money', Icons.phone_android),
            _buildDepositSourceOption('bank_transfer', 'Bank Transfer', Icons.account_balance),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalDestinationInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdrawal Destination',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildWithdrawalDestinationOption('mobile_money', 'Mobile Money', Icons.phone_android),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalDestinationOption(String value, String label, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() {
        _withdrawalDestination = value;
        _mobileProvider = ''; // Reset provider when changing destination
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: _withdrawalDestination == value ? customGreen.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: _withdrawalDestination == value ? customGreen : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _withdrawalDestination == value ? customGreen : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _withdrawalDestination == value ? customGreen : Colors.black87,
                fontWeight: _withdrawalDestination == value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_withdrawalDestination == value)
              Icon(
                Icons.check_circle,
                color: customGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositSourceOption(String value, String label, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() {
        _depositSource = value;
        _mobileProvider = ''; // Reset provider when changing source
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: _depositSource == value ? customGreen.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: _depositSource == value ? customGreen : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _depositSource == value ? customGreen : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _depositSource == value ? customGreen : Colors.black87,
                fontWeight: _depositSource == value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_depositSource == value)
              Icon(
                Icons.check_circle,
                color: customGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProviderInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mobile Money Provider',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mobileProvider = 'mtn'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: _mobileProvider == 'mtn' ? customGreen.withOpacity(0.1) : Colors.grey[100],
                        border: Border.all(
                          color: _mobileProvider == 'mtn' ? customGreen : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cell_tower,
                            color: _mobileProvider == 'mtn' ? Colors.yellow[700] : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MTN Mobile Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _mobileProvider == 'mtn' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mobileProvider = 'airtel'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: _mobileProvider == 'airtel' ? customGreen.withOpacity(0.1) : Colors.grey[100],
                        border: Border.all(
                          color: _mobileProvider == 'airtel' ? customGreen : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cell_tower,
                            color: _mobileProvider == 'airtel' ? Colors.red : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Airtel Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _mobileProvider == 'airtel' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalMobileProviderInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mobile Money Provider',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mobileProvider = 'mtn'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: _mobileProvider == 'mtn' ? customGreen.withOpacity(0.1) : Colors.grey[100],
                        border: Border.all(
                          color: _mobileProvider == 'mtn' ? customGreen : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cell_tower,
                            color: _mobileProvider == 'mtn' ? Colors.yellow[700] : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MTN Mobile Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _mobileProvider == 'mtn' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mobileProvider = 'airtel'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: _mobileProvider == 'airtel' ? customGreen.withOpacity(0.1) : Colors.grey[100],
                        border: Border.all(
                          color: _mobileProvider == 'airtel' ? customGreen : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cell_tower,
                            color: _mobileProvider == 'airtel' ? Colors.red : Colors.grey[600],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Airtel Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _mobileProvider == 'airtel' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNumberInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_mobileProvider == 'mtn' ? 'MTN' : 'Airtel'} Mobile Money Number',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _mobileMoneyNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter mobile money number',
                border: const OutlineInputBorder(),
                prefixText: '+256 ',
                suffixIcon: Icon(
                  Icons.phone,
                  color: _mobileProvider == 'mtn' ? Colors.yellow[700] : Colors.red,
                ),
              ),
              validator: (value) {
                if (_transactionType == TransactionType.deposit && _depositSource == 'mobile_money' && 
                    _mobileProvider.isNotEmpty && (value == null || value.isEmpty)) {
                  return 'Please enter a mobile money number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // Here you would implement contact selection
                // For now, we'll just set a dummy phone number
                setState(() {
                  _mobileMoneyNumberController.text = '7XX XXX XXX';
                });
              },
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(
                foregroundColor: customGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalMobileNumberInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_mobileProvider == 'mtn' ? 'MTN' : 'Airtel'} Mobile Money Number',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _withdrawalMobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter mobile money number',
                border: const OutlineInputBorder(),
                prefixText: '+256 ',
                suffixIcon: Icon(
                  Icons.phone,
                  color: _mobileProvider == 'mtn' ? Colors.yellow[700] : Colors.red,
                ),
              ),
              validator: (value) {
                if (_transactionType == TransactionType.withdrawal && _withdrawalDestination == 'mobile_money' && 
                    _mobileProvider.isNotEmpty && (value == null || value.isEmpty)) {
                  return 'Please enter a mobile money number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // Here you would implement contact selection
                // For now, we'll just set a dummy phone number
                setState(() {
                  _withdrawalMobileNumberController.text = '7XX XXX XXX';
                });
              },
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(
                foregroundColor: customGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
                hintText: '0',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                try {
                  double amount = double.parse(value.replaceAll(',', ''));
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  if ((_transactionType == TransactionType.withdrawal || _transactionType == TransactionType.transfer) && amount > widget.currentBalance) {
                    return 'Insufficient balance';
                  }
                } catch (e) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onChanged: (value) {
                String numericValue = value.replaceAll(',', '');
                if (numericValue.isNotEmpty) {
                  setState(() {
                    _amount = double.tryParse(numericValue) ?? 0;
                    String formatted = currencyFormat.format(_amount);
                    _amountController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickAmountButton(5000),
                _quickAmountButton(10000),
                _quickAmountButton(20000),
                _quickAmountButton(50000),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phone Number',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(),
                prefixText: '+256 ',
                suffixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (_transactionType == TransactionType.transfer && (value == null || value.isEmpty)) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // Here you would implement contact selection
                // For now, we'll just set a dummy phone number
                setState(() {
                  _phoneController.text = '7XX XXX XXX';
                });
              },
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(
                foregroundColor: customGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Add a note (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _description = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('MMM dd, yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _processTransaction() {
    if (_formKey.currentState!.validate()) {
      // Create a transaction model
      final TransactionModel transaction = TransactionModel(
        id: const Uuid().v4(), // Generate a unique ID
        amount: _amount,
        date: DateTime.now(),
        type: _transactionType,
        description: _descriptionController.text,
        userId: widget.userId,
        goalId: widget.goalId,
        depositSource: _transactionType == TransactionType.deposit ? _depositSource : null,
        withdrawalDestination: _transactionType == TransactionType.withdrawal ? _withdrawalDestination : null,
        mobileProvider: (_depositSource == 'mobile_money' || _withdrawalDestination == 'mobile_money') ? _mobileProvider : null,
        mobileMoneyNumber: _depositSource == 'mobile_money' && _mobileProvider.isNotEmpty ? 
            _mobileMoneyNumberController.text : null,
        transferRecipient: _transactionType == TransactionType.transfer ? _phoneController.text : null,
      );

      String buttonText;
      switch (_transactionType) {
        case TransactionType.deposit:
          buttonText = 'Deposit';
          break;
        case TransactionType.withdrawal:
          buttonText = 'Withdrawal';
          break;
        case TransactionType.transfer:
          buttonText = 'Transfer';
          break;
      }
      
      // Show the alert in the app bar
      setState(() {
        _alertMessage = '$buttonText successful';
        _showAlert = true;
      });
      
      // Wait briefly to show the success message before navigating back
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Navigate back to home screen with the transaction model
          Navigator.of(context).pop({
            'success': true,
            'transaction': transaction.toJson(),
          });
        }
      });
    }
  }

  Widget _buildSubmitButton() {
    String buttonText;
    switch (_transactionType) {
      case TransactionType.deposit:
        buttonText = 'Save';
        break;
      case TransactionType.withdrawal:
        buttonText = 'Withdraw';
        break;
      case TransactionType.transfer:
        buttonText = 'Transfer';
        break;
    }
    
    return ElevatedButton(
      onPressed: _processTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: customGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _quickAmountButton(double amount) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _amount = amount;
          _amountController.text = currencyFormat.format(amount);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'UGX ${currencyFormat.format(amount)}',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _mobileMoneyNumberController.dispose();
    _withdrawalMobileNumberController.dispose();
    super.dispose();
  }
}