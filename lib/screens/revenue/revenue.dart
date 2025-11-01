// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_event.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/bloc/revenue_repository.dart';
import 'package:mini_wheelz/core/colors.dart';

import 'package:mini_wheelz/screens/revenue/widget/layouts.dart';
import 'package:mini_wheelz/widgets/responsive.dart';

import 'package:intl/intl.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RevenueBloc(RevenueRepository())..add(LoadRevenueEvent()),
      child: Scaffold(
        backgroundColor: backgroundColor,

        body: ResponsiveLayout(
          mobile: (_) => buildMobileLayout(context),
          tablet: (_) => buildTabletLayout(context),
          desktop: (_) => buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget buildDateFilterButton(BuildContext context) {
    return BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        DateTime? startDate;
        DateTime? endDate;

        if (state is RevenueLoaded) {
          startDate = state.startDate;
          endDate = state.endDate;
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _showDateRangePicker(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date Range',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          startDate != null && endDate != null
                              ? '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}'
                              : 'All Time',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      context.read<RevenueBloc>().add(
        LoadRevenueWithDateRangeEvent(
          startDate: picked.start,
          endDate: picked.end,
        ),
      );
    }
  }
}
