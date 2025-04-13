// Import statements for model (if needed)...
// (No third-party imports needed here unless using JSON or other utils)

class User {
  final String username;
  final String email;
  final String password;
  final String role;
  final String major;
  final String semester;
  final String profileImageUrl;
  // You might also include other fields like GPA, notification count, etc.
  final double? gpa;
  final int? notificationCount;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.major,
    required this.semester,
    required this.profileImageUrl,
    this.gpa,
    this.notificationCount,
  });
}
