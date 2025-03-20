import 'package:flutter/material.dart';
import 'package:savesmart_app/services/transaction_service.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _currentBalance = 0;
  bool _isLoading = false;
  final String _userId = "user_main"; // This would come from your auth system
  // ignore: unused_field
  final Uuid _uuid = Uuid();
  String _selectedDestinationType = 'Mobile Money'; // Default value
  final List<String> _destinationTypes = ['Mobile Money', 'Bank Account', 'Cash'];

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      _currentBalance = await TransactionService.getWalletBalance();
    } catch (e) {
      debugPrint('Error loading balance: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      final description = _descriptionController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final destinationType = _selectedDestinationType;

      await TransactionService.addWithdrawal(
        amount,
        description.isNotEmpty ? description : "Withdrawal",
        _userId,
        phoneNumber,
        destinationType,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Withdrawal successful!'),
          backgroundColor: Colors.green,  // Green background
          behavior: SnackBarBehavior.floating,  // Makes it floating
          margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height - 100, 
            right: 20, 
            left: 20
          ),  // Positions near top
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            // ignore: use_build_context_synchronously
            bottom: MediaQuery.of(context).size.height - 100, 
            right: 20, 
            left: 20
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
        backgroundColor: const Color(0xFF8EB55D),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance: ${currencyFormat.format(_currentBalance)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) {
                            return newValue;
                          }
                          final number = int.parse(newValue.text.replaceAll(',', ''));
                          final formatted = NumberFormat('#,###').format(number);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: 'UGX ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.parse(value.replaceAll(',', ''));
                        if (amount <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        if (amount > _currentBalance) {
                          return 'Insufficient balance';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedDestinationType,
                      decoration: InputDecoration(
                        labelText: 'Withdrawal Method',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _destinationTypes.map((String destination) {
                        return DropdownMenuItem<String>(
                          value: destination,
                          child: Text(destination),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDestinationType = newValue!;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a destination type' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'e.g. 0750123456',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        // Add more validation as needed for phone numbers
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description / Recipient Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'e.g. Groceries, education, businesss',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _processWithdrawal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8EB55D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Withdraw',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}