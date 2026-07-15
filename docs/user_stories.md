# User Stories — PlanU Planner App

All user stories for the PlanU planner app, written in Agile format with acceptance criteria. These stories guide the development of every screen and feature in this repository.

---

**US-1 — Account registration**
_As a user, I want to register with my name, email, and password, so that I can create an account and access the planner features._
Acceptance: all fields validated; password min 6 characters; success navigates to Login.
*(Implemented in `lib/screens/signup_screen.dart`)*

**US-2 — Account login**
_As a user, I want to log in using my email and password, so that only I can access my planner._
Acceptance: valid credentials open the Home screen; session lasts until sign out.
*(Implemented in `lib/screens/login_screen.dart`)*

**US-3 — Error feedback on login**
_As a user, I want to receive a message if I enter the wrong email or password, so that I know my login attempt was unsuccessful._
Acceptance: clear error shown for invalid credentials or missing account.
*(Implemented in `lib/screens/login_screen.dart`)*

**US-4 — Today at a glance**
_As a user, I want to see all my tasks on the home screen with a personalized welcome, so that I know what to focus on today._
Acceptance: tasks listed with title, time, priority flag, and category chip; empty state message when no tasks.
*(Implemented in `lib/screens/home_screen.dart`)*

**US-5 — Add a task**
_As a user, I want to add a task with a title, date, time, priority, and notes, so that I can plan my day._
Acceptance: title and date required; new task appears on Home immediately.
*(Implemented in `lib/screens/add_task_screen.dart`)*

**US-6 — Task details & completion**
_As a user, I want to tap a task to see its full details and mark it complete, so that I have context and can track progress._
Acceptance: detail screen shows all fields; completed tasks show strikethrough and sink to the bottom of the list.
*(Implemented in `lib/screens/detail_screen.dart`)*

**US-7 — Data persistence**
_As a user, I want my tasks and settings stored on the device, so that they persist when I close and reopen the app._
Acceptance: tasks, account, theme, and reminder settings survive app restart.
*(Implemented in `lib/services/storage_service.dart`)*

**US-8 — Upcoming holidays (API)**
_As a user, I want to see upcoming public holidays on my home screen, so that I can plan around days off._
Acceptance: holidays fetched live from the Nager.Date API with loading and error states handled.
*(Implemented in `lib/services/api_service.dart`)*

**US-9 — Settings & personalization**
_As a user, I want a settings menu and screen where I can switch dark mode and control reminders, so the app matches my preferences._
Acceptance: dark theme applies instantly and persists; reminder lead time configurable.
*(Implemented in `lib/widgets/settings_menu.dart` and `lib/screens/settings_screen.dart`)*

**US-10 — Task reminders (notifications)**
_As a user, I want a notification before a task is due, so that I never miss a deadline._
Acceptance: local notification fires at the configured lead time before the task; can be disabled globally.
*(Implemented in `lib/services/notification_service.dart`)*

**US-11 — Life areas in one view**
_As a user, I want to categorize my tasks as Personal, Work, or School and see them consolidated in a single planner view, so that my whole life is organized in one place._
Acceptance: every task carries a category shown as a colored chip; Home shows all categories together by default with filter chips for each area.
*(Implemented across `lib/models/task.dart`, `lib/screens/home_screen.dart`, `lib/screens/add_task_screen.dart`)*

---

## Future Roadmap
- Multi-account support: link separate personal, work, and school accounts and consolidate their tasks into one unified planner.
- Weekly progress reports with completion charts.
- Cloud sync across devices.
