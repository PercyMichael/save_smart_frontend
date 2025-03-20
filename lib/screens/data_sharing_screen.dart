import 'package:flutter/material.dart';

class DataSharingScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const DataSharingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DataSharingScreenState createState() => _DataSharingScreenState();
}

class _DataSharingScreenState extends State<DataSharingScreen> {
  bool analyticsSharing = true;
  bool marketingEmails = false;
  bool thirdPartyIntegration = true;
  List<String> connectedAccounts = ['Banking App', 'Budget Tracker'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sharing'),
        backgroundColor: Colors.green.shade600,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Manage how your data is shared with us and third parties',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Divider(),
          
          // Analytics sharing
          SwitchListTile(
            title: const Text('Analytics Sharing'),
            subtitle: const Text('Share anonymous usage data to help improve the app'),
            value: analyticsSharing,
            onChanged: (value) {
              setState(() {
                analyticsSharing = value;
              });
            },
          ),
          
          const Divider(),
          
          // Marketing preferences
          SwitchListTile(
            title: const Text('Marketing Communications'),
            subtitle: const Text('Receive emails about new features and offers'),
            value: marketingEmails,
            onChanged: (value) {
              setState(() {
                marketingEmails = value;
              });
            },
          ),
          
          const Divider(),
          
          // Third-party integrations
          SwitchListTile(
            title: const Text('Third-Party Integrations'),
            subtitle: const Text('Allow connections with external services'),
            value: thirdPartyIntegration,
            onChanged: (value) {
              setState(() {
                thirdPartyIntegration = value;
              });
              if (!value) {
                _showDisconnectWarning();
              }
            },
          ),
          
          if (thirdPartyIntegration) _buildConnectedAccounts(),
          
          const Divider(),
          
          // Data export options
          ListTile(
            title: const Text('Export Your Data'),
            subtitle: const Text('Download a copy of all your data'),
            leading: const Icon(Icons.download),
            onTap: () => _showDataExportOptions(),
          ),
          
          const Divider(),
          
          // Account linking
          ListTile(
            title: const Text('Account Linking Settings'),
            subtitle: const Text('Manage connections to other accounts'),
            leading: const Icon(Icons.link),
            onTap: () => _navigateToAccountLinking(),
          ),
          
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data sharing preferences saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save Preferences'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Center(
            child: TextButton(
              onPressed: () => _showDataDeletionDialog(),
              child: const Text(
                'Delete All My Data',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedAccounts() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Connected Accounts',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          ...connectedAccounts.map((account) => 
            Card(
              child: ListTile(
                title: Text(account),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      connectedAccounts.remove(account);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$account disconnected'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text('Disconnect'),
                ),
              ),
            ),
          // ignore: unnecessary_to_list_in_spreads
          ).toList(),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Connect New Account'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showDisconnectWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: const Text(
          'Disabling third-party integrations will disconnect all your linked accounts. '
          'This may affect functionality in the app.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                thirdPartyIntegration = true;
              });
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                connectedAccounts = [];
              });
            },
            child: const Text('Disconnect All'),
          ),
        ],
      ),
    );
  }

  void _showDataExportOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Your Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose export format:'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('CSV Format'),
              subtitle: const Text('Spreadsheet compatible'),
              leading: const Icon(Icons.table_chart),
              onTap: () {
                Navigator.pop(context);
                _initiateExport('CSV');
              },
            ),
            ListTile(
              title: const Text('JSON Format'),
              subtitle: const Text('Machine readable'),
              leading: const Icon(Icons.data_object),
              onTap: () {
                Navigator.pop(context);
                _initiateExport('JSON');
              },
            ),
            ListTile(
              title: const Text('PDF Report'),
              subtitle: const Text('Human readable summary'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () {
                Navigator.pop(context);
                _initiateExport('PDF');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initiateExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preparing $format export. You will be notified when ready.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _navigateToAccountLinking() {
    // This would navigate to another screen in a real app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account linking screen would open here'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDataDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently removed from our servers. '
          'Are you sure you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDataDeletion();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDataDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please type "DELETE" to confirm you want to permanently remove all your data:',
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type DELETE here',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}