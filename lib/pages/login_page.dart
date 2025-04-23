import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();
      ref.read(authProvider.notifier).login(username, password);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Blurred campus background
          Positioned.fill(
            child: Image.asset(
              'assets/rpi/rpi_wallpaper.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withValues(alpha: .4)),
            ),
          ),

          // Centered fixed‑width login card
          Center(
            child: SizedBox(
              width: 400, // fixed for laptop
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white.withValues(alpha: .85),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // University Logo
                        Image.asset('assets/rpi/rpi_logo.png', height: 80),
                        const SizedBox(height: 24),

                        // Error message
                        // if (authState.hasError) ...[
                        //   SlideTransition(
                        //     position: _slideAnimation,
                        //     child: FadeTransition(
                        //       opacity: _fadeAnimation,
                        //       child: _buildErrorBox(authState: authState),
                        //     ),
                        //   ),
                        //   const SizedBox(height: 20),
                        // ],
                        if (authState.hasError)
                          AnimatedSlide(
                            offset: Offset.zero,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            child: AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(milliseconds: 500),
                              child: _buildErrorBox(authState: authState),
                            ),
                          )
                        else
                          SizedBox.shrink(),

                        // Header
                        Text(
                          'Welcome to RPI',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 32),

                        // Username field
                        TextFormField(
                          controller: usernameController,
                          focusNode: _usernameFocus,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted:
                              (_) => FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocus),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Enter username'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        TextFormField(
                          controller: passwordController,
                          focusNode: _passwordFocus,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (_) => _login(),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Enter password'
                                      : null,
                        ),
                        const SizedBox(height: 30),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child:
                                authState.isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'SIGN IN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _buildErrorBox extends StatelessWidget {
  const _buildErrorBox({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('🚨', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Oops! ${authState.errorMessage}',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
