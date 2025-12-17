import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerProvider with ChangeNotifier {
  static const String _dailyGoalKey = 'dailyGoal';
  static const String _currentIntakeKey = 'currentIntake';
  static const String _lastResetDateKey = 'lastResetDate';
  static const String _remindersEnabledKey = 'remindersEnabled';
  static const String _reminderIntervalKey = 'reminderInterval';
  static const String _reminderStartHourKey = 'reminderStartHour';
  static const String _reminderStartMinuteKey = 'reminderStartMinute';
  static const String _reminderEndHourKey = 'reminderEndHour';
  static const String _reminderEndMinuteKey = 'reminderEndMinute';

  double _dailyGoal = 2000.0; // Default: 2L
  double _currentIntake = 0.0;
  DateTime _lastResetDate = DateTime.now();
  bool _remindersEnabled = true;
  double _reminderInterval = 120.0; // Default: 2 hours
  TimeOfDay _reminderStartTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _reminderEndTime = const TimeOfDay(hour: 20, minute: 0);

  WaterTrackerProvider() {
    _loadFromPreferences();
    _checkDailyReset();
  }

  double get dailyGoal => _dailyGoal;
  double get currentIntake => _currentIntake;
  bool get remindersEnabled => _remindersEnabled;
  double get reminderInterval => _reminderInterval;
  TimeOfDay get reminderStartTime => _reminderStartTime;
  TimeOfDay get reminderEndTime => _reminderEndTime;

  void addWater(double amount) {
    _currentIntake += amount;
    _saveToPreferences();
    notifyListeners();
  }

  void resetDailyIntake() {
    _currentIntake = 0.0;
    _lastResetDate = DateTime.now();
    _saveToPreferences();
    notifyListeners();
  }

  void setDailyGoal(double goal) {
    _dailyGoal = goal;
    _saveToPreferences();
    notifyListeners();
  }

  void setRemindersEnabled(bool enabled) {
    _remindersEnabled = enabled;
    _saveToPreferences();
    notifyListeners();
  }

  void setReminderInterval(double interval) {
    _reminderInterval = interval;
    _saveToPreferences();
    notifyListeners();
  }

  void setReminderStartTime(TimeOfDay time) {
    _reminderStartTime = time;
    _saveToPreferences();
    notifyListeners();
  }

  void setReminderEndTime(TimeOfDay time) {
    _reminderEndTime = time;
    _saveToPreferences();
    notifyListeners();
  }

  void resetAllData() {
    _dailyGoal = 2000.0;
    _currentIntake = 0.0;
    _lastResetDate = DateTime.now();
    _remindersEnabled = true;
    _reminderInterval = 120.0;
    _reminderStartTime = const TimeOfDay(hour: 8, minute: 0);
    _reminderEndTime = const TimeOfDay(hour: 20, minute: 0);
    _saveToPreferences();
    notifyListeners();
  }

  void _checkDailyReset() {
    final now = DateTime.now();
    if (now.day != _lastResetDate.day || 
        now.month != _lastResetDate.month || 
        now.year != _lastResetDate.year) {
      resetDailyIntake();
    }
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    _dailyGoal = prefs.getDouble(_dailyGoalKey) ?? 2000.0;
    _currentIntake = prefs.getDouble(_currentIntakeKey) ?? 0.0;
    
    final lastResetMillis = prefs.getInt(_lastResetDateKey);
    if (lastResetMillis != null) {
      _lastResetDate = DateTime.fromMillisecondsSinceEpoch(lastResetMillis);
    }
    
    _remindersEnabled = prefs.getBool(_remindersEnabledKey) ?? true;
    _reminderInterval = prefs.getDouble(_reminderIntervalKey) ?? 120.0;
    
    final startHour = prefs.getInt(_reminderStartHourKey) ?? 8;
    final startMinute = prefs.getInt(_reminderStartMinuteKey) ?? 0;
    _reminderStartTime = TimeOfDay(hour: startHour, minute: startMinute);
    
    final endHour = prefs.getInt(_reminderEndHourKey) ?? 20;
    final endMinute = prefs.getInt(_reminderEndMinuteKey) ?? 0;
    _reminderEndTime = TimeOfDay(hour: endHour, minute: endMinute);
    
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setDouble(_dailyGoalKey, _dailyGoal);
    await prefs.setDouble(_currentIntakeKey, _currentIntake);
    await prefs.setInt(_lastResetDateKey, _lastResetDate.millisecondsSinceEpoch);
    await prefs.setBool(_remindersEnabledKey, _remindersEnabled);
    await prefs.setDouble(_reminderIntervalKey, _reminderInterval);
    await prefs.setInt(_reminderStartHourKey, _reminderStartTime.hour);
    await prefs.setInt(_reminderStartMinuteKey, _reminderStartTime.minute);
    await prefs.setInt(_reminderEndHourKey, _reminderEndTime.hour);
    await prefs.setInt(_reminderEndMinuteKey, _reminderEndTime.minute);
  }
}