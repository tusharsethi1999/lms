import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Colors.red.withValues(
        alpha: 100, // Adjust the alpha for transparency
      ),
      child: const Center(
        child: Text(
          'Sidebar / Menu',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
