import 'package:lms/models/instructor_office_hour.dart';
import 'package:lms/models/exam_detail.dart';
import 'package:lms/models/assignment_detail.dart';
import 'package:lms/models/user.dart';

class Course {
  /// Unique course identifier
  final String id;
  final String courseId;
  final String title;
  final String schedule;
  final User? instructor;

  /// Aggregate grade (A-F)
  final String grade;

  /// Internal grade record ID for fetching breakdowns
  final String? gradeId;

  // Detailed breakdown
  final List<ExamDetail> examDetails;
  final List<AssignmentDetail> assignmentDetails;

  final List<InstructorOfficeHour> officeHours;

  final List<GradeHistory> gradeHistory;
  final ClassStats classStats;

  Course({
    required this.id,
    required this.courseId,
    required this.title,
    required this.schedule,
    required this.instructor,
    required this.grade,
    required this.gradeId,
    this.examDetails = const [],
    this.assignmentDetails = const [],
    this.officeHours = const [],
    this.gradeHistory = const [],
    this.classStats = const ClassStats(
      averageScore: 0.0,
      highestScore: 0.0,
      lowestScore: 0.0,
    ),
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] as String? ?? '', // Handle null _id
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      schedule: json['schedule'] as String,
      instructor:
          json['instructor'] != null
              ? User.fromJson(json['instructor'] as Map<String, dynamic>)
              : null,
      grade: json['grade'] as String? ?? '-', // Default for missing grade
      gradeId: json['gradeId'] as String?,
      examDetails:
          (json['exams'] as List<dynamic>?) // Match backend key
              ?.map((e) => ExamDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      assignmentDetails:
          (json['assignments'] as List<dynamic>?) // Match backend key
              ?.map((a) => AssignmentDetail.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      officeHours:
          (json['officeHours'] as List<dynamic>?)
              ?.map(
                (oh) =>
                    InstructorOfficeHour.fromJson(oh as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'courseId': courseId,
    'title': title,
    'schedule': schedule,
    'instructor': instructor,
    'grade': grade,
    'gradeId': gradeId,
    'examDetails': examDetails.map((e) => e.toJson()).toList(),
    'assignmentDetails': assignmentDetails.map((a) => a.toJson()).toList(),
    'officeHours': officeHours.map((oh) => oh.toJson()).toList(),
  };

  Course copyWith({
    String? id,
    String? courseId,
    String? title,
    String? schedule,
    User? instructor,
    String? grade,
    String? gradeId,
    List<ExamDetail>? examDetails,
    List<AssignmentDetail>? assignmentDetails,
    List<InstructorOfficeHour>? officeHours,
    List<GradeHistory>? gradeHistory,
    ClassStats? classStats,
  }) {
    return Course(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      schedule: schedule ?? this.schedule,
      instructor: instructor ?? this.instructor,
      grade: grade ?? this.grade,
      gradeId: gradeId ?? this.gradeId,
      examDetails: examDetails ?? this.examDetails,
      assignmentDetails: assignmentDetails ?? this.assignmentDetails,
      officeHours: officeHours ?? this.officeHours,
      gradeHistory: gradeHistory ?? this.gradeHistory,
      classStats: classStats ?? this.classStats,
    );
  }
}

class GradeHistory {
  final DateTime date;
  final double score;
  GradeHistory({required this.date, required this.score});
  factory GradeHistory.fromJson(Map<String, dynamic> json) {
    return GradeHistory(
      date: DateTime.parse(json['date'] as String),
      score: (json['score'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'score': score,
  };
}

class ClassStats {
  final double? averageScore;
  final double? highestScore;
  final double? lowestScore;
  const ClassStats({this.averageScore, this.highestScore, this.lowestScore});
  factory ClassStats.fromJson(Map<String, dynamic> json) {
    return ClassStats(
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      highestScore: (json['highestScore'] as num?)?.toDouble(),
      lowestScore: (json['lowestScore'] as num?)?.toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
    'averageScore': averageScore,
    'highestScore': highestScore,
    'lowestScore': lowestScore,
  };
}
