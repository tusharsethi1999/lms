import 'package:lms/models/grade_type.dart';
import 'package:lms/models/user.dart';

class Grade {
  final String gradeId;
  final String studentId;
  final String courseId;
  final GradeType gradeType; // Examination, Assignment, or Mixed
  final double score;

  Grade({
    required this.gradeId,
    required this.studentId,
    required this.courseId,
    required this.gradeType,
    required this.score,
  });
}
