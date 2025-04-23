import 'package:lms/models/schedule.dart';

class InstructorOfficeHour {
  final String instructorId;
  final String location;
  final List<WeeklySchedule> schedules;

  InstructorOfficeHour({
    required this.instructorId,
    required this.location,
    required this.schedules,
  });

  factory InstructorOfficeHour.fromJson(Map<String, dynamic> json) {
    return InstructorOfficeHour(
      instructorId: json['instructorId'] as String,
      location: json['location'] as String,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => WeeklySchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'instructorId': instructorId,
        'location': location,
        'schedules': schedules.map((e) => e.toJson()).toList(),
      };
}
