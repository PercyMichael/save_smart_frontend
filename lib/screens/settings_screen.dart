import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Theme colors
  final Color primaryColor = const Color(0xFF8EB55D); // Green theme color
  final Color secondaryColor = Colors.white;

  // Settings variables
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _automaticSavings = true;
  String _selectedLanguage = 'English';
  final String _selectedCurrency = 'UGX';
  bool _darkMode = false;
  bool _soundEnabled = true;
  String _selectedMobileMoneyProvider = 'MTN Mobile Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account Settings'),
          ListTile(
            leading: Icon(Icons.person, color: primaryColor),
            title: const Text('Profile Information'),
            subtitle: const Text('Edit your name, email, and phone number'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to profile edit screen
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: primaryColor),
            title: const Text('Change Password/PIN'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to password change screen
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.fingerprint, color: primaryColor),
            title: const Text('Biometric Authentication'),
            subtitle: const Text('Use fingerprint or face recognition'),
            value: _biometricEnabled,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _biometricEnabled = value;
              });
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.notifications, color: primaryColor),
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: _notificationsEnabled,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          
          _buildSectionHeader('Savings Settings'),
          ListTile(
            leading: Icon(Icons.flag, color: primaryColor),
            title: const Text('Savings Goals'),
            subtitle: const Text('Manage your savings targets'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to savings goals screen
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.auto_awesome, color: primaryColor),
            title: const Text('Automatic Savings'),
            subtitle: const Text('Set rules for automatic deposits'),
            value: _automaticSavings,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _automaticSavings = value;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm, color: primaryColor),
            title: const Text('Deposit Reminders'),
            subtitle: const Text('Set frequency for savings reminders'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to reminders screen
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money, color: primaryColor),
            title: const Text('Default Deposit Amounts'),
            subtitle: const Text('Configure quick deposit options in UGX'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to default amounts screen
            },
          ),
          
          _buildSectionHeader('Payment Methods'),
          ListTile(
            leading: Icon(Icons.phone_android, color: primaryColor),
            title: const Text('Mobile Money Provider'),
            subtitle: Text(_selectedMobileMoneyProvider),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              _showMobileMoneyProviderDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance, color: primaryColor),
            title: const Text('Bank Account Settings'),
            subtitle: const Text('Connect your Ugandan bank account'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to bank account settings
            },
          ),
          
          _buildSectionHeader('App Preferences'),
          ListTile(
            leading: Icon(Icons.language, color: primaryColor),
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.currency_exchange, color: primaryColor),
            title: const Text('Currency'),
            // ignore: prefer_interpolation_to_compose_strings
            subtitle: Text(_selectedCurrency + ' - Ugandan Shilling'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            enabled: false, // Disabled as we're only using UGX
          ),
          SwitchListTile(
            secondary: Icon(Icons.dark_mode, color: primaryColor),
            title: const Text('Dark Mode'),
            value: _darkMode,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.volume_up, color: primaryColor),
            title: const Text('Sound Effects'),
            value: _soundEnabled,
            activeColor: primaryColor,
            onChanged: (bool value) {
              setState(() {
                _soundEnabled = value;
                if (value) {
                  HapticFeedback.lightImpact();
                }
              });
            },
          ),
          
          _buildSectionHeader('Privacy & Security'),
          ListTile(
            leading: Icon(Icons.security, color: primaryColor),
            title: const Text('App Lock'),
            subtitle: const Text('Configure app lock settings'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to app lock screen
            },
          ),
          ListTile(
            leading: Icon(Icons.policy, color: primaryColor),
            title: const Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Show privacy policy
            },
          ),
          ListTile(
            leading: Icon(Icons.description, color: primaryColor),
            title: const Text('Terms of Service'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Show terms of service
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: primaryColor),
            title: const Text('Data Sharing'),
            subtitle: const Text('Manage how your data is shared'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to data sharing settings
            },
          ),
          
          _buildSectionHeader('Support'),
          ListTile(
            leading: Icon(Icons.help_center, color: primaryColor),
            title: const Text('Help Center'),
            subtitle: const Text('FAQs and guides'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to help center
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support, color: primaryColor),
            title: const Text('Contact Support'),
            subtitle: const Text('Get help via WhatsApp or call'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to contact support form
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback, color: primaryColor),
            title: const Text('Send Feedback'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Navigate to feedback form
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: primaryColor),
            title: const Text('About'),
            subtitle: const Text('App version 1.0.0'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
            onTap: () {
              // Show about dialog
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Language', style: TextStyle(color: primaryColor)),
          backgroundColor: secondaryColor,
          children: <Widget>[
            _buildLanguageOption('English'),
            _buildLanguageOption('Swahili'),
            _buildLanguageOption('Luganda'),
            _buildLanguageOption('Runyankole'),
            _buildLanguageOption('Acholi'),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(language),
      ),
    );
  }

  void _showMobileMoneyProviderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Mobile Money Provider', style: TextStyle(color: primaryColor)),
          backgroundColor: secondaryColor,
          children: <Widget>[
            _buildMobileMoneyOption('MTN Mobile Money'),
            _buildMobileMoneyOption('Airtel Money'),
            _buildMobileMoneyOption('Africell Money'),
            _buildMobileMoneyOption('UTL M-Sente'),
          ],
        );
      },
    );
  }

  Widget _buildMobileMoneyOption(String provider) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedMobileMoneyProvider = provider;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(provider),
      ),
    );
  }
}