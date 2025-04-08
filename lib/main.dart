import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:lms/pages/home_page.dart';
import 'package:lms/pages/login_page.dart';
import 'package:lms/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: LMSApp()));
}

class LMSApp extends ConsumerWidget {
  const LMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(
      authProvider,
    ); // Changed to watch instead of read

    return MaterialApp(
      title: 'LMS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child:
            authState.isAuthenticated
                ? const HomePage(key: ValueKey('HomePage'))
                : const LoginPage(key: ValueKey('LoginPage')),
      ),
    );
  }
}
