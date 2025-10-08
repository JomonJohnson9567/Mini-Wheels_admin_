import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/admin_orders_bloc.dart';
import 'package:mini_wheelz/bloc/admin_orders_event.dart';
import 'package:mini_wheelz/bloc/admin_orders_state.dart';
import 'package:mini_wheelz/widgets/admin_order_card.dart';
import 'package:mini_wheelz/core/colors.dart';

class AdminOrdersList extends StatelessWidget {
  const AdminOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
      builder: (context, state) {
        if (state is AdminOrdersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminOrdersLoadedState) {
          if (state.orders.isEmpty) {
            return _buildEmptyState();
          }
          return _buildOrdersList(context, state.orders);
        } else if (state is AdminOrdersErrorState) {
          return _buildErrorState(context, state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<Map<String, dynamic>> orders,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AdminOrdersBloc>().add(LoadAllOrdersEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return AdminOrderCard(order: order);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: textSecondary),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(fontSize: 18, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: errorColor),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AdminOrdersBloc>().add(LoadAllOrdersEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
