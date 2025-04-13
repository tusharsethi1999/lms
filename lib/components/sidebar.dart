import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lms/models/user.dart';

class NeumorphicSidebar extends StatelessWidget {
  final User user;
  const NeumorphicSidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const double sidebarWidth = 250.0;

    // Define modern text styles using Google Fonts (Roboto).
    final nameTextStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final emailTextStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.white70,
    );
    final infoTextStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    return Container(
          width: sidebarWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            // Use two BoxShadows with Colors.black and different opacities via .withValues().
            boxShadow: [
              // Lighter shadow on the top-left.
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(-4, -4),
                blurRadius: 8,
              ),
              // Darker shadow on the bottom-right.
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Picture (Circular)
              Center(
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget:
                        (context, url, error) => const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Username (centered)
              Center(child: Text(user.username, style: nameTextStyle)),
              // Email (centered)
              Center(child: Text(user.email, style: emailTextStyle)),
              const SizedBox(height: 20),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16),
              // Role
              Text("Role: ${user.role}", style: infoTextStyle),
              const SizedBox(height: 8),
              // Major
              Text("Major: ${user.major}", style: infoTextStyle),
              const SizedBox(height: 8),
              // Semester
              Text("Semester: ${user.semester}", style: infoTextStyle),
              if (user.gpa != null) ...[
                const SizedBox(height: 8),
                Text(
                  "GPA: ${user.gpa!.toStringAsFixed(2)}",
                  style: infoTextStyle,
                ),
              ],
              const Spacer(),
              // (Additional elements such as theme toggles or notifications can be added here.)
            ],
          ),
        )
        // Apply a fade-in and slide-in animation for a polished entrance.
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeInOut)
        .slideX(begin: -1.0, end: 0, duration: 600.ms, curve: Curves.easeInOut);
  }
}
