import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_event.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/bloc/revenue_repository.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final RevenueRepository _repository;

  RevenueBloc(this._repository) : super(RevenueInitial()) {
    on<LoadRevenueEvent>(_onLoadRevenue);
    on<RefreshRevenueEvent>(_onRefreshRevenue);
    on<LoadRevenueWithDateRangeEvent>(_onLoadRevenueWithDateRange);
  }

  Future<void> _onLoadRevenue(
    LoadRevenueEvent event,
    Emitter<RevenueState> emit,
  ) async {
    emit(RevenueLoading());

    try {
      final revenueData = await _repository.fetchRevenueData();
      emit(RevenueLoaded(revenueData));
    } catch (e) {
      emit(RevenueError(e.toString()));
    }
  }

  Future<void> _onRefreshRevenue(
    RefreshRevenueEvent event,
    Emitter<RevenueState> emit,
  ) async {
    try {
      final revenueData = await _repository.fetchRevenueData();
      emit(RevenueLoaded(revenueData));
    } catch (e) {
      emit(RevenueError(e.toString()));
    }
  }

  Future<void> _onLoadRevenueWithDateRange(
    LoadRevenueWithDateRangeEvent event,
    Emitter<RevenueState> emit,
  ) async {
    emit(RevenueLoading());

    try {
      final revenueData = await _repository.fetchRevenueData(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(
        RevenueLoaded(
          revenueData,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e) {
      emit(RevenueError(e.toString()));
    }
  }
}
