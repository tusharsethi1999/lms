import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HoverAnimatedButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color normalColor;
  final Color hoverColor; // "empty" color on hover (should be transparent)
  final VoidCallback onPressed;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const HoverAnimatedButton({
    super.key,
    required this.icon,
    required this.label,
    required this.normalColor,
    required this.hoverColor,
    required this.onPressed,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  });

  @override
  _HoverAnimatedButtonState createState() => _HoverAnimatedButtonState();
}

class _HoverAnimatedButtonState extends State<HoverAnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TweenAnimationBuilder<double>(
        // Animate a value from 0.0 (no wipe) to 1.0 (full transparent background)
        tween: Tween<double>(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, progress, child) {
          // Define a gradient that "wipes" from right to left.
          // When progress is 0, stops are [1.0, 1.0] → full normalColor.
          // When progress is 1, stops are [0.0, 0.0] → full transparent.
          return Container(
            decoration: BoxDecoration(
              // The gradient goes horizontally.
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [widget.normalColor, widget.hoverColor],
                // Using the same value for both stops produces a sharp transition.
                stops: [1 - progress, 1 - progress],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton.icon(
              onPressed: widget.onPressed,
              icon: Icon(widget.icon, size: widget.fontSize + 4),
              label: Text(
                widget.label,
                style: GoogleFonts.roboto(fontSize: widget.fontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Background provided by container.
                shadowColor: Colors.transparent,
                padding: widget.padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
