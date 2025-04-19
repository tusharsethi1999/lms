class ExamDetail {
  final String examId;
  final String gradeId;
  final String examName;
  final double obtainedMarks;
  final double totalMarks;

  ExamDetail({
    required this.examId,
    required this.gradeId,
    required this.examName,
    required this.obtainedMarks,
    required this.totalMarks,
  });

  factory ExamDetail.fromJson(Map<String, dynamic> json) {
    return ExamDetail(
      examId: json['examId'] as String,
      gradeId: json['gradeId'] as String,
      examName: json['examName'] as String,
      obtainedMarks: (json['obtainedMarks'] as num).toDouble(),
      totalMarks: (json['totalMarks'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'examId': examId,
        'gradeId': gradeId,
        'examName': examName,
        'obtainedMarks': obtainedMarks,
        'totalMarks': totalMarks,
      };
}
