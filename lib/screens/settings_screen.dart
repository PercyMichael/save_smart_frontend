import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:savesmart_app/provider/settings_provider.dart';
import 'package:savesmart_app/screens/about_screen.dart';
import 'package:savesmart_app/screens/app_lock_screen.dart';
import 'package:savesmart_app/screens/contact_support_screen.dart';
import 'package:savesmart_app/screens/data_sharing_screen.dart';
import 'package:savesmart_app/screens/default_deposit_amount_screen.dart';
import 'package:savesmart_app/screens/help_center_screen.dart';
import 'package:savesmart_app/screens/login_screen.dart'; // Add this import
import 'package:savesmart_app/screens/privacy_policy_screen.dart';
import 'package:savesmart_app/screens/send_feedback_screen.dart';
import 'package:savesmart_app/screens/terms_of_service_screen.dart';
import 'change_password_screen.dart';
import 'deposit_reminders_screen.dart';
import 'profile_information_screen.dart';
import 'saving_goals_screen.dart';

class SettingsScreen extends StatelessWidget {
  // Theme colors
  final Color primaryColor = const Color(0xFF8EB55D); // Green theme color
  final Color secondaryColor = Colors.white;

  // ignore: use_super_parameters
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            children: [
              _buildSectionHeader('Account Settings'),
              ListTile(
                leading: Icon(Icons.person, color: primaryColor),
                title: const Text('Profile Information'),
                subtitle: const Text('Edit your name, email, and phone number'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileInformationScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, color: primaryColor),
                title: const Text('Change Password/PIN'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                },
              ),
              SwitchListTile(
                secondary: Icon(Icons.notifications, color: primaryColor),
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: settingsProvider.notificationsEnabled,
                activeColor: primaryColor,
                onChanged: (bool value) {
                  settingsProvider.setNotificationsEnabled(value);
                },
              ),
              
              _buildSectionHeader('Savings Settings'),
              ListTile(
                leading: Icon(Icons.flag, color: primaryColor),
                title: const Text('Savings Goals'),
                subtitle: const Text('Manage your savings targets'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SavingGoalsScreen(currentBalance: 0, userId: '',)),
                  );
                },
              ),
              SwitchListTile(
                secondary: Icon(Icons.auto_awesome, color: primaryColor),
                title: const Text('Automatic Savings'),
                subtitle: const Text('Set rules for automatic deposits'),
                value: settingsProvider.automaticSavings,
                activeColor: primaryColor,
                onChanged: (bool value) {
                  settingsProvider.setAutomaticSavings(value);
                },
              ),
              ListTile(
                leading: Icon(Icons.alarm, color: primaryColor),
                title: const Text('Deposit Reminders'),
                subtitle: const Text('Set frequency for savings reminders'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DepositRemindersScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet, color: primaryColor),
                title: const Text('Default Deposit Amounts'),
                subtitle: const Text('Configure quick deposit options in UGX'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DefaultDepositAmountsScreen()),
                  );
                },
              ),
              
              _buildSectionHeader('Payment Methods'),
              ListTile(
                leading: Icon(Icons.phone_android, color: primaryColor),
                title: const Text('Mobile Money Provider'),
                subtitle: Text(settingsProvider.selectedMobileMoneyProvider),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  _showMobileMoneyProviderDialog(context, settingsProvider);
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
                subtitle: Text(settingsProvider.selectedLanguage),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  _showLanguageDialog(context, settingsProvider);
                },
              ),
              ListTile(
                leading: Icon(Icons.currency_exchange, color: primaryColor),
                title: const Text('Currency'),
                subtitle: Text('${settingsProvider.selectedCurrency} - Ugandan Shilling'),
                trailing: Icon(Icons.arrow_forward_ios, size:16, color: Colors.grey),
                enabled: false, // Disabled as we're only using UGX
              ),
              SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: primaryColor),
                title: const Text('Dark Mode'),
                value: settingsProvider.darkMode,
                activeColor: primaryColor,
                onChanged: (bool value) {
                  settingsProvider.setDarkMode(value);
                },
              ),
              SwitchListTile(
                secondary: Icon(Icons.volume_up, color: primaryColor),
                title: const Text('Sound Effects'),
                value: settingsProvider.soundEnabled,
                activeColor: primaryColor,
                onChanged: (bool value) {
                  settingsProvider.setSoundEnabled(value);
                  if (value) {
                    HapticFeedback.lightImpact();
                  }
                },
              ),
              
              _buildSectionHeader('Privacy & Security'),
              ListTile(
                leading: Icon(Icons.security, color: primaryColor),
                title: const Text('App Lock'),
                subtitle: const Text('Configure app lock settings'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppLockScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.policy, color: primaryColor),
                title: const Text('Privacy Policy'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: primaryColor),
                title: const Text('Terms of Service'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: primaryColor),
                title: const Text('Data Sharing'),
                subtitle: const Text('Manage how your data is shared'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataSharingScreen()),
                  );
                },
              ),
              
              _buildSectionHeader('Support'),
              ListTile(
                leading: Icon(Icons.help_center, color: primaryColor),
                title: const Text('Help Center'),
                subtitle: const Text('FAQs and guides'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCenterScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support, color: primaryColor),
                title: const Text('Contact Support'),
                subtitle: const Text('Get help via WhatsApp or call'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactSupportScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback, color: primaryColor),
                title: const Text('Send Feedback'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendFeedbackScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: primaryColor),
                title: const Text('About'),
                subtitle: const Text('App version 1.0.0'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              
              _buildSectionHeader('Account'),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: const Text('Sign Out'),
                onTap: () {
                  _showSignOutConfirmationDialog(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
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

  void _showLanguageDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Language', style: TextStyle(color: primaryColor)),
          backgroundColor: secondaryColor,
          children: <Widget>[
            _buildLanguageOption(context, settingsProvider, 'English'),
            _buildLanguageOption(context, settingsProvider, 'Swahili'),
            _buildLanguageOption(context, settingsProvider, 'Luganda'),
            _buildLanguageOption(context, settingsProvider, 'Runyankole'),
            _buildLanguageOption(context, settingsProvider, 'Acholi'),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, SettingsProvider settingsProvider, String language) {
    return SimpleDialogOption(
      onPressed: () {
        settingsProvider.setSelectedLanguage(language);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(language),
      ),
    );
  }

  void _showMobileMoneyProviderDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Mobile Money Provider', style: TextStyle(color: primaryColor)),
          backgroundColor: secondaryColor,
          children: <Widget>[
            _buildMobileMoneyOption(context, settingsProvider, 'MTN Mobile Money'),
            _buildMobileMoneyOption(context, settingsProvider, 'Airtel Money'),
          ],
        );
      },
    );
  }

  Widget _buildMobileMoneyOption(BuildContext context, SettingsProvider settingsProvider, String provider) {
    return SimpleDialogOption(
      onPressed: () {
        settingsProvider.setSelectedMobileMoneyProvider(provider);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(provider),
      ),
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sign Out', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Add your sign out logic here
                // For example:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}