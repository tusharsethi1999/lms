import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/models/user.dart';

// Simulated credentials
const dummyUsername = 'sethit';
const dummyPassword = 'password123';
const dummyEmail = '$dummyUsername@rpi.edu';
const dummyyRole = 'student';

// StateNotifier to handle login/logout logic
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  void login(String username, String password) {
    if (username == dummyUsername && password == dummyPassword) {
      state = User(username: username, role: dummyyRole, password: dummyPassword, email: dummyEmail);
    }
  }

  void logout() {
    state = null;
  }
}

// Global provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
