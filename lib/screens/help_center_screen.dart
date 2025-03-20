import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const HelpCenterScreen({Key? key}) : super(key: key);

  // Define theme color using the hex value FF8EB55D
  static const Color themeColor = Color(0xFF8EB55D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: themeColor, // Changed from Colors.blue to themeColor
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHelpTile(
            'Searchable FAQ database',
            Icons.search,
            () => _navigateToSection(context, 'FAQ Database'),
          ),
          _buildHelpTile(
            'Tutorial guides',
            Icons.book,
            () => _navigateToSection(context, 'Tutorials'),
          ),
          _buildHelpTile(
            'Troubleshooting resources',
            Icons.build,
            () => _navigateToSection(context, 'Troubleshooting'),
          ),
          _buildHelpTile(
            'Common questions and answers',
            Icons.question_answer,
            () => _navigateToSection(context, 'Q&A'),
          ),
          _buildHelpTile(
            'Getting started guides',
            Icons.play_circle_fill,
            () => _navigateToSection(context, 'Getting Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: themeColor), // Changed from Colors.blue to themeColor
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _navigateToSection(BuildContext context, String section) {
    // Navigate to the specific help section
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $section'),
        backgroundColor: themeColor, // Added themed SnackBar
      ),
    );
  }
}