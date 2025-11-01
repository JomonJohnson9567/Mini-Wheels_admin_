abstract class RevenueState {}

class RevenueInitial extends RevenueState {}

class RevenueLoading extends RevenueState {}

class RevenueLoaded extends RevenueState {
  final RevenueData revenueData;
  final DateTime? startDate;
  final DateTime? endDate;

  RevenueLoaded(this.revenueData, {this.startDate, this.endDate});
}

class RevenueError extends RevenueState {
  final String message;

  RevenueError(this.message);
}

class RevenueData {
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final double totalEarnings;
  final int totalOrders;
  final int todayOrders;
  final int weekOrders;
  final int monthOrders;
  final List<ChartDataPoint> chartData;

  RevenueData({
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.totalEarnings,
    required this.totalOrders,
    required this.todayOrders,
    required this.weekOrders,
    required this.monthOrders,
    required this.chartData,
  });
}

class ChartDataPoint {
  final DateTime date;
  final double revenue;
  final int orders;

  ChartDataPoint({
    required this.date,
    required this.revenue,
    required this.orders,
  });
}
