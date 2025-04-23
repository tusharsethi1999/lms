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
        return Colors.redAccent;
      case 'F':
        return Colors.red.shade700;
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
          (list) => [...list, 'Office: ${officeHour.location}'],
          ifAbsent: () => ['Office: ${officeHour.location}'],
        );
      }
    }

    if (events.isEmpty) {
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      events[today] = ['Office: Room 101 2:00 PM - 4 PM'];
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.grey[900],
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMMd().format(selectedDay),
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 12),
                ...events.map(
                  (event) => ListTile(
                    leading: Icon(Icons.event, color: Colors.redAccent),
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
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: GoogleFonts.roboto(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "ID: ${course.courseId}",
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                "Instructor: ${course.instructor?.name ?? 'TBA'}",
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                "Schedule: ${course.schedule}",
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms),
    );
  }

  Widget _buildSectionTitle(String text) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ).animate().slideY(begin: 0.5, end: 0, duration: 500.ms),
  );

  Widget _buildCalendar(BuildContext context) {
    final events = LinkedHashMap<DateTime, List<String>>(
      equals: isSameDay,
      hashCode: (date) => date.day + date.month * 32 + date.year * 32 * 13,
    )..addAll(_parseOfficeHours());
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Office Hours',
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            TableCalendar(
              lastDay: DateTime.now().add(const Duration(days: 30)),
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                titleTextStyle: GoogleFonts.roboto(color: Colors.white),
                formatButtonTextStyle: GoogleFonts.roboto(
                  color: Colors.redAccent,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white70,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.roboto(color: Colors.white54),
                weekendStyle: GoogleFonts.roboto(color: Colors.white54),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: GoogleFonts.roboto(color: Colors.white),
              ),
              eventLoader: (date) => events[date] ?? [],
              onDaySelected: (d, _) => _showDailySchedule(d, context),
              focusedDay: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeChart() {
    final spots =
        course.gradeHistory.isNotEmpty
            ? course.gradeHistory
                .map(
                  (g) =>
                      FlSpot(g.date.millisecondsSinceEpoch.toDouble(), g.score),
                )
                .toList()
            : [
              FlSpot(
                DateTime.now()
                    .subtract(const Duration(days: 30))
                    .millisecondsSinceEpoch
                    .toDouble(),
                87,
              ),
              FlSpot(
                DateTime.now()
                    .subtract(const Duration(days: 21))
                    .millisecondsSinceEpoch
                    .toDouble(),
                70,
              ),
              FlSpot(
                DateTime.now()
                    .subtract(const Duration(days: 14))
                    .millisecondsSinceEpoch
                    .toDouble(),
                80,
              ),
              FlSpot(
                DateTime.now()
                    .subtract(const Duration(days: 7))
                    .millisecondsSinceEpoch
                    .toDouble(),
                95,
              ),
              FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(), 90),
            ];

    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              // minX: spots.map((s) => s.x).reduce(),
              // maxX: spots.map((s) => s.x).reduce(100),
              minX:
                  DateTime.now()
                      .subtract(const Duration(days: 30))
                      .millisecondsSinceEpoch
                      .toDouble(),
              maxX: DateTime.now().millisecondsSinceEpoch.toDouble(),
              minY: 0,
              maxY: 100,
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 604800000, // 7 days in milliseconds
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(
                        value.toInt(),
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('MMM dd').format(date),
                          style: GoogleFonts.roboto(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 10,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}%',
                          style: GoogleFonts.roboto(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.redAccent,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withValues(alpha: .3),
                        Colors.redAccent.withValues(alpha: .1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      children: [
        _StatCard(
          title: 'Avg',
          value:
              course.classStats.averageScore?.toStringAsFixed(1) == '0.0'
                  ? '75'
                  : course.classStats.averageScore!.toStringAsFixed(1),
          color: Colors.white,
        ),
        _StatCard(
          title: 'High',
          value:
              course.classStats.highestScore?.toStringAsFixed(1) == '0.0'
                  ? '95'
                  : course.classStats.highestScore!.toStringAsFixed(1),
          color: Colors.redAccent,
        ),
        _StatCard(
          title: 'Low',
          value:
              course.classStats.lowestScore?.toStringAsFixed(1) == '0.0'
                  ? '50'
                  : course.classStats.lowestScore!.toStringAsFixed(1),
          color: Colors.red.shade700,
        ),
      ],
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
    ]..sort((a, b) => a.date.compareTo(b.date));

    // Fallback static timeline if empty
    final items =
        allItems.isNotEmpty
            ? allItems
            : [
              _TimelineItem(
                title: 'Sample Assignment',
                date: DateTime.now().add(Duration(days: 3)),
                type: 'Assignment',
                score: '--/--',
              ),
              _TimelineItem(
                title: 'Sample Exam',
                date: DateTime.now().add(Duration(days: 7)),
                type: 'Exam',
                score: '--/--',
              ),
            ];

    return Column(
      children:
          items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  color:
                      item.type == 'Exam'
                          ? Colors.redAccent
                          : Colors.blueAccent,
                  iconStyle: IconStyle(
                    iconData:
                        item.type == 'Exam' ? Icons.assignment : Icons.article,
                    color: Colors.white,
                  ),
                ),
                endChild: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat.yMd().format(item.date),
                            style: GoogleFonts.roboto(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            item.score,
                            style: GoogleFonts.roboto(
                              color: _gradeColor(item.score.split('/').first),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.redAccent,
      elevation: 2,
      child: Icon(Icons.library_books, color: Colors.white),
    ).animate().fadeIn(duration: 600.ms);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.title,
          style: GoogleFonts.roboto(color: Colors.black),
        ),
        backgroundColor: Colors.white60,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey[200],
      floatingActionButton: _buildActionButtons(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoCard(),
            _buildSectionTitle("Performance Overview"),
            _buildGradeChart(),
            _buildSectionTitle("Class Statistics"),
            _buildStatsGrid(),
            _buildSectionTitle("Timeline"),
            _buildTimeline(),
            _buildSectionTitle("Office Hours"),
            _buildCalendar(context),
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
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
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
