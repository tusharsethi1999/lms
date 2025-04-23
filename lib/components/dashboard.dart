import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/components/course_card.dart';
import 'package:lms/models/user.dart';
import '../providers/course_provider.dart';

class Dashboard extends ConsumerWidget {
  final User user;
  const Dashboard({super.key, required this.user});

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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            courses.length,
            (index) => CourseCard(
              context: context,
              ref: ref,
              course: courses[index],
              index: index,
              user: user,
            ),
          ),
        ],
      ),
    );
  }
}
