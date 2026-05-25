import 'package:flutter/material.dart';

class RequestItem {
  const RequestItem({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  final String title;
  final String status;
  final Color statusColor;
  final IconData icon;
}
