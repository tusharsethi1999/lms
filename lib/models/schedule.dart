class WeeklySchedule {
  final String dayOfWeek; // e.g., Monday, Tuesday, etc.
  final String startTime; // e.g., "10:00 AM"
  final String endTime; // e.g., "12:00 PM"

  WeeklySchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      dayOfWeek: json['dayOfWeek'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
      };
}
