import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/course.dart';

const _baseUrl = 'https://localhost:3000';

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
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Course.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load course details: ${response.statusCode}');
    }
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
