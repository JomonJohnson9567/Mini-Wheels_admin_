import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';

InputDecoration decoration(String label, IconData icon) => InputDecoration(
  labelText: label,
  prefixIcon: Icon(icon, color: primaryColor, size: 22),
  filled: true,
  fillColor: Colors.grey.shade50,
  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
    borderRadius: BorderRadius.circular(16),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: primaryColor, width: 2),
    borderRadius: BorderRadius.circular(16),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
    borderRadius: BorderRadius.circular(16),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400, width: 2),
    borderRadius: BorderRadius.circular(16),
  ),
  labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
);
