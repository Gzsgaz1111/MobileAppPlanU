import 'package:flutter/material.dart';
import '../main.dart';
import '../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';

/// Settings screen (Module 4): dark mode, notification toggle, and the
/// default reminder lead time. All values persist via StorageService.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  int _reminderMinutes = 15;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dark = await StorageService.getDarkMode();
    final notif = await StorageService.getNotificationsEnabled();
    final mins = await StorageService.getReminderMinutes();
    setState(() {
      _darkMode = dark;
      _notifications = notif;
      _reminderMinutes = mins;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark theme'),
            subtitle: const Text('Applies immediately and persists'),
            value: _darkMode,
            onChanged: (v) async {
              setState(() => _darkMode = v);
              await StorageService.setDarkMode(v);
              PlannerApp.themeNotifier.value =
                  v ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: const Text('Task reminders'),
            subtitle:
                const Text('Notify me before each planned task starts'),
            value: _notifications,
            onChanged: (v) async {
              setState(() => _notifications = v);
              await StorageService.setNotificationsEnabled(v);
              if (v) {
                await NotificationService.showTestNotification();
              } else {
                await NotificationService.cancelAll();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Remind me before'),
            trailing: DropdownButton<int>(
              value: _reminderMinutes,
              items: const [
                DropdownMenuItem(value: 5, child: Text('5 min')),
                DropdownMenuItem(value: 15, child: Text('15 min')),
                DropdownMenuItem(value: 30, child: Text('30 min')),
                DropdownMenuItem(value: 60, child: Text('1 hour')),
              ],
              onChanged: (v) async {
                if (v == null) return;
                setState(() => _reminderMinutes = v);
                await StorageService.setReminderMinutes(v);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('View stored data'),
            subtitle: const Text(
                'Shows the raw data persisted in local storage'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final buffer = StringBuffer();
              for (final key in prefs.getKeys()) {
                buffer.writeln('$key:\n${prefs.get(key)}\n');
              }
              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Local storage contents'),
                  content: SingleChildScrollView(
                      child: Text(buffer.isEmpty
                          ? 'No data stored yet.'
                          : buffer.toString(),
                          style: const TextStyle(fontSize: 12))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close')),
                  ],
                ),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text(
                'PlanU v1.0 — personal, work, and school in one planner.\nMobile App Development Capstone.'),
          ),
        ],
      ),
    );
  }
}
