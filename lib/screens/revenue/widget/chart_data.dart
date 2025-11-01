import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/revenue/widget/format_currency.dart';

BarChartData buildChartData(List<ChartDataPoint> chartData) {
  final barGroups = chartData.asMap().entries.map((entry) {
    final index = entry.key;
    final point = entry.value;
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: point.revenue,
          color: primaryColor,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }).toList();

  return BarChartData(
    barTouchData: BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => primaryColor,
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.all(8),
        tooltipMargin: 8,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            formatCurrency(rod.toY),
            const TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          );
        },
      ),
    ),
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 1000,
      getDrawingHorizontalLine: (value) {
        return FlLine(color: greyColor.withOpacity(0.2), strokeWidth: 1);
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= 0 && value.toInt() < chartData.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('MMM dd').format(chartData[value.toInt()].date),
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 1000,
          getTitlesWidget: (value, meta) {
            return Text(
              formatCurrency(value),
              style: const TextStyle(
                color: textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: greyColor.withOpacity(0.2)),
    ),
    minY: 0,
    maxY: chartData.isEmpty
        ? 0
        : chartData.map((e) => e.revenue).reduce((a, b) => a > b ? a : b) * 1.2,
    barGroups: barGroups,
  );
}
