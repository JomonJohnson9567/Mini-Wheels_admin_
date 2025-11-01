import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/screens/revenue/widget/chart_selection.dart';
import 'package:mini_wheelz/screens/revenue/widget/date_filter_button.dart';
import 'package:mini_wheelz/screens/revenue/widget/error_state.dart';
import 'package:mini_wheelz/screens/revenue/widget/loading_state.dart';
import 'package:mini_wheelz/screens/revenue/widget/revenue_grid_view.dart';

Widget buildContent(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      // Date Filter Button
      buildDateFilterButton(context),
      const SizedBox(height: 24),
      // Revenue Cards GridView
      BlocBuilder<RevenueBloc, RevenueState>(
        builder: (context, state) {
          if (state is RevenueLoading) {
            return buildLoadingState();
          } else if (state is RevenueLoaded) {
            return Column(
              children: [
                buildRevenueGridView(context, state.revenueData),
                const SizedBox(height: 24),
                // Chart Section
                buildChartSection(context, state.revenueData),
              ],
            );
          } else if (state is RevenueError) {
            return buildErrorState(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}
