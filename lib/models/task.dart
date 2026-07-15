import 'package:flutter/material.dart';

/// Life-area tag (US-11): every task belongs to one area,
/// and all areas are consolidated in a single planner view.
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
    required this.hour,
    required this.minute,
    required this.priority,
    required this.category,
    this.notes = '',
    this.done = false,
  });

  String title;
  DateTime date;
  int hour;
  int minute;
  Priority priority;
  Category category;
  String notes;
  bool done;

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        'hour': hour,
        'minute': minute,
        'priority': priority.index,
        'category': category.index,
        'notes': notes,
        'done': done,
      };

  factory Task.fromJson(Map<String, dynamic> j) => Task(
        title: j['title'] as String,
        date: DateTime.parse(j['date'] as String),
        hour: j['hour'] as int,
        minute: j['minute'] as int,
        priority: Priority.values[j['priority'] as int],
        category: Category.values[j['category'] as int],
        notes: (j['notes'] ?? '') as String,
        done: (j['done'] ?? false) as bool,
      );
}
