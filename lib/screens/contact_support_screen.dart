import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const ContactSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(
            'Support Hours',
            'Monday to Friday: 9 AM - 6 PM\nWeekends: 10 AM - 4 PM',
            Icons.access_time,
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            'WhatsApp Support',
            'Chat with our support team',
            Icons.chat, // Changed from Icons.whatsapp to Icons.chat
            Colors.green,
            () => _launchWhatsApp(context),
          ),
          _buildContactOption(
            'Phone Support',
            'Call our support line',
            Icons.phone,
            Colors.blue,
            () => _launchPhone(context),
          ),
          _buildContactOption(
            'Submit a Ticket',
            'Get help via email',
            Icons.email,
            Colors.orange,
            () => _navigateToTicketForm(context),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Expected Response Times',
            'WhatsApp: Within 1 hour\nPhone: Immediate\nTickets: Within 24 hours',
            Icons.hourglass_bottom,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _launchWhatsApp(BuildContext context) {
    // Launch WhatsApp with predefined number
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Launching WhatsApp support')),
    );
    // In a real app, you'd use url_launcher to open WhatsApp
    // launchUrl(Uri.parse('https://wa.me/1234567890'));
  }

  void _launchPhone(BuildContext context) {
    // Launch phone dialer with support number
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Launching phone dialer')),
    );
    // In a real app, you'd use url_launcher to open phone
    // launchUrl(Uri.parse('tel:1234567890'));
  }

  void _navigateToTicketForm(BuildContext context) {
    // Navigate to ticket submission form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening ticket submission form')),
    );
  }
}