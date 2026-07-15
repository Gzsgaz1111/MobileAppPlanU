# PlanU — Planner App (Mobile App Development Capstone)

A Flutter planner app that brings your **personal, work, and school life into one consolidated planner** — with login, task management, local persistence, a live public-holidays API feed, dark mode, and task reminders.

Built for the SkillUp EdTech **Mobile App Development Capstone** (UVW Code Labs scenario).

## Repository guide

| Deliverable | File |
|---|---|
| User stories (11, with acceptance criteria) | [`docs/user_stories.md`](docs/user_stories.md) |
| Sign-up implementation | [`lib/screens/signup_screen.dart`](lib/screens/signup_screen.dart) |
| Login implementation | [`lib/screens/login_screen.dart`](lib/screens/login_screen.dart) |
| Home screen (consolidated planner + API card) | [`lib/screens/home_screen.dart`](lib/screens/home_screen.dart) |
| Detail screen | [`lib/screens/detail_screen.dart`](lib/screens/detail_screen.dart) |
| Add-task screen | [`lib/screens/add_task_screen.dart`](lib/screens/add_task_screen.dart) |
| API integration (Nager.Date public holidays) | [`lib/services/api_service.dart`](lib/services/api_service.dart) |
| Data persistence (SharedPreferences) | [`lib/services/storage_service.dart`](lib/services/storage_service.dart) |
| Settings menu (navigation drawer) | [`lib/widgets/settings_menu.dart`](lib/widgets/settings_menu.dart) |
| Settings screen (dark mode, reminders) | [`lib/screens/settings_screen.dart`](lib/screens/settings_screen.dart) |
| Notifications (flutter_local_notifications) | [`lib/services/notification_service.dart`](lib/services/notification_service.dart) |
| App entry point & theming | [`lib/main.dart`](lib/main.dart) |

## Tech stack
Flutter (Dart) · SharedPreferences · http · flutter_local_notifications · Figma wireframes · GitHub

## Running the app
```
flutter pub get
flutter run
```
