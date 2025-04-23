import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lms/models/course.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CourseDetailsPage extends ConsumerWidget {
  final Course course;
  const CourseDetailsPage({super.key, required this.course});

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

  LinkedHashMap<DateTime, List<String>> _parseOfficeHours() {
    final events = LinkedHashMap<DateTime, List<String>>(
      equals: isSameDay,
      hashCode: (date) => date.day + date.month * 32 + date.year * 32 * 13,
    );

    for (final officeHour in course.officeHours) {
      for (final schedule in officeHour.schedules) {
        final date = _getNextWeekday(schedule.dayOfWeek);
        events.update(
          date,
          (list) => [...list, 'Office Hours: ${officeHour.location}'],
          ifAbsent: () => ['Office Hours: ${officeHour.location}'],
        );
      }
    }
    return events;
  }

  DateTime _getNextWeekday(String dayName) {
    final now = DateTime.now();
    final weekday = _dayNameToInt(dayName);
    var date = now.subtract(Duration(days: now.weekday - 1));
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  int _dayNameToInt(String dayName) {
    const days = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return days[dayName] ?? 1;
  }

  void _showDailySchedule(DateTime selectedDay, BuildContext context) {
    final events = _parseOfficeHours()[selectedDay] ?? [];
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.yMMMMd().format(selectedDay),
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...events.map(
                  (event) => ListTile(
                    leading: const Icon(Icons.event, color: Colors.white70),
                    title: Text(
                      event,
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
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
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            "Instructor: ${course.instructor?.name ?? 'TBA'}",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            "Schedule: ${course.schedule}",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
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

  Widget _buildCalendar(BuildContext context) {
    final events = LinkedHashMap<DateTime, List<String>>(
      equals: isSameDay,
      hashCode: (date) => date.day + date.month * 32 + date.year * 32 * 13,
    )..addAll(_parseOfficeHours());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Office Hours Calendar',
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
            ),
            TableCalendar(
              lastDay: DateTime.now().add(const Duration(days: 30)),
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                titleTextStyle: GoogleFonts.roboto(color: Colors.white),
                formatButtonTextStyle: GoogleFonts.roboto(color: Colors.white),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.roboto(color: Colors.white70),
                weekendStyle: GoogleFonts.roboto(color: Colors.white70),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: GoogleFonts.roboto(color: Colors.white),
              ),
              eventLoader: (date) => events[date] ?? [],
              onDaySelected:
                  (selectedDay, focusedDay) =>
                      _showDailySchedule(selectedDay, context),
              focusedDay: DateTime.now(),
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget:
                    (value, meta) => Text(
                      meta.formattedValue,
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget:
                    (value, meta) => Text(
                      '${value.toInt()}%',
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots:
                  course.gradeHistory
                      .map(
                        (g) => FlSpot(
                          g.date.millisecondsSinceEpoch.toDouble(),
                          g.score,
                        ),
                      )
                      .toList(),
              isCurved: true,
              color: Colors.greenAccent,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final allItems = [
      ...course.examDetails.map(
        (e) => _TimelineItem(
          title: e.examName,
          date: e.date ?? DateTime.now(),
          type: 'Exam',
          score: '${e.obtainedMarks}/${e.totalMarks}',
        ),
      ),
      ...course.assignmentDetails.map(
        (a) => _TimelineItem(
          title: a.assignmentName,
          date: a.dueDate ?? DateTime.now(),
          type: 'Assignment',
          score: '${a.obtainedMarks}/${a.totalMarks}',
        ),
      ),
    ]..sort((a, b) => a!.date.compareTo(b!.date));

    if (allItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No upcoming events',
          style: GoogleFonts.roboto(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: allItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = allItems[index];
        final isFirst = index == 0;
        final isLast = index == allItems.length - 1;

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.2,
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: LineStyle(color: Colors.grey.shade700),
          indicatorStyle: IndicatorStyle(
            width: 30,
            color: item.type == 'Exam' ? Colors.redAccent : Colors.blueAccent,
            iconStyle: IconStyle(
              iconData: item.type == 'Exam' ? Icons.assignment : Icons.article,
              color: Colors.white,
            ),
          ),
          endChild: Container(
            padding: const EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.type} • ${DateFormat.yMd().format(item.date)}',
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Score: ${item.score}',
                  style: GoogleFonts.roboto(
                    color: _gradeColor(
                      item.score.split('/').firstOrNull ?? '-',
                    ),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Class Avg',
          value: course.classStats.averageScore?.toStringAsFixed(1) ?? '-',
          color: Colors.blueAccent,
        ),
        _StatCard(
          title: 'Highest',
          value: course.classStats.highestScore?.toStringAsFixed(1) ?? '-',
          color: Colors.greenAccent,
        ),
        _StatCard(
          title: 'Lowest',
          value: course.classStats.lowestScore?.toStringAsFixed(1) ?? '-',
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Handle grade edit
          },
          icon: const Icon(Icons.edit),
          label: const Text("Edit Grade"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Handle materials access
          },
          icon: const Icon(Icons.library_books),
          label: const Text("Course Materials"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            // Basic Info Card
            _buildBasicInfoCard(),

            // Grade and Stats Section
            _buildSectionTitle("Performance Overview"),
            _buildGradeChart(),
            SizedBox(height: 20),
            _buildStatsGrid(),

            // Timeline
            _buildSectionTitle("Course Timeline"),
            _buildTimeline(),

            // Office Hours Calendar
            _buildSectionTitle("Office Hours Schedule"),
            _buildCalendar(context),

            // Additional Actions
            _buildActionButtons(),
          ],
        ),
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

            // if (course.officeHours != null) ...[
            //   _buildSectionTitle("Office Hours"),
            //   ...course.officeHours!.location.map(
            //     (slot) => Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 4),
            //       child: Row(
            //         children: [
            //           Icon(Icons.schedule, color: Colors.white70, size: 20),
            //           const SizedBox(width: 8),
            //           Text(
            //             "${slot.dayOfWeek}: ${slot.startTime} – ${slot.endTime} (Office ${course.officeHours!.officeNumber})",
            //             style: GoogleFonts.roboto(
            //               fontSize: 16,
            //               color: Colors.white70,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ],
            const SizedBox(height: 40),
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
              ],
            ).animate().fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this extension for FlChartItem conversion
extension FlChartItem on GradeHistory {
  FlSpot get toFlSpot => FlSpot(date.millisecondsSinceEpoch.toDouble(), score);
}

class _TimelineItem {
  final String title;
  final DateTime date;
  final String type;
  final String score;

  _TimelineItem({
    required this.title,
    required this.date,
    required this.type,
    required this.score,
  });
}
