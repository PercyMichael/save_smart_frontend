import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.green.shade600,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildIntroduction(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('User Agreement'),
          _buildTermsText(
            'By using Simple Saving, you agree to these Terms of Service. '
            'You must be at least 18 years old to use this app. '
            'You are responsible for maintaining the security of your account credentials.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Acceptable Use Policy'),
          _buildTermsText(
            'You agree not to use the app for any illegal activities. '
            'You will not attempt to bypass security measures or access unauthorized data. '
            'Automated access to the app is prohibited without express permission.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Account Termination'),
          _buildTermsText(
            'We reserve the right to terminate accounts that violate these terms. '
            'Accounts inactive for more than 12 months may be suspended. '
            'You can terminate your account at any time through account settings.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Intellectual Property'),
          _buildTermsText(
            'All content and code within the app is copyrighted material. '
            'The Simple Saving name and logo are protected trademarks. '
            'You may not reproduce or distribute app materials without permission.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Dispute Resolution'),
          _buildTermsText(
            'Any disputes will be resolved through arbitration. '
            'These terms are governed by applicable state laws. '
            'You agree to resolve disputes individually, not as part of a class action.'
          ),
          const SizedBox(height: 24),
          
          _buildAcceptanceButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: const Text(
        'Please read these Terms of Service carefully before using Simple Saving. These terms establish the rules for using our app and the relationship between you and Simple Saving Inc.',
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTermsText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildAcceptanceButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Last Updated: March 1, 2025',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of Service accepted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('I Accept These Terms'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Decline and Go Back'),
          ),
        ),
      ],
    );
  }
}