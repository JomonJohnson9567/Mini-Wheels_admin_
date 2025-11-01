abstract class RevenueEvent {}

class LoadRevenueEvent extends RevenueEvent {}

class RefreshRevenueEvent extends RevenueEvent {}

class LoadRevenueWithDateRangeEvent extends RevenueEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadRevenueWithDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });
}
