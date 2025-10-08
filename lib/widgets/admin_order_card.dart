import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/admin_orders_bloc.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/core/utils/order_status_helper.dart';
import 'package:mini_wheelz/widgets/order_status_update_dialog.dart';

class AdminOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const AdminOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Tablet/Desktop layout
          return _buildHorizontalLayout(context);
        } else {
          // Mobile layout
          return _buildVerticalLayout(context);
        }
      },
    );
  }

  // 📱 Mobile layout (your original design)
  Widget _buildVerticalLayout(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 12),
            _buildUserInfo(),
            const SizedBox(height: 12),
            _buildProductInfo(),
            const SizedBox(height: 12),
            _buildOrderFooter(context),
          ],
        ),
      ),
    );
  }

  // 💻 Tablet/Desktop layout
  Widget _buildHorizontalLayout(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(),
                  const SizedBox(height: 12),
                  _buildUserInfo(),
                  const SizedBox(height: 12),
                  _buildProductDetails(),
                  const SizedBox(height: 12),
                  _buildOrderFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order #${(order['id'] as String).substring((order['id'] as String).length - 6)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    final status = order['status'] as String;
    final color = OrderStatusHelper.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        OrderStatusHelper.getStatusDisplayText(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: textSecondary),
            const SizedBox(width: 8),
            Text(order['userName'] ?? 'Unknown User'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.email, size: 16, color: textSecondary),
            const SizedBox(width: 8),
            Text(order['userEmail'] ?? 'No Email'),
          ],
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Row(
      children: [
        _buildProductImage(),
        const SizedBox(width: 12),
        Expanded(child: _buildProductDetails()),
      ],
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        order['productImage'] ?? '',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 80,
          color: lightGrey,
          child: const Icon(Icons.image_not_supported, color: textSecondary),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order['productName'] ?? 'Unknown Product',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          'Category: ${order['productCategory'] ?? 'Unknown'}',
          style: const TextStyle(fontSize: 12, color: textSecondary),
        ),
        Text(
          'Qty: ${order['quantity'] ?? 0}',
          style: const TextStyle(fontSize: 12, color: textSecondary),
        ),
        Text(
          '₹${(order['totalAmount'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Placed: ${OrderStatusHelper.formatDate(order['createdAt'] as Timestamp?)}',
          style: const TextStyle(fontSize: 12, color: textSecondary),
        ),
        ElevatedButton(
          onPressed: () => _showStatusUpdateDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Update Status'),
        ),
      ],
    );
  }

  void _showStatusUpdateDialog(BuildContext context) {
    final adminOrdersBloc = BlocProvider.of<AdminOrdersBloc>(context);

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: adminOrdersBloc,
        child: OrderStatusUpdateDialog(order: order),
      ),
    );
  }
}
