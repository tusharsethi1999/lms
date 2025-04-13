import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/models/course.dart';
import 'package:lms/pages/course_details.dart';
import 'package:lms/providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.context,
    required this.ref,
    required this.course,
    required this.index,
  });

  final BuildContext context;
  final WidgetRef ref;
  final Course course;
  final int index;

  Color _getProgressColor(double value) {
    if (value < 0.5) {
      return Colors.red;
    } else if (value < 0.7) {
      return Color.lerp(Colors.redAccent, Colors.orangeAccent, value / 0.7)!;
    } else if (value < 0.9) {
      return Color.lerp(
        Colors.orangeAccent,
        Colors.lightGreen,
        (value - 0.7) / 0.2,
      )!;
    } else {
      return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Instructor: ${course.instructor}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Schedule: ${course.schedule}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
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

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance: ${((course.attendance / course.totalAttendance) * 100).toInt()}%',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  color: _getProgressColor(
                    course.attendance / course.totalAttendance,
                  ),
                  value: course.attendance / course.totalAttendance,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsPage(course: course),
                      ),
                    );
                  },
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
                        double tempProgress = course.progress;
                        _showDialog(context, tempProgress);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        (course.attendance - 1).clamp(0.0, 180.0);
                        ref
                            .read(coursesProvider.notifier)
                            .updateAttendance(index);
                      },
                      child: const Text('Miss Class'),
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

  Future<dynamic> _showDialog(BuildContext context, double tempProgress) {
    return showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Progress'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${(tempProgress * 100).toInt()}%'),
                  Slider(
                    value: tempProgress,
                    onChanged: (val) {
                      setState(() {
                        tempProgress = val;
                      });
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
      },
    );
  }
}
