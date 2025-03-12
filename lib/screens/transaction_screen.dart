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
  bool _isDeposit = true;
  final int _currentBalance = 100000; 
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final NumberFormat currencyFormat = NumberFormat('#,###');
  final Color customGreen = const Color(0xFF8EB55D); // Updated custom green color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        backgroundColor: customGreen, // Updated color
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
                onTap: () => setState(() => _isDeposit = true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDeposit ? customGreen : Colors.grey[200], // Updated color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Deposit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isDeposit ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isDeposit = false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !_isDeposit ? customGreen : Colors.grey[200], // Updated color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Withdraw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: !_isDeposit ? Colors.white : Colors.black,
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
                  if (!_isDeposit && amount > _currentBalance) {
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction successful'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: customGreen, // Updated button color
      ),
      child: Text(
        '${_isDeposit ? "Save" : "Withdraw"} UGX ${currencyFormat.format(_amount)}',
        style: const TextStyle(fontSize: 18),
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
        side: BorderSide(color: customGreen), // Updated border color
      ),
    );
  }
}
