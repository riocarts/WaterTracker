import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/providers/water_tracker_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Consumer<WaterTrackerProvider>(
        builder: (context, provider, child) {
          final dailyGoal = provider.dailyGoal;
          final currentIntake = provider.currentIntake;
          final progress = currentIntake / dailyGoal;
          
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress indicator
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 15.0,
                  percent: progress > 1.0 ? 1.0 : progress,
                  center: Text(
                    '${currentIntake.toInt()} / ${dailyGoal.toInt()} mL',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.blue,
                  backgroundColor: Colors.blue.shade100,
                ),
                
                const SizedBox(height: 40),
                
                // Water intake buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWaterButton(250, '250 mL'),
                    _buildWaterButton(500, '500 mL'),
                    _buildWaterButton(1000, '1 L'),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Custom amount input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Custom amount (mL)',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            final amount = double.tryParse(value);
                            if (amount != null && amount > 0) {
                              provider.addWater(amount);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final controller = context.findAncestorStateOfType<_HomeScreenState>()?._customAmountController;
                        if (controller != null && controller.text.isNotEmpty) {
                          final amount = double.tryParse(controller.text);
                          if (amount != null && amount > 0) {
                            provider.addWater(amount);
                            controller.clear();
                          }
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Reset button
                ElevatedButton.icon(
                  onPressed: () {
                    provider.resetDailyIntake();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Today'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaterButton(double amount, String label) {
    return Consumer<WaterTrackerProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: () {
            provider.addWater(amount);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            backgroundColor: Colors.blue.shade50,
            foregroundColor: Colors.blue.shade800,
          ),
          child: Column(
            children: [
              Icon(Icons.local_drink, size: 30, color: Colors.blue.shade600),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
  
  final TextEditingController _customAmountController = TextEditingController();
  
  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }
}