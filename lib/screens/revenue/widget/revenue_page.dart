import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_bloc.dart';
import 'package:mini_wheelz/bloc/revenue_event.dart';
import 'package:mini_wheelz/bloc/revenue_state.dart';
import 'package:mini_wheelz/bloc/revenue_repository.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/revenue/widget/format_currency.dart';
import 'package:mini_wheelz/widgets/responsive.dart';
import 'package:shimmer/shimmer.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RevenueBloc(RevenueRepository())..add(LoadRevenueEvent()),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: whiteColor, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Revenue Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
            ),
          ),
          actions: [
            BlocBuilder<RevenueBloc, RevenueState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<RevenueBloc>().add(RefreshRevenueEvent());
                  },
                  icon: const Icon(Icons.refresh, color: whiteColor, size: 28),
                );
              },
            ),
          ],
        ),
        body: ResponsiveLayout(
          mobile: (_) => _buildMobileLayout(context),
          tablet: (_) => _buildTabletLayout(context),
          desktop: (_) => _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildContent(context, 18, const EdgeInsets.all(16)),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildContent(context, 20, const EdgeInsets.all(24)),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _buildContent(context, 22, const EdgeInsets.all(32)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    double titleFontSize,
    EdgeInsets padding,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        BlocBuilder<RevenueBloc, RevenueState>(
          builder: (context, state) {
            if (state is RevenueLoading) {
              return _buildLoadingState();
            } else if (state is RevenueLoaded) {
              return _buildLoadedState(context, state.revenueData);
            } else if (state is RevenueError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: shimmerBase,
            highlightColor: shimmerHighlight,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: shimmerBase,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, RevenueData revenueData) {
    return Column(
      children: [
        // Top row - Today and Total
        Row(
          children: [
            Expanded(
              child: _buildRevenueCard(
                title: 'Today\'s Revenue',
                amount: revenueData.todayEarnings,
                orders: revenueData.todayOrders,
                icon: Icons.today,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildRevenueCard(
                title: 'Total Revenue',
                amount: revenueData.totalEarnings,
                orders: revenueData.totalOrders,
                icon: Icons.attach_money,
                color: successColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Bottom row - Week and Month
        Row(
          children: [
            Expanded(
              child: _buildRevenueCard(
                title: 'This Week\'s Revenue',
                amount: revenueData.weekEarnings,
                orders: revenueData.weekOrders,
                icon: Icons.calendar_view_week,
                color: vibrantBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildRevenueCard(
                title: 'This Month\'s Revenue',
                amount: revenueData.monthEarnings,
                orders: revenueData.monthOrders,
                icon: Icons.calendar_month,
                color: secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRevenueCard({
    required String title,
    required double amount,
    required int orders,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: greyColor.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              formatCurrency(amount),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.shopping_cart, size: 16, color: textSecondary),
                const SizedBox(width: 4),
                Text(
                  '$orders orders',
                  style: const TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Card(
      color: whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: errorColor, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error loading revenue data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<RevenueBloc>().add(LoadRevenueEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
