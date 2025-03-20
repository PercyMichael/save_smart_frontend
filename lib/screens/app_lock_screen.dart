import 'package:flutter/material.dart';

class AppLockScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const AppLockScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppLockScreenState createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool isPinEnabled = false;
  String selectedAutoLockTime = '1 minute';
  int maxAttempts = 3;
  bool isRecoveryEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Lock'),
        backgroundColor: Colors.green.shade600,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Configure how your app is secured',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable PIN/Password'),
            subtitle: const Text('Secure app access with a PIN or password'),
            value: isPinEnabled,
            onChanged: (value) {
              setState(() {
                isPinEnabled = value;
              });
              if (value) {
                _showPinSetupDialog();
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Auto-Lock Timing'),
            subtitle: Text('Lock after $selectedAutoLockTime of inactivity'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showAutoLockOptions(),
          ),
          const Divider(),
          ListTile(
            title: const Text('Failed Attempt Limitations'),
            subtitle: Text('App locks after $maxAttempts failed attempts'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showAttemptLimitOptions(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Recovery Options'),
            subtitle: const Text('Allow account recovery via email'),
            value: isRecoveryEnabled,
            onChanged: (value) {
              setState(() {
                isRecoveryEnabled = value;
              });
            },
          ),
          if (isRecoveryEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
                child: const Text('Set Recovery Email'),
              ),
            ),
        ],
      ),
    );
  }

  void _showPinSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN/Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter PIN',
                hintText: 'Min. 4 digits',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                hintText: 'Re-enter PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAutoLockOptions() {
    final options = ['Immediately', '30 seconds', '1 minute', '5 minutes', '10 minutes', 'Never'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-Lock Timing'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) => 
              RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAutoLockTime,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value != null) {
                    setState(() {
                      selectedAutoLockTime = value;
                    });
                  }
                },
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }

  void _showAttemptLimitOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Failed Attempt Limit'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Set maximum number of failed attempts before lockout:'),
              const SizedBox(height: 16),
              Slider(
                value: maxAttempts.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: maxAttempts.toString(),
                onChanged: (value) {
                  setState(() {
                    maxAttempts = value.round();
                  });
                },
              ),
              Text('$maxAttempts attempts', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ignore: unnecessary_this
              this.setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}