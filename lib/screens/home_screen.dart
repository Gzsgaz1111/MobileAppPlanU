import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../widgets/settings_menu.dart';
import 'add_task_screen.dart';
import 'detail_screen.dart';

/// Home (Module 2/3): the consolidated planner. Shows tasks from all
/// life areas in one list (US-11) with category filter chips, loads
/// persisted tasks, and fetches upcoming holidays from the API.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  Category? _filter; // null = All
  String _userName = 'there';
  List<Holiday>? _holidays;
  String? _holidayError;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    final tasks = await StorageService.loadTasks();
    final user = await StorageService.loadUser();
    setState(() {
      _tasks = tasks;
      _userName = user['name'] ?? 'there';
    });
    try {
      final holidays =
          await ApiService.fetchUpcomingHolidays(countryCode: 'US');
      setState(() => _holidays = holidays);
    } catch (e) {
      setState(() => _holidayError = 'Could not load holidays');
    }
  }

  Future<void> _persist() => StorageService.saveTasks(_tasks);

  @override
  Widget build(BuildContext context) {
    final visible = _tasks
        .where((t) => _filter == null || t.category == _filter)
        .toList()
      ..sort((a, b) => a.done == b.done ? 0 : (a.done ? 1 : -1));
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    return Scaffold(
      drawer: SettingsMenu(userName: _userName),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $_userName'),
            Text('Today · ${now.day} ${months[now.month - 1]} ${now.year}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadEverything,
        child: ListView(
          children: [
            _holidaysCard(),
            _filterChips(),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text('Nothing planned here yet.\nTap + to add a task.',
                    textAlign: TextAlign.center),
              )
            else
              for (final t in visible) _taskTile(t),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await Navigator.of(context).push<Task>(
              MaterialPageRoute(builder: (_) => const AddTaskScreen()));
          if (task != null) {
            setState(() => _tasks.add(task));
            await _persist();
            await NotificationService.scheduleTaskReminder(
                task, _tasks.length);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---- pieces ----

  Widget _holidaysCard() {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.celebration, size: 18),
              const SizedBox(width: 6),
              Text('Upcoming public holidays',
                  style: Theme.of(context).textTheme.titleSmall),
            ]),
            const SizedBox(height: 6),
            if (_holidayError != null)
              Text(_holidayError!,
                  style: const TextStyle(color: Colors.red))
            else if (_holidays == null)
              const LinearProgressIndicator()
            else
              for (final h in _holidays!)
                Text('· ${h.date.day}/${h.date.month} — ${h.name}'),
          ],
        ),
      ),
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
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
    );
  }

  Widget _taskTile(Task t) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        leading: Checkbox(
          value: t.done,
          onChanged: (v) async {
            setState(() => t.done = v ?? false);
            await _persist();
          },
        ),
        title: Text(t.title,
            style: TextStyle(
                decoration:
                    t.done ? TextDecoration.lineThrough : null)),
        subtitle: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            Icon(Icons.flag, size: 14, color: t.priority.color),
            const SizedBox(width: 3),
            Text(t.time.format(context),
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailScreen(task: t)));
          setState(() {});
          await _persist();
        },
      ),
    );
  }
}
