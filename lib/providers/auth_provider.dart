import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/models/user.dart';

// Simulated credentials
const dummyUsername = 'sethit';
const dummyPassword = 'password123';
const dummyEmail = '$dummyUsername@rpi.edu';
const dummyRole = 'student';

// Auth state model
class AuthState {
  // final String id;
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  bool get isAuthenticated => user != null;
  bool get hasError => errorMessage != null;
}

// StateNotifier to handle auth logic
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String username, String password) async {
    try {
      state = AuthState(isLoading: true, errorMessage: null);

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (username == dummyUsername && password == dummyPassword) {
        state = AuthState(
          user: User(
            username: username,
            role: dummyRole,
            password: password,
            email: dummyEmail,
          ),
          isLoading: false,
        );
      } else {
        throw Exception('🔐 Invalid credentials! Please try again.');
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString(), isLoading: false);
    }
  }

  void logout() {
    state = const AuthState();
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
