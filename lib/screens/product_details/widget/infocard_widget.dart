import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';

Widget infoCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color1,
  required Color color2,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color1, color2]),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: color1.withOpacity(0.25),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: whiteColor, size: 22),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: whiteColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
