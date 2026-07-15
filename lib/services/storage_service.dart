import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Data persistence (Module 3): tasks, the registered user, and app
/// settings survive app restarts via SharedPreferences.
class StorageService {
  static const _kTasks = 'tasks';
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kPassword = 'user_password';
  static const _kDarkMode = 'dark_mode';
  static const _kNotifEnabled = 'notifications_enabled';
  static const _kReminderMinutes = 'reminder_minutes_before';

  // ---- Tasks ----
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kTasks, jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kTasks);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---- User account ----
  static Future<void> saveUser(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, name);
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kPassword, password);
  }

  static Future<Map<String, String?>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_kName),
      'email': prefs.getString(_kEmail),
      'password': prefs.getString(_kPassword),
    };
  }

  // ---- Profile (username, age, country from registration) ----
  static const _kUsername = 'user_username';
  static const _kAge = 'user_age';
  static const _kCountry = 'user_country';

  static Future<void> saveProfile(
      String username, int age, String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsername, username);
    await prefs.setInt(_kAge, age);
    await prefs.setString(_kCountry, country);
  }

  static Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_kUsername),
      'age': prefs.getInt(_kAge),
      'country': prefs.getString(_kCountry),
    };
  }

  // ---- Settings ----
  static Future<void> setDarkMode(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_kDarkMode, value);

  static Future<bool> getDarkMode() async =>
      (await SharedPreferences.getInstance()).getBool(_kDarkMode) ?? false;

  static Future<void> setNotificationsEnabled(bool value) async =>
      (await SharedPreferences.getInstance())
          .setBool(_kNotifEnabled, value);

  static Future<bool> getNotificationsEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_kNotifEnabled) ??
      true;

  static Future<void> setReminderMinutes(int minutes) async =>
      (await SharedPreferences.getInstance())
          .setInt(_kReminderMinutes, minutes);

  static Future<int> getReminderMinutes() async =>
      (await SharedPreferences.getInstance()).getInt(_kReminderMinutes) ??
      15;
}
