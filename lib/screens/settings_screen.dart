import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/providers/water_tracker_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _reminderIntervalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    final provider = Provider.of<WaterTrackerProvider>(context, listen: false);
    _goalController.text = provider.dailyGoal.toInt().toString();
    _reminderIntervalController.text = provider.reminderInterval.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<WaterTrackerProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Daily goal setting
                const Text(
                  'Daily Water Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Goal in mL',
                          border: OutlineInputBorder(),
                          suffixText: 'mL',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final goal = double.tryParse(_goalController.text);
                        if (goal != null && goal > 0) {
                          provider.setDailyGoal(goal);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Daily goal updated!')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Reminder settings
                const Text(
                  'Reminder Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Reminder interval
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _reminderIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Reminder interval (minutes)',
                          border: OutlineInputBorder(),
                          suffixText: 'minutes',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final interval = double.tryParse(_reminderIntervalController.text);
                        if (interval != null && interval > 0) {
                          provider.setReminderInterval(interval);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder interval updated!')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Reminder toggle
                SwitchListTile(
                  title: const Text('Enable Reminders'),
                  value: provider.remindersEnabled,
                  onChanged: (value) {
                    provider.setRemindersEnabled(value);
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Reminder start time
                ListTile(
                  title: const Text('Reminder Start Time'),
                  subtitle: Text('${provider.reminderStartTime.hour}:${provider.reminderStartTime.minute.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showTimePicker(context, provider);
                    },
                  ),
                ),
                
                // Reminder end time
                ListTile(
                  title: const Text('Reminder End Time'),
                  subtitle: Text('${provider.reminderEndTime.hour}:${provider.reminderEndTime.minute.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEndTimePicker(context, provider);
                    },
                  ),
                ),
                
                const Spacer(),
                
                // Reset all data
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showResetDialog(context, provider);
                    },
                    icon: const Icon(Icons.warning),
                    label: const Text('Reset All Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context, WaterTrackerProvider provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.reminderStartTime,
    );
    if (picked != null) {
      provider.setReminderStartTime(picked);
    }
  }

  void _showEndTimePicker(BuildContext context, WaterTrackerProvider provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.reminderEndTime,
    );
    if (picked != null) {
      provider.setReminderEndTime(picked);
    }
  }

  void _showResetDialog(BuildContext context, WaterTrackerProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Data'),
          content: const Text('This will reset all your water intake data and settings. This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.resetAllData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been reset!')),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    _reminderIntervalController.dispose();
    super.dispose();
  }
}