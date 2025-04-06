import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'package:lms/components/sidebar.dart';
import 'package:lms/components/dashboard.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Management System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final leftWidth = screenWidth * 0.25;
          final rightWidth = screenWidth * 0.65;

          return Row(
            children: [
              SizedBox(width: screenWidth * 0.05),
              SizedBox(width: leftWidth, child: const SideBar()),
              SizedBox(width: rightWidth, child: const Dashboard()),
            ],
          );
        },
      ),
    );
  }
}
