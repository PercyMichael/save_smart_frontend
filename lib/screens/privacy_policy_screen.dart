import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.green.shade600,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Data Collection Practices'),
          _buildPolicyText(
            'We collect minimal personal data necessary to provide our services. '
            'This includes account information, transaction details, and usage analytics. '
            'Location data is only collected when explicitly granted permission.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Data Storage'),
          _buildPolicyText(
            'Your information is stored securely using industry-standard encryption. '
            'Financial data is encrypted both in transit and at rest. '
            'Backups are regularly created and secured to prevent data loss.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Third-Party Sharing'),
          _buildPolicyText(
            'We do not sell your personal data to third parties. '
            'Data may be shared with service providers who help us deliver our services. '
            'All third parties must adhere to our strict data protection requirements.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Your Rights'),
          _buildPolicyText(
            'You have the right to access, correct, or delete your personal data. '
            'You can request a complete export of your data at any time. '
            'You may withdraw consent for optional data processing at any point.'
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('Cookies & Tracking'),
          _buildPolicyText(
            'We use cookies and similar technologies to improve your experience. '
            'Analytics help us understand how users interact with our app. '
            'You can manage cookie preferences in your settings.'
          ),
          const SizedBox(height: 24),
          
          _buildVersionInfo(),
        ],
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

  Widget _buildPolicyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Last Updated: March 1, 2025',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.2',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
            ),
            child: const Text('Download Full Privacy Policy'),
          ),
        ],
      ),
    );
  }
}