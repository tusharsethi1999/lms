import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/components/app_bar.dart';
import 'package:lms/main.dart';
import '../providers/auth_provider.dart';
import 'package:lms/components/sidebar.dart';
import 'package:lms/components/dashboard.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).logout();
    // Optional: Add navigation back to login if needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LMSApp()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Learning Management System',
        onLogout: () => _handleLogout(context, ref),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final leftWidth = screenWidth * 0.25;
          final rightWidth = screenWidth * 0.65;

          return Row(
            children: [
              SizedBox(width: screenWidth * 0.05),
              SizedBox(
                width: leftWidth,
                child: NeumorphicSidebar(user: user.user!),
              ),
              SizedBox(width: rightWidth, child: const Dashboard()),
            ],
          );
        },
      ),
    );
  }
}
