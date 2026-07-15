import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';

/// Settings menu (Module 4): the app's navigation drawer, giving access
/// to the planner, settings screen, and sign out.
class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: const Text('PlanU planner'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 34),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text('My Planner'),
            onTap: () => Navigator.of(context).pop(), // already on Home
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SettingsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false),
          ),
        ],
      ),
    );
  }
}
