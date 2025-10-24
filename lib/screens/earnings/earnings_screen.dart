import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/widgets/earnings_card.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkBg = const Color(0xFF0B0D10);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Earnings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              EarningsCard(
                title: 'Epoch 12\nEarnings:',
                value: '214.74K',
                leadingIcon: Icons.leaderboard_rounded,
              ),
              SizedBox(height: 16),
              EarningsCard(
                title: "Today's\nEarnings:",
                value: '12.5',
                subtitle: 'Uptime: 0 day, 0 hr, 10 mins',
                leadingIcon: Icons.today_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
