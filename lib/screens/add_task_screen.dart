import 'package:flutter/material.dart';
import '../models/task.dart';

/// Add Task (Module 2): create a task with title, date, time, priority,
/// life-area category (US-11), and notes. Returns the new Task.
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
    Navigator.of(context).pop(Task(
      title: _title.text.trim(),
      date: _date,
      hour: _time.hour,
      minute: _time.minute,
      priority: _priority,
      category: _category,
      notes: _notes.text.trim(),
    ));
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
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label:
                          Text('${_date.day}/${_date.month}/${_date.year}'),
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
              Text('Priority',
                  style: Theme.of(context).textTheme.labelLarge),
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
              Text('Life area (US-11)',
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
