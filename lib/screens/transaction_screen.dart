import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  int _amount = 0;  
  // ignore: unused_field
  String _description = '';
  String _transactionType = 'deposit'; // Changed to string for three options
  String _depositSource = 'mobile_money'; // Default deposit source
  String _withdrawalDestination = 'mobile_money'; // Default withdrawal destination
  String _mobileProvider = ''; // MTN or Airtel
  final int _currentBalance = 100000; 
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileMoneyNumberController = TextEditingController();
  final TextEditingController _withdrawalMobileNumberController = TextEditingController();
  
  final NumberFormat currencyFormat = NumberFormat('#,###');
  final Color customGreen = const Color(0xFF8EB55D); // Updated custom green color
  
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
                if (_transactionType == 'transfer')
                  _buildPhoneInput(),
                if (_transactionType == 'deposit')
                  _buildDepositSourceInput(),
                if (_transactionType == 'withdraw')
                  _buildWithdrawalDestinationInput(),
                if (_transactionType == 'deposit' && _depositSource == 'mobile_money')
                  _buildMobileProviderInput(),
                if (_transactionType == 'withdraw' && _withdrawalDestination == 'mobile_money')
                  _buildWithdrawalMobileProviderInput(),
                if (_transactionType == 'deposit' && _depositSource == 'mobile_money' && _mobileProvider.isNotEmpty)
                  _buildMobileNumberInput(),
                if (_transactionType == 'withdraw' && _withdrawalDestination == 'mobile_money' && _mobileProvider.isNotEmpty)
                  _buildWithdrawalMobileNumberInput(),
                if (_transactionType == 'transfer' || _transactionType == 'deposit' || _transactionType == 'withdraw')
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
              'UGX ${currencyFormat.format(_currentBalance)}',
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
                onTap: () => setState(() => _transactionType = 'deposit'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == 'deposit' ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Deposit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == 'deposit' ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = 'withdraw'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == 'withdraw' ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Withdraw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == 'withdraw' ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _transactionType = 'transfer'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _transactionType == 'transfer' ? customGreen : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _transactionType == 'transfer' ? Colors.white : Colors.black,
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
                if (_transactionType == 'deposit' && _depositSource == 'mobile_money' && 
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
                if (_transactionType == 'withdraw' && _withdrawalDestination == 'mobile_money' && 
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
                  int amount = int.parse(value.replaceAll(',', ''));
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  if ((_transactionType == 'withdraw' || _transactionType == 'transfer') && amount > _currentBalance) {
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
                    _amount = int.tryParse(numericValue) ?? 0;
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
                if (_transactionType == 'transfer' && (value == null || value.isEmpty)) {
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
      String buttonText;
      switch (_transactionType) {
        case 'deposit':
          buttonText = 'Deposit';
          break;
        case 'withdraw':
          buttonText = 'Withdrawal';
          break;
        case 'transfer':
          buttonText = 'Transfer';
          break;
        default:
          buttonText = 'Transaction';
      }
      
      // Show the alert in the app bar
      setState(() {
        _alertMessage = '$buttonText successful';
        _showAlert = true;
      });
      
      // Wait briefly to show the success message before navigating back
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Navigate back to home screen with a success result
          Navigator.of(context).pop({
            'success': true,
            'type': _transactionType,
            'amount': _amount,
            'phone': _transactionType == 'transfer' ? _phoneController.text : '',
            'depositSource': _transactionType == 'deposit' ? _depositSource : '',
            'withdrawalDestination': _transactionType == 'withdraw' ? _withdrawalDestination : '',
            'mobileProvider': (_depositSource == 'mobile_money' || _withdrawalDestination == 'mobile_money') ? _mobileProvider : '',
            'mobileMoneyNumber': _depositSource == 'mobile_money' && _mobileProvider.isNotEmpty ? 
                _mobileMoneyNumberController.text : '',
            'withdrawalMobileNumber': _withdrawalDestination == 'mobile_money' && _mobileProvider.isNotEmpty ? 
                _withdrawalMobileNumberController.text : '',
            'description': _description,
          });
        }
      });
    }
  }

  Widget _buildSubmitButton() {
    String buttonText;
    switch (_transactionType) {
      case 'deposit':
        buttonText = 'Save';
        break;
      case 'withdraw':
        buttonText = 'Withdraw';
        break;
      case 'transfer':
        buttonText = 'Transfer';
        break;
      default:
        buttonText = 'Save';
    }

    return ElevatedButton(
      onPressed: _processTransaction,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: customGreen,
      ),
      child: Text(
        '$buttonText UGX ${currencyFormat.format(_amount)}',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _quickAmountButton(int amount) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _amount = amount;
          _amountController.text = currencyFormat.format(amount);
        });
      },
      // ignore: sort_child_properties_last
      child: Text(currencyFormat.format(amount)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: customGreen),
      ),
    );
  }
}