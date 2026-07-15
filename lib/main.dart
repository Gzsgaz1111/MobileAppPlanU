import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

/// PlanU — Mobile App Development Capstone (SkillUp EdTech).
/// App entry point: initializes notifications, restores the persisted
/// theme setting, and launches into the login flow.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final dark = await StorageService.getDarkMode();
  PlannerApp.themeNotifier.value =
      dark ? ThemeMode.dark : ThemeMode.light;
  runApp(const PlannerApp());
}

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  /// Settings screen flips this to apply the theme app-wide instantly.
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => MaterialApp(
        title: 'PlanU',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF3B6EA5)),
        darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: const Color(0xFF3B6EA5)),
        home: const LoginScreen(),
      ),
    );
  }
}
