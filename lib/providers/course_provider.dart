import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lms/models/assignment_definition.dart';
import 'package:lms/models/assignment_detail.dart';
import 'dart:convert';
import '../models/course.dart';

const _baseUrl = 'http://localhost:8000';

class CoursesNotifier extends StateNotifier<List<Course>> {
  CoursesNotifier() : super([]);

  /// Fetch basic list of courses (without details)
  Future<void> fetchCourses() async {
    final response = await http.get(Uri.parse('$_baseUrl/courses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      state = data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  /// Fetch full details for a single course (includes grade breakdown & office hours)
  Future<Course> fetchCourseDetail(String courseId) async {
    final response = await http.get(Uri.parse('$_baseUrl/courses/$courseId'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      // Handle both possible response formats
      if (data is List<dynamic>) {
        if (data.isEmpty) throw Exception('Course not found');
        return Course.fromJson(data[0] as Map<String, dynamic>);
      }

      return Course.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load course details: ${response.statusCode}');
    }
  }

  /// Fetch completed assignment details for a given grade
  Future<List<AssignmentDetail>> fetchCompletedAssignments(
    String gradeId,
  ) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/grades/$gradeId/assignments'),
    );
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((j) => AssignmentDetail.fromJson(j)).toList();
    }
    throw Exception('Failed to load completed assignments: ${resp.statusCode}');
  }

  /// Fetch master list of assignments (definitions)
  Future<List<AssignmentDefinition>> fetchAssignmentDefs(
    String courseId,
  ) async {
    final resp = await http.get(
      Uri.parse('$_baseUrl/courses/$courseId/assignments'),
    );
    if (resp.statusCode == 200) {
      return (json.decode(resp.body) as List)
          .map((j) => AssignmentDefinition.fromJson(j))
          .toList();
    }
    throw Exception('Failed to load definitions');
  }
}

/// Provider for list of courses
final coursesProvider = StateNotifierProvider<CoursesNotifier, List<Course>>((
  ref,
) {
  final notifier = CoursesNotifier();
  notifier.fetchCourses(); // Auto-fetch on init
  return notifier;
});

/// Provider to get details for a specific course by ID
final courseDetailProvider = FutureProvider.family<Course, String>((
  ref,
  courseId,
) async {
  final notifier = ref.read(coursesProvider.notifier);
  return notifier.fetchCourseDetail(courseId);
});

final assignmentDefsProvider =
    FutureProvider.family<List<AssignmentDefinition>, String>((ref, courseId) {
      return ref.read(coursesProvider.notifier).fetchAssignmentDefs(courseId);
    });

/// Provider for completed assignment details for a given grade
final completedAssignmentsProvider =
    FutureProvider.family<List<AssignmentDetail>, String?>((ref, gradeId) {
      if (gradeId == null || gradeId.isEmpty) {
        return Future.value([]);
      }
      return ref
          .read(coursesProvider.notifier)
          .fetchCompletedAssignments(gradeId);
    });
