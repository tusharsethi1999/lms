import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lms/models/user.dart';

class NeumorphicSidebar extends StatelessWidget {
  final User user;
  const NeumorphicSidebar({super.key, required this.user});

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double sidebarWidth = 260.0;

    return Container(
          width: sidebarWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade900, Colors.black87],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.white24,
                offset: const Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.profileImageUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white70,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white12,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white54,
                          ),
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Name & Email
              Text(
                user.name,
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: GoogleFonts.openSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),

              const Divider(color: Colors.white38, height: 32, thickness: 1),

              // Info Tiles
              _infoTile(Icons.badge, 'Role', user.role),
              _infoTile(Icons.school, 'Major', user.major ?? ''),
              _infoTile(Icons.calendar_today, 'Semester', user.semester ?? ''),
              if (user.gpa != null)
                _infoTile(Icons.star, 'GPA', user.gpa!.toStringAsFixed(2)),

              const Spacer(),
            ],
          ),
        )
        // Polished entrance animation
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideX(begin: -1.0, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}
