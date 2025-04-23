// models/assignment_definition.dart
class AssignmentDefinition {
  final String assignmentId;
  final String assignmentName;
  final double weight;
  final double totalMarks;

  AssignmentDefinition({
    required this.assignmentId,
    required this.assignmentName,
    required this.weight,
    required this.totalMarks,
  });

  factory AssignmentDefinition.fromJson(Map<String, dynamic> json) {
    return AssignmentDefinition(
      assignmentId: json['assignmentId'] as String,
      assignmentName: json['assignmentName'] as String,
      weight: (json['weight'] as num).toDouble(),
      totalMarks: (json['totalMarks'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'assignmentId': assignmentId,
        'assignmentName': assignmentName,
        'weight': weight,
        'totalMarks': totalMarks,
      };
}
