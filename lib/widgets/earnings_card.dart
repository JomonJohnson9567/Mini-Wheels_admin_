import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';

class EarningsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? leadingIcon;

  const EarningsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color darkCard = const Color(0xFF1F2228);
    final Color darkSurface = const Color(0xFF0F1115);

    return Container(
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leadingIcon != null)
                Container(
                  decoration: BoxDecoration(
                    color: darkSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(leadingIcon, color: secondaryLight),
                ),
              if (leadingIcon != null) const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.eco_rounded,
                color: priceCardColor,
                size: 26,
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white38, size: 18),
                const SizedBox(width: 6),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
