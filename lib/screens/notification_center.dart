import 'package:flutter/material.dart';

// Data model for notifications
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  savingsGoal,      // For savings goals achievements and updates
  budgetAlert,      // For budget-related notifications
  savingsDeposit,   // For successful savings deposits
  savingsTip,       // For savings tips and recommendations
  interestEarned,   // For interest earned notifications
  monthlyReport     // For monthly savings summaries
}

class NotificationCenter extends StatefulWidget {
  // ignore: use_super_parameters
  const NotificationCenter({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Savings Goal Achievement! 🎯',
      message: 'Congratulations! You\'ve reached 50% of your Emergency Fund goal',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.savingsGoal,
    ),
    NotificationItem(
      id: '2',
      title: 'New Savings Deposit 💰',
      message: 'Successfully saved \$200 towards your Vacation Fund',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.savingsDeposit,
    ),
    NotificationItem(
      id: '3',
      title: 'Budget Alert ⚠️',
      message: 'You\'ve reached 80% of your monthly spending limit',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.budgetAlert,
    ),
    NotificationItem(
      id: '4',
      title: 'Interest Earned! ✨',
      message: 'You earned \$15.50 in interest this month',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: NotificationType.interestEarned,
    ),
  ];

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.savingsGoal:
        return Colors.green;
      case NotificationType.budgetAlert:
        return Colors.orange;
      case NotificationType.savingsDeposit:
        return Colors.blue;
      case NotificationType.savingsTip:
        return Colors.purple;
      case NotificationType.interestEarned:
        return Colors.teal;
      case NotificationType.monthlyReport:
        return Colors.indigo;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.savingsGoal:
        return Icons.emoji_events;
      case NotificationType.budgetAlert:
        return Icons.warning_amber;
      case NotificationType.savingsDeposit:
        return Icons.savings;
      case NotificationType.savingsTip:
        return Icons.lightbulb;
      case NotificationType.interestEarned:
        return Icons.trending_up;
      case NotificationType.monthlyReport:
        return Icons.analytics;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaveSmart Updates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: Color.fromARGB(255, 235, 234, 234),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'Start saving to see updates here!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },
                  child: Card(
                    elevation: notification.isRead ? 1 : 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getNotificationColor(notification.type).withAlpha(51),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight:
                              notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          Text(
                            _getTimeAgo(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          notification.isRead = true;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(notification.title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.message),
                                const SizedBox(height: 16),
                                if (notification.type == NotificationType.monthlyReport)
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('View Full Report'),
                                  ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}