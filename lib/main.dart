import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/providers/water_tracker_provider.dart';
import 'package:water_tracker/screens/home_screen.dart';
import 'package:water_tracker/screens/settings_screen.dart';
import 'package:water_tracker/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  await NotificationService().init();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => WaterTrackerProvider(),
      child: const WaterTrackerApp(),
    ),
  );
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}