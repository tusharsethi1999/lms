class Course {
  final String title;
  final String instructor;
  final String schedule;
  final double progress; // value between 0.0 and 1.0
  late double attendance;
  late final double totalAttendance;

  Course({
    required this.title,
    required this.instructor,
    required this.schedule,
    required this.progress,
  }) {
    attendance = 180;
    totalAttendance = 180;
  }

  double get attendancePercentage {
    return (attendance / totalAttendance) * 100;
  }

  Course copyWith({double? progress, double? attendance}) {
    return Course(
      title: title,
      instructor: instructor,
      schedule: schedule,
      progress: progress ?? this.progress,
    )..attendance = attendance ?? this.attendance;
  }
}
