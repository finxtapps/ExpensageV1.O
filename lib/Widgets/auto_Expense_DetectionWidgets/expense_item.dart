import 'package:flutter/material.dart';

class ExpenseItem {
  final String time;
  final String minutesAgo;
  final String status;
  final Color statusColor;
  final IconData icon;
  final bool showEdit;

  ExpenseItem({
    required this.time,
    required this.minutesAgo,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.showEdit = false,
  });
}
