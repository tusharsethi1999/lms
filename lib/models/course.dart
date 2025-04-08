class Course {
  final String title;
  final String instructor;
  final String schedule;
  double progress; // value between 0.0 and 1.0

  Course({
    required this.title,
    required this.instructor,
    required this.schedule,
    required this.progress,
  });

  Course copyWith({double? progress}) {
    return Course(
      title: title,
      instructor: instructor,
      schedule: schedule,
      progress: progress ?? this.progress,
    );
  }
}
