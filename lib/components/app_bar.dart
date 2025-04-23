import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLogout;
  static const double appBarHeight = 120;

  const CustomAppBar({super.key, required this.title, required this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Translucent blurred background
        ClipPath(
          clipper: CustomAppBarClipper(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: preferredSize.height + topPadding,
              padding: EdgeInsets.only(top: topPadding),
              color: Colors.white.withValues(alpha: .25),
            ),
          ),
        ),

        Positioned(
          top: topPadding + 16,
          left: 24,
          right: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // University Logo
              Image.asset(
                'assets/rpi/rpi_logo.png',
                height: 48,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: const [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Logout icon
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: onLogout,
                tooltip: 'Logout',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
