import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lms/models/course.dart';
import 'package:lms/providers/course_provider.dart';

class CourseDetailsPage extends ConsumerWidget {
  final String courseId;
  const CourseDetailsPage({ super.key, required this.courseId });

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.yellow;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.red;
      case 'F':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ).animate().slideY(begin: 0.5, end: 0, duration: 500.ms);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));

    return courseAsync.when(
      data: (course) => _buildDetailScaffold(context, course),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDetailScaffold(BuildContext context, Course course) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title, style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Card ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Course ID: ${course.courseId}",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Instructor: ${course.instructor}",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Schedule: ${course.schedule}",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms),

            // ─── Aggregate Grade ────────────────────────────────────────
            _buildSectionTitle("Current Grade"),
            Center(
              child: Chip(
                label: Text(
                  course.grade,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: _gradeColor(course.grade),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ).animate().fadeIn(duration: 600.ms),

            // ─── Grade Breakdown ────────────────────────────────────────
            if (course.examDetails.isNotEmpty ||
                course.assignmentDetails.isNotEmpty) ...[
              _buildSectionTitle("Grade Breakdown"),
              // Exams
              if (course.examDetails.isNotEmpty) ...[
                Text(
                  "Exams",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                ...course.examDetails.map(
                  (e) => ListTile(
                    title: Text(
                      e.examName,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      "${e.obtainedMarks}/${e.totalMarks}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Assignments
              if (course.assignmentDetails.isNotEmpty) ...[
                Text(
                  "Assignments",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                ...course.assignmentDetails.map(
                  (a) => ListTile(
                    title: Text(
                      a.assignmentName,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      "${a.obtainedMarks}/${a.totalMarks}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ],

            // ─── Instructor Office Hours ────────────────────────────────
            if (course.officeHours != null) ...[
              _buildSectionTitle("Office Hours"),
              ...course.officeHours!.availability.map(
                (slot) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "${slot.dayOfWeek}: ${slot.startTime} – ${slot.endTime} (Office ${course.officeHours!.officeNumber})",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
            // ─── Actions ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    /* Edit Grade Action */
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Grade"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    /* View History Action */
                  },
                  icon: const Icon(Icons.history),
                  label: const Text("View History"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
