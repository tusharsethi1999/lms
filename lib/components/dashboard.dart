import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 My Courses – Spring 2025',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            courses.length,
            (index) => _buildCourseCard(context, ref, courses[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context, WidgetRef ref, Course course, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Instructor: ${course.instructor}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Schedule: ${course.schedule}',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: ${(course.progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Buttons: View, Reset, Edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Reset Progress',
                      icon: const Icon(Icons.restart_alt),
                      onPressed: () {
                        ref
                            .read(coursesProvider.notifier)
                            .updateProgress(index, 0.0);
                      },
                    ),
                    IconButton(
                      tooltip: 'Edit Progress',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, ref, course, index);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final newProgress =
                            (course.progress + 0.1).clamp(0.0, 1.0);
                        ref
                            .read(coursesProvider.notifier)
                            .updateProgress(index, newProgress);
                      },
                      child: const Text('+10%'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Course course, int index) {
    double tempProgress = course.progress;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Progress'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(tempProgress * 100).toInt()}%'),
              Slider(
                value: tempProgress,
                onChanged: (val) {
                  tempProgress = val;
                },
                min: 0.0,
                max: 1.0,
                divisions: 20,
                label: '${(tempProgress * 100).toInt()}%',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(coursesProvider.notifier)
                    .updateProgress(index, tempProgress);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
