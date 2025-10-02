import 'package:flutter/material.dart';

// Primary Brand Colors
const Color primaryColor = Color(0xFF6366F1); // Indigo
const Color primaryLight = Color(0xFF818CF8); // Light Indigo
const Color primaryDark = Color(0xFF4F46E5); // Dark Indigo

// Secondary Colors
const Color secondaryColor = Color(0xFF10B981); // Emerald
const Color secondaryLight = Color(0xFF34D399); // Light Emerald
const Color secondaryDark = Color(0xFF059669); // Dark Emerald

// Accent Colors
const Color accentColor = Color(0xFFF59E0B); // Amber
const Color accentLight = Color(0xFFFBBF24); // Light Amber
const Color accentDark = Color(0xFFD97706); // Dark Amber

// Vibrant Colors
const Color vibrantPink = Color(0xFFEC4899); // Pink
const Color vibrantPurple = Color(0xFF8B5CF6); // Violet
const Color vibrantBlue = Color(0xFF3B82F6); // Blue
const Color vibrantCyan = Color(0xFF06B6D4); // Cyan
const Color vibrantOrange = Color(0xFFF97316); // Orange
const Color vibrantRed = Color(0xFFEF4444); // Red

// Neutral Colors
const Color whiteColor = Colors.white;
const Color blackColor = Color(0xFF1F2937); // Dark Gray
const Color greyColor = Color(0xFF6B7280); // Gray
const Color lightGrey = Color(0xFFF3F4F6); // Light Gray
const Color darkGrey = Color(0xFF374151); // Dark Gray

// Status Colors
const Color successColor = Color(0xFF10B981); // Green
const Color warningColor = Color(0xFFF59E0B); // Amber
const Color errorColor = Color(0xFFEF4444); // Red
const Color infoColor = Color(0xFF3B82F6); // Blue

// Background Colors
const Color backgroundColor = Color(0xFFF8FAFC); // Very Light Gray
const Color surfaceColor = Color(0xFFFFFFFF); // White
const Color cardColor = Color(0xFFFFFFFF); // White

// Text Colors
const Color textPrimary = Color(0xFF1F2937); // Dark Gray
const Color textSecondary = Color(0xFF6B7280); // Gray
const Color textLight = Color(0xFF9CA3AF); // Light Gray

// Gradient Colors
const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient secondaryGradient = LinearGradient(
  colors: [secondaryColor, secondaryLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient accentGradient = LinearGradient(
  colors: [accentColor, accentLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient vibrantGradient = LinearGradient(
  colors: [vibrantPink, vibrantPurple, vibrantBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Legacy colors for backward compatibility
const Color appTitleColor = textPrimary;
const Color brownColr = Color(0xFF8B5A2B);
const Color redColor = errorColor;
