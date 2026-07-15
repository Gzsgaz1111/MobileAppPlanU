import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
// Our Task model also defines a `Priority` enum, which clashes with the
// plugin's `Priority` class - hide ours here since this file doesn't use it.
import '../models/task.dart' hide Priority;
import 'storage_service.dart';

/// Notifications (Module 4/5): schedules a local reminder before each
/// task's start time using flutter_local_notifications.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (kIsWeb) return; // local notifications unsupported on web preview
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    await _plugin.initialize(const InitializationSettings(
        android: androidInit, iOS: iosInit));
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _initialized = true;
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'planu_reminders',
      'Task reminders',
      channelDescription: 'Reminders before your planned tasks start',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Schedules a reminder N minutes (user setting) before the task time.
  static Future<void> scheduleTaskReminder(Task task, int id) async {
    if (kIsWeb) return;
    final enabled = await StorageService.getNotificationsEnabled();
    if (!enabled) return;
    await init();

    final minutesBefore = await StorageService.getReminderMinutes();
    final taskDateTime = DateTime(task.date.year, task.date.month,
        task.date.day, task.hour, task.minute);
    final fireAt =
        taskDateTime.subtract(Duration(minutes: minutesBefore));
    if (fireAt.isBefore(DateTime.now())) return; // never schedule in past

    await _plugin.zonedSchedule(
      id,
      'Upcoming: ${task.title}',
      '${task.category.label} task starts in $minutesBefore minutes',
      tz.TZDateTime.from(fireAt, tz.local),
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  /// Immediate test notification, used from the Settings screen.
  static Future<void> showTestNotification() async {
    if (kIsWeb) return;
    await init();
    await _plugin.show(0, 'PlanU reminders are on',
        'You will be reminded before each planned task.', _details);
  }
}
