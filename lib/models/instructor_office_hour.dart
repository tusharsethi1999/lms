import 'package:lms/models/schedule.dart';

class InstructorOfficeHour {
  final String instructorId;
  final String officeNumber;
  final List<WeeklySchedule> availability;

  InstructorOfficeHour({
    required this.instructorId,
    required this.officeNumber,
    required this.availability,
  });

  factory InstructorOfficeHour.fromJson(Map<String, dynamic> json) {
    return InstructorOfficeHour(
      instructorId: json['instructorId'] as String,
      officeNumber: json['officeNumber'] as String,
      availability: (json['availability'] as List<dynamic>)
          .map((e) => WeeklySchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'instructorId': instructorId,
        'officeNumber': officeNumber,
        'availability': availability.map((e) => e.toJson()).toList(),
      };
}
