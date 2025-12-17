import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications and timezone data
  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  /// Schedule daily reminders between [startTime] and [endTime] with [intervalMinutes]
  Future<void> scheduleDailyReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required double intervalMinutes,
  }) async {
    // Cancel existing notifications
    await _notifications.cancelAll();

    final now = tz.TZDateTime.now(tz.local);

    final startDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    final endDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    // Schedule from tomorrow if start time has passed
    final actualStartTime = startDateTime.isBefore(now)
        ? startDateTime.add(const Duration(days: 1))
        : startDateTime;

    final totalMinutes = endDateTime.difference(actualStartTime).inMinutes;
    final numberOfReminders = (totalMinutes / intervalMinutes).floor();

    for (int i = 0; i < numberOfReminders; i++) {
      final reminderTime = actualStartTime.add(
        Duration(minutes: (intervalMinutes * i).round()),
      );

      await _notifications.zonedSchedule(
        i,
        '💧 Time to hydrate!',
        'Remember to drink water to stay healthy and hydrated!',
        reminderTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder_channel',
            'Water Reminders',
            channelDescription: 'Reminders to drink water throughout the day',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required
        matchDateTimeComponents: DateTimeComponents.time, // Optional, for recurring daily reminders
      );
    }
  }

  /// Cancel all scheduled reminders
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  /// Show a test notification immediately
  Future<void> showTestNotification() async {
    await _notifications.show(
      999,
      'Water Tracker Test',
      'Notifications are working correctly!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminders',
          channelDescription: 'Reminders to drink water throughout the day',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
        ),
      ),
    );
  }
}
