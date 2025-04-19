import 'package:lms/models/instructor_office_hour.dart';
import 'package:lms/models/exam_detail.dart';
import 'package:lms/models/assignment_detail.dart';

class Course {
  final String courseId;
  final String title;
  final String schedule;
  final String instructor;
  final String grade;
  // Detailed breakdown
  final List<ExamDetail> examDetails;
  final List<AssignmentDetail> assignmentDetails;

  // Optional office hours for the instructor
  final InstructorOfficeHour? officeHours;

  Course({
    required this.courseId,
    required this.title,
    required this.schedule,
    required this.instructor,
    required this.grade,
    this.examDetails = const [],
    this.assignmentDetails = const [],
    this.officeHours,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      schedule: json['schedule'] as String,
      instructor: json['instructor'] as String,
      grade: json['grade'] as String,
      examDetails: (json['examDetails'] as List<dynamic>?)
              ?.map((e) => ExamDetail.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      assignmentDetails: (json['assignmentDetails'] as List<dynamic>?)
              ?.map((a) => AssignmentDetail.fromJson(a as Map<String, dynamic>))
              .toList() ?? [],
      officeHours: json['officeHours'] != null
          ? InstructorOfficeHour.fromJson(
              json['officeHours'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'title': title,
        'schedule': schedule,
        'instructor': instructor,
        'grade': grade,
        'examDetails': examDetails.map((e) => e.toJson()).toList(),
        'assignmentDetails': assignmentDetails.map((a) => a.toJson()).toList(),
        'officeHours': officeHours?.toJson(),
      };
}
