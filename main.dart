// Planner App — Mobile App Development Capstone (Module 2)
// Login, Sign Up, Home, Add Task, Task Detail + navigation.
// Single file, no external packages — runs directly in DartPad (dartpad.dev).
// Data is in-memory for Module 2; persistence & API arrive in Module 3.

import 'package:flutter/material.dart';

void main() => runApp(const PlannerApp());

// ---------- Models ----------

enum Category { personal, work, school }

extension CategoryX on Category {
  String get label => switch (this) {
        Category.personal => 'Personal',
        Category.work => 'Work',
        Category.school => 'School',
      };
  Color get color => switch (this) {
        Category.personal => const Color(0xFF4C7A3D),
        Category.work => const Color(0xFFC87941),
        Category.school => const Color(0xFF3B6EA5),
      };
}

enum Priority { low, medium, high }

extension PriorityX on Priority {
  String get label => switch (this) {
        Priority.low => 'Low',
        Priority.medium => 'Medium',
        Priority.high => 'High',
      };
  Color get color => switch (this) {
        Priority.low => Colors.green,
        Priority.medium => Colors.orange,
        Priority.high => Colors.red,
      };
}

class Task {
  Task({
    required this.title,
    required this.date,
    required this.time,
    required this.priority,
    required this.category,
    this.notes = '',
    this.done = false,
  });

  String title;
  DateTime date;
  TimeOfDay time;
  Priority priority;
  Category category;
  String notes;
  bool done;
}

// ---------- Simple in-memory "backend" ----------

class AppState {
  static final AppState I = AppState._();
  AppState._();

  String? registeredName;
  String? registeredEmail;
  String? registeredPassword;

  final List<Task> tasks = [
    Task(
      title: 'Prepare supplier comparison sheet',
      date: DateTime.now(),
      time: const TimeOfDay(hour: 10, minute: 0),
      priority: Priority.high,
      category: Category.work,
      notes: 'Consolidate clarifications and update the Excel workbook.',
    ),
    Task(
      title: 'Gym — push day',
      date: DateTime.now(),
      time: const TimeOfDay(hour: 18, minute: 30),
      priority: Priority.medium,
      category: Category.personal,
    ),
    Task(
      title: 'Capstone Module 2 lab',
      date: DateTime.now(),
      time: const TimeOfDay(hour: 21, minute: 0),
      priority: Priority.high,
      category: Category.school,
      notes: 'Build screens, screenshot, push to GitHub.',
    ),
  ];
}

// ---------- App root ----------

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planner App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3B6EA5),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------- Login ----------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  void _login() {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;
    final s = AppState.I;
    if (s.registeredEmail == null) {
      setState(() => _error = 'No account found. Please sign up first.');
      return;
    }
    if (_email.text.trim() != s.registeredEmail ||
        _password.text != s.registeredPassword) {
      setState(() => _error = 'Incorrect email or password.');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.event_note, size: 64, color: Color(0xFF3B6EA5)),
                const SizedBox(height: 12),
                Text('Planner',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold)),
                Text('Your whole life in one place',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your password' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _login,
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Log In'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: const Text('New here? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Sign Up ----------

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    final s = AppState.I;
    s.registeredName = _name.text.trim();
    s.registeredEmail = _email.text.trim();
    s.registeredPassword = _password.text;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                      labelText: 'Name', border: OutlineInputBorder()),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password (min 6 characters)',
                      border: OutlineInputBorder()),
                  validator: (v) => v == null || v.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _signUp,
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Home ----------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? _filter; // null = All

  @override
  Widget build(BuildContext context) {
    final tasks = AppState.I.tasks
        .where((t) => _filter == null || t.category == _filter)
        .toList()
      ..sort((a, b) => a.done == b.done ? 0 : (a.done ? 1 : -1));
    final name = AppState.I.registeredName ?? 'there';
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $name'),
            Text('Today · ${now.day} ${months[now.month - 1]} ${now.year}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category filter chips (US-11: one consolidated planner)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
                const SizedBox(width: 8),
                for (final c in Category.values) ...[
                  ChoiceChip(
                    label: Text(c.label),
                    selected: _filter == c,
                    selectedColor: c.color.withOpacity(0.25),
                    onSelected: (_) => setState(() => _filter = c),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text('Nothing planned here yet.\nTap + to add a task.',
                        textAlign: TextAlign.center))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      final t = tasks[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        child: ListTile(
                          leading: Checkbox(
                            value: t.done,
                            onChanged: (v) =>
                                setState(() => t.done = v ?? false),
                          ),
                          title: Text(
                            t.title,
                            style: TextStyle(
                              decoration: t.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: t.category.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(t.category.label,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: t.category.color,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.flag,
                                  size: 14, color: t.priority.color),
                              const SizedBox(width: 3),
                              Text(t.time.format(context),
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: t)));
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddTaskScreen()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------- Add Task ----------

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Priority _priority = Priority.medium;
  Category _category = Category.personal;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    AppState.I.tasks.add(Task(
      title: _title.text.trim(),
      date: _date,
      time: _time,
      priority: _priority,
      category: _category,
      notes: _notes.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text('${_date.day}/${_date.month}/${_date.year}'),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => _date = d);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 16),
                      label: Text(_time.format(context)),
                      onPressed: () async {
                        final t = await showTimePicker(
                            context: context, initialTime: _time);
                        if (t != null) setState(() => _time = t);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Priority', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<Priority>(
                segments: [
                  for (final p in Priority.values)
                    ButtonSegment(value: p, label: Text(p.label)),
                ],
                selected: {_priority},
                onSelectionChanged: (s) =>
                    setState(() => _priority = s.first),
              ),
              const SizedBox(height: 18),
              Text('Category (US-11)',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<Category>(
                segments: [
                  for (final c in Category.values)
                    ButtonSegment(value: c, label: Text(c.label)),
                ],
                selected: {_category},
                onSelectionChanged: (s) =>
                    setState(() => _category = s.first),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _notes,
                maxLines: 4,
                decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Task Detail ----------

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(t.category.label),
                  backgroundColor: t.category.color.withOpacity(0.15),
                  labelStyle: TextStyle(color: t.category.color),
                ),
                Chip(
                  avatar: Icon(Icons.flag, size: 16, color: t.priority.color),
                  label: Text('${t.priority.label} priority'),
                ),
                Chip(
                  avatar: const Icon(Icons.access_time, size: 16),
                  label: Text(
                      '${t.date.day}/${t.date.month}/${t.date.year} · ${t.time.format(context)}'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(t.notes.isEmpty ? 'No notes for this task.' : t.notes),
            const Spacer(),
            FilledButton.icon(
              icon: Icon(t.done ? Icons.undo : Icons.check),
              label: Text(t.done ? 'Mark as Not Done' : 'Mark Complete'),
              onPressed: () => setState(() => t.done = !t.done),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}
