import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The AttendancePieChart widget uses fl_chart to render a pie chart that indicates attendance.
/// It displays two sections: one for the attendance percentage and one for the remaining percentage.
class AttendancePieChart extends StatelessWidget {
  final double percentage; // Expected value between 0 and 100.
  const AttendancePieChart({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    const double size = 70.0; // Smaller overall diameter.
    const double centerSpaceRadius = 40.0; // Adjusted center space.
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: centerSpaceRadius,
              borderData: FlBorderData(show: false),
              sections: [
                PieChartSectionData(
                  value: percentage,
                  color: Colors.blueAccent, // Attendance portion.
                  title: '',
                  radius: size / 2 - 10,
                ),
                PieChartSectionData(
                  value: 100 - percentage,
                  color: Colors.transparent, // Missed portion.
                  title: '',
                  radius: size / 2 - 10,
                ),
              ],
            ),
          ),
          Text(
            "${percentage.toStringAsFixed(0)}%",
            style: GoogleFonts.roboto(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
