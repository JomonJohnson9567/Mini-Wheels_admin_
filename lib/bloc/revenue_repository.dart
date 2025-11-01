import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';

class RevenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RevenueData> fetchRevenueData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Get all users
      final usersSnapshot = await _firestore.collection('users').get();

      double todayEarnings = 0.0;
      double weekEarnings = 0.0;
      double monthEarnings = 0.0;
      double totalEarnings = 0.0;
      int totalOrders = 0;
      int todayOrders = 0;
      int weekOrders = 0;
      int monthOrders = 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final monthStart = DateTime(now.year, now.month, 1);

      // Initialize chart data map
      final Map<String, ChartDataPoint> chartDataMap = {};

      // Get orders from each user
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('orders')
            .get();

        for (var orderDoc in ordersSnapshot.docs) {
          final orderData = orderDoc.data();
          final totalAmount =
              (orderData['totalAmount'] as num?)?.toDouble() ?? 0.0;
          final createdAt = orderData['createdAt'] as Timestamp?;
          final status = orderData['status'] as String?;

          // Only count completed/delivered orders for revenue
          if (status == 'delivered' || status == 'completed') {
            if (createdAt != null) {
              final orderDate = createdAt.toDate();
              final orderDateTime = DateTime(
                orderDate.year,
                orderDate.month,
                orderDate.day,
              );

              // Apply date range filter if provided
              bool isInRange = true;
              if (startDate != null && endDate != null) {
                final filterStart = DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day,
                );
                final filterEnd = DateTime(
                  endDate.year,
                  endDate.month,
                  endDate.day,
                ).add(const Duration(days: 1));

                isInRange =
                    orderDateTime.isAfter(
                      filterStart.subtract(const Duration(milliseconds: 1)),
                    ) &&
                    orderDateTime.isBefore(filterEnd);
              }

              // Build chart data for ALL orders (not filtered)
              final dateKey =
                  '${orderDateTime.year}-${orderDateTime.month}-${orderDateTime.day}';
              if (chartDataMap.containsKey(dateKey)) {
                final existing = chartDataMap[dateKey]!;
                chartDataMap[dateKey] = ChartDataPoint(
                  date: existing.date,
                  revenue: existing.revenue + totalAmount,
                  orders: existing.orders + 1,
                );
              } else {
                chartDataMap[dateKey] = ChartDataPoint(
                  date: orderDateTime,
                  revenue: totalAmount,
                  orders: 1,
                );
              }

              // Only count stats if in range (for card display)
              if (!isInRange) {
                continue;
              }

              totalEarnings += totalAmount;
              totalOrders++;

              // Today's earnings (only if in today's range)
              if (orderDateTime.isAtSameMomentAs(today)) {
                todayEarnings += totalAmount;
                todayOrders++;
              }

              // This week's earnings (only if in this week's range)
              if (orderDate.isAfter(
                weekStart.subtract(const Duration(days: 1)),
              )) {
                weekEarnings += totalAmount;
                weekOrders++;
              }

              // This month's earnings (only if in this month's range)
              if (orderDate.isAfter(
                monthStart.subtract(const Duration(days: 1)),
              )) {
                monthEarnings += totalAmount;
                monthOrders++;
              }
            }
          }
        }
      }

      // Convert chart data map to sorted list
      final chartData = chartDataMap.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return RevenueData(
        todayEarnings: todayEarnings,
        weekEarnings: weekEarnings,
        monthEarnings: monthEarnings,
        totalEarnings: totalEarnings,
        totalOrders: totalOrders,
        todayOrders: todayOrders,
        weekOrders: weekOrders,
        monthOrders: monthOrders,
        chartData: chartData,
      );
    } catch (e) {
      throw Exception('Failed to fetch revenue data: $e');
    }
  }
}
