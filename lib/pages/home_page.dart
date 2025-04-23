import 'dart:ui'; // for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/components/app_bar.dart';
import 'package:lms/components/sidebar.dart';
import 'package:lms/components/dashboard.dart';
import 'package:lms/main.dart';
import '../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LMSApp()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider);
    final appBar = CustomAppBar(
      title: 'Learning Management System',
      onLogout: () => _handleLogout(context, ref),
    );
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = appBar.preferredSize.height;
    final topOffset = statusBarHeight + appBarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          // Full‑screen campus image
          Positioned.fill(
            child: Image.asset(
              'assets/rpi/rpi_dashboard.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Blur + dark overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withValues(alpha: .4)),
            ),
          ),

          // Main content below AppBar
          Positioned(
            top: topOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: LayoutBuilder(
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
                    SizedBox(width: rightWidth, child: Dashboard(user: user.user!)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
