import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomCircularIndicator extends StatelessWidget {
  final double percentage; // expected value between 0 and 100
  const CustomCircularIndicator({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    const double size = 300.0; // increased size
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade800,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            strokeWidth: 2, // thicker stroke
          ),
          Text(
            "${percentage.toStringAsFixed(0)}%",
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
