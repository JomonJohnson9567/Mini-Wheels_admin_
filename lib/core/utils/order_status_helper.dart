import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/core/colors.dart';

class OrderStatusHelper {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return vibrantBlue;
      case 'accepted':
        return secondaryColor;
      case 'shipped':
        return vibrantCyan;
      case 'outfordelivery':
        return vibrantOrange;
      case 'delivered':
        return successColor;
      case 'pending':
        return warningColor;
      case 'failed':
        return errorColor;
      case 'cancelled':
        return greyColor;
      default:
        return primaryColor;
    }
  }

  static String getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Payment Completed';
      case 'accepted':
        return 'Accepted';
      case 'shipped':
        return 'Shipped';
      case 'outfordelivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  static String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static List<Map<String, String>> getStatusOptions() {
    return [
      {'value': 'all', 'label': 'All Orders'},
      {'value': 'paid', 'label': 'Payment Completed'},
      {'value': 'accepted', 'label': 'Accepted'},
      {'value': 'shipped', 'label': 'Shipped'},
      {'value': 'outfordelivery', 'label': 'Out for Delivery'},
      {'value': 'delivered', 'label': 'Delivered'},
      {'value': 'pending', 'label': 'Pending'},
      {'value': 'completed', 'label': 'Completed'},
      {'value': 'failed', 'label': 'Failed'},
      {'value': 'cancelled', 'label': 'Cancelled'},
    ];
  }

  static List<Map<String, String>> getUpdateStatusOptions() {
    return [
      {'value': 'accepted', 'label': 'Accepted'},
      {'value': 'shipped', 'label': 'Shipped'},
      {'value': 'outForDelivery', 'label': 'Out for Delivery'},
      {'value': 'delivered', 'label': 'Delivered'},
    ];
  }
}
