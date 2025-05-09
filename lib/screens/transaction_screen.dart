import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savesmart_app/models/transaction_model.dart' as model;
import 'package:savesmart_app/services/transaction_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
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
  model.TransactionType _transactionType = model.TransactionType.save;
  String _depositSource = 'mobile_money';
  String _withdrawalDestination = 'mobile_money';
  String _mobileProvider = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileMoneyNumberController = TextEditingController();
  final TextEditingController _withdrawalMobileNumberController = TextEditingController();

  final NumberFormat currencyFormat = NumberFormat('#,###');
  final Color customGreen = const Color(0xFF8EB55D);
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
        iconTheme: const IconThemeData(color: Colors.white),
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
                if (_transactionType == model.TransactionType.transfer) _buildPhoneInput(),
                if (_transactionType == model.TransactionType.save) _buildDepositSourceInput(),
                if (_transactionType == model.TransactionType.withdrawal) _buildWithdrawalDestinationInput(),
                if (_transactionType == model.TransactionType.save && _depositSource == 'mobile_money')
                  _buildMobileProviderInput(),
                if (_transactionType == model.TransactionType.withdrawal && _withdrawalDestination == 'mobile_money')
                  _buildWithdrawalMobileProviderInput(),
                if (_transactionType == model.TransactionType.save &&
                    _depositSource == 'mobile_money' &&
                    _mobileProvider.isNotEmpty)
                  _buildMobileNumberInput(),
                if (_transactionType == model.TransactionType.withdrawal &&
                    _withdrawalDestination == 'mobile_money' &&
                    _mobileProvider.isNotEmpty)
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
                onTap: () => setState(() => _transactionType = model.TransactionType.save),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == model.TransactionType.save ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == model.TransactionType.save ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = model.TransactionType.withdrawal),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == model.TransactionType.withdrawal ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Withdraw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == model.TransactionType.withdrawal ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = model.TransactionType.transfer),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == model.TransactionType.transfer ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == model.TransactionType.transfer ? Colors.white : Colors.black,
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
        _mobileProvider = '';
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
        _mobileProvider = '';
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
              validator: (value) => _validateMobileNumber(value, model.TransactionType.save),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectContact(_mobileMoneyNumberController),
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(foregroundColor: customGreen),
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
              validator: (value) => _validateMobileNumber(value, model.TransactionType.withdrawal),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectContact(_withdrawalMobileNumberController),
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(foregroundColor: customGreen),
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
              validator: _validateAmount,
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
                } else {
                  setState(() => _amount = 0);
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _quickAmountButton(5000),
                  const SizedBox(width: 8),
                  _quickAmountButton(10000),
                  const SizedBox(width: 8),
                  _quickAmountButton(20000),
                  const SizedBox(width: 8),
                  _quickAmountButton(50000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAmountButton(double amount) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _amount = amount;
          _amountController.text = currencyFormat.format(amount);
        });
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: customGreen,
        side: BorderSide(color: customGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text('UGX ${currencyFormat.format(amount)}'),
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
                if (_transactionType == model.TransactionType.transfer && (value == null || value.isEmpty)) {
                  return 'Please enter a phone number';
                }
                if (value != null && !_isValidPhoneNumber(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectContact(_phoneController),
              icon: const Icon(Icons.contacts),
              label: const Text('Select from contacts'),
              style: OutlinedButton.styleFrom(foregroundColor: customGreen),
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

  String _getDefaultDescription() {
    switch (_transactionType) {
      case model.TransactionType.save:
        return _depositSource == 'mobile_money'
            ? '${_mobileProvider.capitalize()} Money Deposit'
            : 'Bank Deposit';
      case model.TransactionType.withdrawal:
        return _withdrawalDestination == 'mobile_money'
            ? '${_mobileProvider.capitalize()} Money Withdrawal'
            : 'Withdrawal';
      case model.TransactionType.transfer:
        final String recipient = _phoneController.text.isNotEmpty ? 'to ${_phoneController.text}' : '';
        return 'Transfer $recipient';
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _processTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: customGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        _getButtonText(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getButtonText() {
    switch (_transactionType) {
      case model.TransactionType.save:
        return 'Save';
      case model.TransactionType.withdrawal:
        return 'Withdrawal';
      case model.TransactionType.transfer:
        return 'Transfer';
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    try {
      double amount = double.parse(value.replaceAll(',', ''));
      if (amount <= 0) {
        return 'Amount must be greater than 0';
      }
      if ((_transactionType == model.TransactionType.withdrawal || _transactionType == model.TransactionType.transfer) &&
          amount > widget.currentBalance) {
        return 'Insufficient balance';
      }
      if (amount < 500) {
        return 'Minimum transaction amount is UGX 500';
      }
      if (amount > 5000000) {
        return 'Maximum transaction amount is UGX 5,000,000';
      }
    } catch (e) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  String? _validateMobileNumber(String? value, model.TransactionType type) {
    if ((type == model.TransactionType.save && _depositSource == 'mobile_money' ||
            type == model.TransactionType.withdrawal && _withdrawalDestination == 'mobile_money') &&
        _mobileProvider.isNotEmpty &&
        (value == null || value.isEmpty)) {
      return 'Please enter a mobile money number';
    }
    if (value != null && value.isNotEmpty && !_isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  bool _isValidPhoneNumber(String number) {
    final RegExp phoneRegex = RegExp(r'^\d{9}$');
    return phoneRegex.hasMatch(number.replaceAll(' ', ''));
  }

  void _selectContact(TextEditingController controller) {
    setState(() {
      controller.text = '7${List.generate(8, (_) => (0 + Random().nextInt(9)).toString()).join()}';
    });
  }

  void _processTransaction() {
    if (_formKey.currentState!.validate()) {
      if (_transactionType == model.TransactionType.save &&
          _depositSource == 'mobile_money' &&
          _mobileProvider.isEmpty) {
        _showErrorDialog('Please select a mobile money provider');
        return;
      }
      if (_transactionType == model.TransactionType.withdrawal &&
          _withdrawalDestination == 'mobile_money' &&
          _mobileProvider.isEmpty) {
        _showErrorDialog('Please select a mobile money provider');
        return;
      }

      final transaction = model.TransactionModel(
        id: const Uuid().v4(),
        amount: _amount,
        date: DateTime.now(),
        type: _transactionType,
        description: _descriptionController.text.isEmpty
            ? _getDefaultDescription()
            : _descriptionController.text,
        userId: widget.userId,
        goalId: widget.goalId,
        depositSource: _transactionType == model.TransactionType.save ? _depositSource : null,
        withdrawalDestination: _transactionType == model.TransactionType.withdrawal ? _withdrawalDestination : null,
        mobileProvider: (_transactionType == model.TransactionType.save && _depositSource == 'mobile_money') ||
                (_transactionType == model.TransactionType.withdrawal && _withdrawalDestination == 'mobile_money')
            ? _mobileProvider
            : null,
        mobileMoneyNumber: _transactionType == model.TransactionType.save && _depositSource == 'mobile_money'
            ? _mobileMoneyNumberController.text
            : (_transactionType == model.TransactionType.withdrawal && _withdrawalDestination == 'mobile_money'
                ? _withdrawalMobileNumberController.text
                : null),
        transferRecipient: _transactionType == model.TransactionType.transfer ? _phoneController.text : null, source: '', category: '',
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      _executeTransactionWithRetry(transaction).then((_) {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();

        setState(() {
          _showAlert = true;
          _alertMessage =
              '${_transactionType.toString().split('.').last.capitalize()} Successful!';
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _showAlert = false);
            Navigator.of(context).pop(transaction);
          }
        });
      }).catchError((error) {
        // ignore: use_build_context_synchronously
        Navigator.of(context, rootNavigator: true).pop();
        _showErrorDialog('Transaction failed: ${error.toString()}');
      });
    }
  }

  Future<void> _executeTransactionWithRetry(model.TransactionModel transaction, {int retries = 2}) async {
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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