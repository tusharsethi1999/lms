import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lms/models/user.dart';

// Auth state model
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  bool get isAuthenticated => user != null;
  bool get hasError => errorMessage != null;
}

// StateNotifier to handle auth logic.
class AuthNotifier extends StateNotifier<AuthState> {
  // Persistent state for hot reload retention.
  static AuthState persistentState = const AuthState();

  AuthNotifier() : super(persistentState);

  @override
  set state(AuthState newState) {
    persistentState = newState;
    super.state = newState;
  }

  /// Logs in by calling the Deno backend.
  Future<void> login(String username, String password) async {
    try {
      state = AuthState(isLoading: true, errorMessage: null);

      // Replace 'localhost' with the appropriate IP/hostname if needed.
      final uri = Uri.parse('http://localhost:8000/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the response structure is:
        // { "message": "Login successful", "user": { ... } }
        final userData = data['user'];
        final user = User(
          userId: userData['userId'],
          username: userData['username'],
          email: userData['email'],
          role: userData['role'],
          major: userData['major'],
          semester: userData['semester'],
          profileImageUrl: userData['profileImageUrl'],
          password: password, // Retain the password locally if needed.
        );
        state = AuthState(user: user, isLoading: false);
      } else {
        // Parse error details if provided.
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Invalid credentials');
      }
    } catch (e) {
      state = AuthState(errorMessage: e.toString(), isLoading: false);
    }
  }

  void logout() {
    state = const AuthState();
  }
}

// Auth provider for your app.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
