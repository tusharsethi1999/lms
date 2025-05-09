class AssignmentDetail {
  final String assignmentId;
  final String gradeId;
  final String assignmentName;
  final double obtainedMarks;
  final double totalMarks;
  final DateTime? dueDate;

  AssignmentDetail({
    required this.assignmentId,
    required this.gradeId,
    required this.assignmentName,
    required this.obtainedMarks,
    required this.totalMarks,
    this.dueDate,
  });

  factory AssignmentDetail.fromJson(Map<String, dynamic> json) {
    return AssignmentDetail(
      assignmentId: json['assignmentId'] as String,
      gradeId: json['gradeId'] as String,
      assignmentName: json['assignmentName'] as String,
      obtainedMarks: (json['obtainedMarks'] as num).toDouble(),
      totalMarks: (json['totalMarks'] as num).toDouble(),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'assignmentId': assignmentId,
        'gradeId': gradeId,
        'assignmentName': assignmentName,
        'obtainedMarks': obtainedMarks,
        'totalMarks': totalMarks,
        'dueDate': dueDate?.toIso8601String(),
      };
}
