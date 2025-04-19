class User {
  final String userId;
  final String username;
  final String email;
  final String password;
  final String role; // Student, Instructor, Admin
  final String major;
  final String semester;
  final String profileImageUrl;
  final double? gpa;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.major,
    required this.semester,
    required this.profileImageUrl,
    this.gpa,
  });
}
