import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lms/components/custom_circular_indicator.dart';
import 'package:lms/components/hover_animated_button.dart';
import 'package:lms/models/course.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;
  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom dark-themed AppBar.
      appBar: AppBar(
        title: Text(course.title, style: GoogleFonts.roboto()),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card: Course title, instructor, schedule.
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
                  const SizedBox(height: 12),
                  Text(
                    "Instructor: ${course.instructor}",
                    style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Schedule: ${course.schedule}",
                    style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms, curve: Curves.easeInOut),
            const SizedBox(height: 30),
            // Course Progress Section.
            Text(
              "Course Progress",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().slideY(begin: 0.5, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: course.progress,
              minHeight: 14,
              backgroundColor: Colors.grey.shade800,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ).animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.5, end: 0, duration: 600.ms),
            const SizedBox(height: 30),
            // Attendance Section.
            Text(
              "Attendance",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().slideY(begin: 0.5, end: 0, duration: 600.ms),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCircularIndicator(percentage: course.attendancePercentage)
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeInOut),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${course.attendance.toInt()} / ${course.totalAttendance.toInt()} classes attended",
                      style: GoogleFonts.roboto(
                          fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${course.attendancePercentage.toStringAsFixed(1)}%",
                      style: GoogleFonts.roboto(
                          fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Action Buttons Section.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HoverAnimatedButton(
                  icon: Icons.edit,
                  label: "Edit Progress",
                  normalColor: Colors.greenAccent,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    // Add Edit Progress Action
                  },
                  fontSize: 20,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 24),
                ),
                HoverAnimatedButton(
                  icon: Icons.restart_alt,
                  label: "Reset Progress",
                  normalColor: Colors.redAccent,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    // Add Reset Progress Action
                  },
                  fontSize: 20,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 24),
                ),
              ],
            ).animate().fadeIn(
                duration: 600.ms, curve: Curves.easeInOut),
            const SizedBox(height: 30),
            // Miss Class Button.
            Center(
              child: HoverAnimatedButton(
                icon: Icons.class_,
                label: "Miss Class",
                normalColor: Colors.orangeAccent,
                hoverColor: Colors.transparent,
                onPressed: () {
                  // Add Miss Class Action
                },
                fontSize: 22,
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 28),
              ).animate().fadeIn(
                  duration: 600.ms, curve: Curves.easeInOut),
            ),
          ],
        ),
      ),
    );
  }
}