import 'package:flutter/material.dart';

class ReminderPreference {
  final String id;
  final String goalId;
  final String goalName;
  final String frequency;
  final String dayOfWeek;
  final TimeOfDay time;
  final String message;
  bool isEnabled;

  ReminderPreference({
    required this.id,
    required this.goalId,
    required this.goalName,
    required this.frequency,
    required this.dayOfWeek,
    required this.time,
    required this.message,
    this.isEnabled = true,
  });
}

class DepositRemindersScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const DepositRemindersScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DepositRemindersScreenState createState() => _DepositRemindersScreenState();
}

class _DepositRemindersScreenState extends State<DepositRemindersScreen> {
  // Sample data for demonstration
  final List<ReminderPreference> _reminders = [
    ReminderPreference(
      id: '1',
      goalId: '1',
      goalName: 'Vacation',
      frequency: 'Weekly',
      dayOfWeek: 'Monday',
      time: const TimeOfDay(hour: 9, minute: 0),
      message: 'Time to add to your vacation fund!',
    ),
    ReminderPreference(
      id: '2',
      goalId: '2',
      goalName: 'New Laptop',
      frequency: 'Monthly',
      dayOfWeek: '1st',
      time: const TimeOfDay(hour: 18, minute: 30),
      message: 'Add to your laptop savings this month',
    ),
    ReminderPreference(
      id: '3',
      goalId: '3',
      goalName: 'Emergency Fund',
      frequency: 'Daily',
      dayOfWeek: 'Every day',
      time: const TimeOfDay(hour: 20, minute: 0),
      message: 'Small daily deposits add up!',
      isEnabled: false,
    ),
  ];

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String _selectedFrequency = 'Weekly';
  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Reminders'),
        backgroundColor: const Color(0xFF8EB55D), // Updated theme color
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Global notification settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Enable All Reminders'),
                      subtitle: const Text('Turn on/off all deposit reminders'),
                      value: _notificationsEnabled,
                      activeColor: const Color(0xFF8EB55D), // Added theme color
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                          for (var reminder in _reminders) {
                            reminder.isEnabled = value;
                          }
                        });
                      },
                    ),
                    const Divider(),
                    const Text(
                      'Default Reminder Frequency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedFrequency,
                      items: _frequencies.map((String frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Text(frequency),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFrequency = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedFrequency == 'Weekly') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Day of Week',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedDay,
                        items: _daysOfWeek.map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDay = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ] else if (_selectedFrequency == 'Monthly') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Day of Month',
                          border: OutlineInputBorder(),
                        ),
                        value: '1st',
                        items: [
                          '1st',
                          '5th',
                          '10th',
                          '15th',
                          '20th',
                          '25th',
                          'Last day'
                        ].map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle day of month change
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      const Color(0xFF8EB55D), // Theme color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedTime.format(context),
                            ),
                            const Icon(Icons.access_time),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Notification Message',
                        border: OutlineInputBorder(),
                        hintText: 'Enter a custom reminder message',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF8EB55D), // Updated theme color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Default settings saved')),
                          );
                          // Add navigation back to the settings screen
                          Navigator.pop(context);
                        },
                        child: const Text('Save Default Settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Individual reminders section
            const Text(
              'Current Reminders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (_reminders.isEmpty) ...[
              const Center(
                child: Text(
                  'No reminders set up yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ] else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      title: Text(reminder.goalName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${reminder.frequency}: ${reminder.dayOfWeek} at ${reminder.time.format(context)}'),
                          Text(reminder.message),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Switch(
                        value: reminder.isEnabled,
                        activeColor:
                            const Color(0xFF8EB55D), // Added theme color
                        onChanged: (value) {
                          setState(() {
                            _reminders[index].isEnabled = value;
                          });
                        },
                      ),
                      onTap: () {
                        _showEditReminderDialog(context, reminder, index);
                      },
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 16),

            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add New Reminder'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8EB55D), // Added theme color
                ),
                onPressed: () {
                  _showAddReminderDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditReminderDialog(
      BuildContext context, ReminderPreference reminder, int index) {
    String frequency = reminder.frequency;
    String daySelection = reminder.dayOfWeek;
    TimeOfDay timeSelection = reminder.time;
    String message = reminder.message;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit ${reminder.goalName} Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        border: OutlineInputBorder(),
                      ),
                      value: frequency,
                      items: _frequencies.map((String freq) {
                        return DropdownMenuItem<String>(
                          value: freq,
                          child: Text(freq),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            frequency = newValue;
                            // Reset day selection based on frequency
                            if (frequency == 'Weekly') {
                              daySelection = _daysOfWeek.first;
                            } else if (frequency == 'Monthly') {
                              daySelection = '1st';
                            } else {
                              daySelection = 'Every day';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (frequency == 'Weekly') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Day of Week',
                          border: OutlineInputBorder(),
                        ),
                        value: _daysOfWeek.contains(daySelection)
                            ? daySelection
                            : _daysOfWeek.first,
                        items: _daysOfWeek.map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              daySelection = newValue;
                            });
                          }
                        },
                      ),
                    ] else if (frequency == 'Monthly') ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Day of Month',
                          border: OutlineInputBorder(),
                        ),
                        value: daySelection,
                        items: [
                          '1st',
                          '5th',
                          '10th',
                          '15th',
                          '20th',
                          '25th',
                          'Last day'
                        ].map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              daySelection = newValue;
                            });
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: timeSelection,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      const Color(0xFF8EB55D), // Theme color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          setState(() {
                            timeSelection = pickedTime;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeSelection.format(context)),
                            const Icon(Icons.access_time),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Notification Message',
                        border: OutlineInputBorder(),
                        hintText: 'Enter a custom reminder message',
                      ),
                      maxLines: 2,
                      controller: TextEditingController(text: message),
                      onChanged: (value) {
                        message = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  // ignore: sort_child_properties_last
                  child: const Text('Save'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8EB55D), // Theme color
                  ),
                  onPressed: () {
                    setState(() {
                      _reminders[index] = ReminderPreference(
                        id: reminder.id,
                        goalId: reminder.goalId,
                        goalName: reminder.goalName,
                        frequency: frequency,
                        dayOfWeek: daySelection,
                        time: timeSelection,
                        message: message,
                        isEnabled: reminder.isEnabled,
                      );
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminder updated')),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _showAddReminderDialog(BuildContext context) {}
}
