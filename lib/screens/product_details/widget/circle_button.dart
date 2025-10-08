// 🔥 Circle Button for AppBar
import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';

Widget circleButton(
  BuildContext context, {
  required IconData icon,
  Color color = textPrimary,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    decoration: BoxDecoration(
      color: whiteColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: blackColor.withOpacity(0.1),
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: color, size: 20),
      onPressed: onTap,
    ),
  );
}

  // 🔥 Gradient Info Card

