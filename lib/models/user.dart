class User {
  final String userId;
  final String username;
  final String name;
  final String email;
  final String? password;
  final String role; // Student, Instructor, Admin
  final String? major;
  final String? semester;
  final String? profileImageUrl;
  final double? gpa;

  User({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    this.password,
    required this.role,
    this.major,
    this.semester,
    this.profileImageUrl,
    this.gpa,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      username: '',
    );
  }
}
