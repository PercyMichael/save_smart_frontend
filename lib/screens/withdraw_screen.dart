import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  
  String _selectedAccount = "Main Savings";
  String _selectedWithdrawalMethod = "Mobile Money";
  double _fee = 0.0;
  bool _showConfirmation = false;
  
  // Sample data with Ugandan Shillings
  final Map<String, double> _accounts = {
    "Main Savings": 5000000.0,
    "Emergency Fund": 2500000.0,
    "Education Savings": 3000000.0,
  };
  
  final Map<String, double> _fees = {
    "Mobile Money": 3000.0,
    "Bank Transfer": 5000.0,
    "Cash Pickup": 2000.0,
  };

  @override
  void dispose() {
    _amountController.dispose();
    _phoneNumberController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  void _calculateFee() {
    setState(() {
      _fee = _fees[_selectedWithdrawalMethod] ?? 0.0;
    });
  }

  bool _validateAmount() {
    if (_amountController.text.isEmpty) return false;
    
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final availableBalance = _accounts[_selectedAccount] ?? 0.0;
    
    return amount > 0 && amount <= availableBalance && amount + _fee <= availableBalance;
  }

  Widget _buildAccountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Account",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedAccount,
              items: _accounts.keys.map((String account) {
                return DropdownMenuItem<String>(
                  value: account,
                  child: Text("$account (${_accounts[account]?.toStringAsFixed(0)} UGX)"),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedAccount = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Withdrawal Method",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedWithdrawalMethod,
              items: ["Mobile Money", "Bank Transfer", "Cash Pickup"].map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text("$method (Fee: ${_fees[method]?.toStringAsFixed(0)} UGX)"),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedWithdrawalMethod = newValue;
                    _calculateFee();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: "Amount to Withdraw (UGX)",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter an amount";
            }
            final amount = double.tryParse(value) ?? 0.0;
            final availableBalance = _accounts[_selectedAccount] ?? 0.0;
            
            if (amount <= 0) {
              return "Amount must be greater than 0";
            } else if (amount > availableBalance) {
              return "Amount exceeds available balance";
            } else if (amount + _fee > availableBalance) {
              return "Insufficient funds to cover amount plus fees";
            }
            return null;
          },
          onChanged: (_) {
            if (_showConfirmation) {
              setState(() {
                _showConfirmation = false;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        if (_selectedWithdrawalMethod == "Mobile Money") 
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter receiving phone number",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a phone number";
              }
              return null;
            },
          )
        else if (_selectedWithdrawalMethod == "Bank Transfer") 
          TextFormField(
            controller: _bankAccountController,
            decoration: const InputDecoration(
              labelText: "Bank Account Number",
              hintText: "Enter receiving bank account",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a bank account number";
              }
              return null;
            },
          )
        else 
          const Text(
            "Please visit any of our agent locations with your ID to collect your cash.",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  Widget _buildTransactionSummary() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final totalFee = _fee;
    final finalAmount = amount - totalFee;
    
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transaction Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Withdrawal Amount:"),
                Text("${amount.toStringAsFixed(0)} UGX", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Transaction Fee:"),
                Text("${totalFee.toStringAsFixed(0)} UGX"),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Amount to Receive:"),
                Text("${finalAmount.toStringAsFixed(0)} UGX", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Withdrawal Method:"),
                Text(_selectedWithdrawalMethod),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Processing Time:"),
                const Text("Instant to 24 hours"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculateFee();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw Funds"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAccountSelection(),
                const SizedBox(height: 16),
                _buildWithdrawalMethodSelection(),
                const SizedBox(height: 16),
                _buildWithdrawalDetails(),
                const SizedBox(height: 24),
                if (_validateAmount() && !_showConfirmation)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _showConfirmation = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Continue", style: TextStyle(fontSize: 16)),
                  ),
                if (_showConfirmation) ...[
                  const SizedBox(height: 16),
                  _buildTransactionSummary(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showConfirmation = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Edit", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Here you would process the withdrawal
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Withdrawal successful!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context); // Return to previous screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Confirm", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}