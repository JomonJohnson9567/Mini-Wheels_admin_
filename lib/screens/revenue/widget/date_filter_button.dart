import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mini_wheelz/bloc/revenue_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/revenue/widget/date_range_picker.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => showCustomDateRangePicker(context),
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
                            ? '${DateFormat('dd-MM-yyyy').format(startDate)} - ${DateFormat('dd-MM-yyyy').format(endDate)}'
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
