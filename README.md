# Planner App — Mobile App Development Capstone

A clean, focused daily planner built with **Flutter** for the SkillUp EdTech Mobile App Development Capstone (UVW Code Labs project scenario).

The app lets users register and log in, plan their day with prioritized tasks, view task details, personalize the experience through settings, receive reminder notifications, and see upcoming public holidays fetched live from an external API.

---

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart) |
| Design | Figma (wireframes in `/docs`) |
| Local persistence | SharedPreferences / SQLite |
| External API | Nager.Date public-holidays API (no key required) |
| Notifications | flutter_local_notifications |
| Version control | Git + GitHub |

---

## User Stories

### Authentication
1. **US-01 — Register:** As a new user, I want to sign up with my name, email, and password so that my plans are saved under my own account.
   *Acceptance: empty fields blocked; invalid email format rejected; password minimum 6 characters; success navigates to Login.*
2. **US-02 — Log in:** As a returning user, I want to log in with my email and password so that only I can access my planner.
   *Acceptance: wrong credentials show an error message; success navigates to Home.*

### Core planning
3. **US-03 — Today at a glance:** As a user, I want to see all my tasks for today on the home screen so that I know what to focus on.
   *Acceptance: tasks listed with title, time, and priority color; empty state shows a friendly message.*
4. **US-04 — Add a task:** As a user, I want to add a task with a title, date, time, priority, and notes so that I can plan my day.
   *Acceptance: title and date are required; new task appears on Home immediately.*
5. **US-05 — Task details:** As a user, I want to tap a task to see its full details and notes so that I have context before starting it.
   *Acceptance: detail screen shows all fields; back navigation returns to Home.*
6. **US-06 — Complete a task:** As a user, I want to mark tasks complete so that I can track my progress.
   *Acceptance: completed tasks show strikethrough styling and move to the bottom of the list.*

### Persistence & live data
7. **US-07 — Data persistence:** As a user, I want my tasks stored on the device so that they persist when I close and reopen the app.
   *Acceptance: tasks survive app restart via local storage.*
8. **US-08 — Upcoming holidays (API):** As a user, I want to see upcoming public holidays on my home screen so that I can plan around days off.
   *Acceptance: holidays fetched live from the Nager.Date API; loading and error states handled gracefully.*

### Personalization & engagement
9. **US-09 — Settings:** As a user, I want a settings menu where I can switch between light and dark themes and set my default reminder time so the app matches my preferences.
   *Acceptance: theme change applies immediately and persists across restarts.*
10. **US-10 — Reminders:** As a user, I want a notification before a task is due so that I never miss a deadline.
    *Acceptance: a local notification fires at the scheduled reminder time.*

### Organization
11. **US-11 — Life areas in one view:** As a user, I want to categorize my tasks as Personal, Work, or School and see them consolidated in a single planner view so that my whole life is organized in one place.
    *Acceptance: every task carries a category; Home shows all categories together by default, each marked with a colored chip; filter chips let me view one category at a time; the category is visible on the Task Detail screen.*

---

## Future Roadmap

- Multi-account support: link separate personal, work, and school accounts and consolidate their tasks into one unified planner view.
- Cloud sync across devices.

---

## Screens (wireframed in Figma — see `/docs`)

1. Login
2. Sign Up
3. Home — today's tasks + upcoming holidays card + floating add button
4. Add / Edit Task
5. Task Detail
6. Settings

