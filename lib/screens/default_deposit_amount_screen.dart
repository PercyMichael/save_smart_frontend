import 'package:flutter/material.dart';

class DefaultDepositAmountsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const DefaultDepositAmountsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DefaultDepositAmountsScreenState createState() => _DefaultDepositAmountsScreenState();
}

class _DefaultDepositAmountsScreenState extends State<DefaultDepositAmountsScreen> {
  // Default deposit amount options in UGX
  List<int> depositAmounts = [5000, 10000, 20000, 50000, 100000];
  List<bool> isSelected = [false, true, false, true, false]; // Example of which are selected
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Setting item that leads to deposit amounts config
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.attach_money,
                color: Colors.green,
              ),
            ),
            title: const Text(
              'Default Deposit Amounts',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Configure quick deposit options in UGX',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: () {
              // Show the deposit amounts configuration dialog
              _showDepositAmountsDialog();
            },
          ),
          const Divider(),
          
          // Other settings can go here
        ],
      ),
    );
  }

  void _showDepositAmountsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Default Deposit Amounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select up to 3 amount options to display on the deposit screen',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      depositAmounts.length,
                      (index) => FilterChip(
                        label: Text('${depositAmounts[index]} UGX'),
                        selected: isSelected[index],
                        onSelected: (selected) {
                          // Count how many are currently selected
                          final selectedCount = isSelected.where((element) => element).length;
                          
                          // Allow deselection anytime, but limit to 3 selections
                          if (!selected || selectedCount < 3) {
                            setState(() {
                              isSelected[index] = selected;
                            });
                          } else {
                            // Show a message that limit is reached
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You can select up to 3 amount options'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        // ignore: deprecated_member_use
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        // ignore: deprecated_member_use
                        selectedColor: Colors.green.withOpacity(0.2),
                        checkmarkColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // Show dialog to add custom amount
                      _showAddCustomAmountDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: Colors.green, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Add custom amount',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save the selections and close the dialog
                        Navigator.pop(context);
                        
                        // Show confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Default deposit amounts updated'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCustomAmountDialog() {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Amount'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (UGX)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate and add the new amount
              if (amountController.text.isNotEmpty) {
                final newAmount = int.tryParse(amountController.text);
                if (newAmount != null && newAmount > 0) {
                  setState(() {
                    depositAmounts.add(newAmount);
                    isSelected.add(false);
                  });
                }
              }
              Navigator.pop(context);
            },
            // ignore: sort_child_properties_last
            child: const Text('Add'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}