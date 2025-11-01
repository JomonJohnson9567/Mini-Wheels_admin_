import 'package:flutter/material.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/revenue/widget/revenue_card_widget.dart';

Widget buildRevenueGridView(BuildContext context, RevenueData revenueData) {
  final cards = [
    buildRevenueCard(
      title: 'Daily Revenue',
      amount: revenueData.todayEarnings,
      orders: revenueData.todayOrders,
      icon: Icons.today,
      color: primaryColor,
    ),
    buildRevenueCard(
      title: 'Weekly Revenue',
      amount: revenueData.weekEarnings,
      orders: revenueData.weekOrders,
      icon: Icons.calendar_view_week,
      color: vibrantBlue,
    ),
    buildRevenueCard(
      title: 'Monthly Revenue',
      amount: revenueData.monthEarnings,
      orders: revenueData.monthOrders,
      icon: Icons.calendar_month,
      color: secondaryColor,
    ),
    buildRevenueCard(
      title: 'Total Revenue',
      amount: revenueData.totalEarnings,
      orders: revenueData.totalOrders,
      icon: Icons.attach_money,
      color: successColor,
    ),
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    ),
    itemCount: cards.length,
    itemBuilder: (context, index) => cards[index],
  );
}
