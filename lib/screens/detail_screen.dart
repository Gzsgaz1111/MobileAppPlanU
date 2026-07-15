import 'package:flutter/material.dart';
import '../models/task.dart';

/// Detail screen (Module 2): full view of a single task with its
/// category, priority, schedule, notes, and a complete/undo action.
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.task});
  final Task task;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(t.category.label),
                  backgroundColor: t.category.color.withOpacity(0.15),
                  labelStyle: TextStyle(color: t.category.color),
                ),
                Chip(
                  avatar:
                      Icon(Icons.flag, size: 16, color: t.priority.color),
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
              label:
                  Text(t.done ? 'Mark as Not Done' : 'Mark Complete'),
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
