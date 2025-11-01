import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_event.dart';
import 'package:mini_wheelz/core/colors.dart';

Future<void> showCustomDateRangePicker(BuildContext context) async {
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
