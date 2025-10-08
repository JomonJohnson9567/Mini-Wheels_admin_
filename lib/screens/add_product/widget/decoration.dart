import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';

InputDecoration decoration(String label, IconData icon) => InputDecoration(
  labelText: label,
  prefixIcon: Icon(icon, color: primaryColor, size: 22),
  filled: true,
  fillColor: lightGrey,
  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: borderGrey, width: 1.5),
    borderRadius: BorderRadius.circular(16),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: primaryColor, width: 2),
    borderRadius: BorderRadius.circular(16),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: errorColor, width: 1.5),
    borderRadius: BorderRadius.circular(16),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: errorColor, width: 2),
    borderRadius: BorderRadius.circular(16),
  ),
  labelStyle: const TextStyle(color: textSecondary, fontSize: 15),
);
