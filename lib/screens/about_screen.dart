import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the theme color using your hex code
    final themeColor = const Color(0xFF8EB55D);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF8EB55D),
                backgroundImage: AssetImage('assets/images/mpc_logo.png'),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'SaveSmart Savings App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection('Developer', 'My People And Culture Association.', themeColor),
            _buildInfoSection('Contact', 'rehemamalole@gmail.com', themeColor),
            _buildInfoSection('Website', 'https://t.co/As4DUWlEU6', themeColor),
            const Divider(),
            _buildExpandableSection(
              'Release Notes',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('• Initial release'),
                  Text('• Basic savings tracking features'),
                  Text('• Budgeting tools'),
                  Text('• Goal setting functionality'),
                  Text('• Custom categories'),
                ],
              ),
              themeColor,
            ),
            _buildExpandableSection(
              'License Information',
              const Text(
                'This application is licensed under the MIT License. See below for details.\n\n'
                'MIT License\n\n'
                'Copyright (c) 2025 YourCompany\n\n'
                'Permission is hereby granted, free of charge, to any person obtaining a copy '
                'of this software and associated documentation files (the "Software"), to deal '
                'in the Software without restriction, including without limitation the rights '
                'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
                'copies of the Software, and to permit persons to whom the Software is '
                'furnished to do so, subject to the following conditions:\n\n'
                'The above copyright notice and this permission notice shall be included in all '
                'copies or substantial portions of the Software.',
              ),
              themeColor,
            ),
            _buildExpandableSection(
              'Open Source Acknowledgments',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('• Flutter - UI framework by Google'),
                  Text('• Provider - State management solution'),
                  Text('• Shared Preferences - Local storage'),
                  Text('• Http - API communication'),
                  Text('• Charts_flutter - Data visualization'),
                  SizedBox(height: 8),
                  Text(
                    'We are grateful to the open source community for making these libraries available.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              themeColor,
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {
                  // Open privacy policy
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(color: themeColor),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // Open terms of service
                },
                child: Text(
                  'Terms of Service',
                  style: TextStyle(color: themeColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
          Expanded(
            child: Text(content),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(String title, Widget content, Color themeColor) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: themeColor,
        ),
      ),
      iconColor: themeColor,
      collapsedIconColor: themeColor,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ],
    );
  }
}